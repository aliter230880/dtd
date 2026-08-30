/// Уровень 2 для DOT/MC — FMCSA QCMobile.
///
/// Проверено вживую: без webKey API отвечает {"content":"Webkey not found"}.
/// Значит ключ обязателен, и держать его в клиенте НЕЛЬЗЯ — иначе он
/// вытаскивается из APK. Поэтому клиент зовёт callable Cloud Function
/// `verifyCarrierDot`, а та проксирует запрос с ключом из конфига и сама
/// пишет результат в users/{uid}.verification.
///
/// Пока функция не задеплоена, callable отвечает `not-found`/`internal` —
/// в этом случае работает демо-справочник, а пользователь видит, что
/// проверка идёт в демо-режиме.
library;

import 'package:cloud_functions/cloud_functions.dart';
import '../models/verification.dart';
import 'validators.dart';

class CarrierRegistryData {
  final String legalName;
  final String? dbaName;
  final String address;
  final String? safetyRating;
  final bool allowedToOperate;
  final int? powerUnits;
  final int? drivers;
  final String? mcNumber;

  const CarrierRegistryData({
    required this.legalName,
    this.dbaName,
    required this.address,
    this.safetyRating,
    required this.allowedToOperate,
    this.powerUnits,
    this.drivers,
    this.mcNumber,
  });
}

class FmcsaService {
  /// Имя callable-функции. Совпадает с exports в functions/index.js.
  static const callableName = 'verifyCarrierDot';

  FmcsaService();

  /// Стал ли последний вызов демо-ответом (функция не задеплоена).
  bool lastCallWasDemo = false;

  Future<VerificationResult> verifyDot(String rawDot) async {
    final local = Validators.validateDot(rawDot);
    if (local.status != VerificationStatus.checking) return local;

    final dot = rawDot.trim();
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable(callableName);
      final result = await callable.call<Map<String, dynamic>>({
        'dotNumber': dot,
      });
      lastCallWasDemo = false;
      return _fromCallable(Map<String, dynamic>.from(result.data), dot);
    } on FirebaseFunctionsException catch (e) {
      // Функция ещё не задеплоена — честный демо-режим вместо тишины.
      if (e.code == 'not-found' ||
          e.code == 'unimplemented' ||
          e.code == 'internal') {
        lastCallWasDemo = true;
        return _demoLookup(dot);
      }
      if (e.code == 'invalid-argument') {
        return VerificationResult.invalidFormat(
            e.message ?? 'USDOT указан неверно');
      }
      if (e.code == 'resource-exhausted') {
        return VerificationResult.unavailable(
            'Слишком много проверок подряд. Повторите через несколько минут');
      }
      if (e.code == 'unauthenticated') {
        return VerificationResult.unavailable(
            'Войдите в аккаунт, чтобы проверить номер в реестре');
      }
      return VerificationResult.unavailable(
          e.message ?? 'Реестр FMCSA недоступен');
    } catch (_) {
      return VerificationResult.unavailable(
        'Не удалось связаться с реестром FMCSA. Данные сохранятся, '
        'проверку повторим автоматически',
      );
    }
  }

  /// Ответ callable-функции verifyCarrierDot.
  VerificationResult _fromCallable(Map<String, dynamic> data, String dot) {
    final status = '${data['status'] ?? ''}';
    final now = DateTime.now();

    switch (status) {
      case 'verified':
        final c = Map<String, dynamic>.from(
            (data['carrier'] as Map?) ?? const <String, dynamic>{});
        DateTime? expires;
        final rawExpires = data['expiresAt'];
        if (rawExpires is String) expires = DateTime.tryParse(rawExpires);
        return VerificationResult(
          status: VerificationStatus.verified,
          tier: VerificationTier.registry,
          message: '${c['legal_name'] ?? 'Перевозчик'} — подтверждено FMCSA',
          autofill: _autofillFromServer(c),
          source: 'fmcsa_qcmobile',
          checkedAt: now,
          expiresAt: expires ?? now.add(const Duration(days: 30)),
          raw: c,
        );
      case 'mismatch':
        return VerificationResult(
          status: VerificationStatus.mismatch,
          tier: VerificationTier.registry,
          message: 'FMCSA: у перевозчика '
              '"${data['legalName'] ?? 'по этому USDOT'}" НЕТ действующего '
              'разрешения на перевозки (allowedToOperate = N)',
          source: 'fmcsa_qcmobile',
          checkedAt: now,
        );
      case 'not_found':
        return VerificationResult(
          status: VerificationStatus.notFound,
          tier: VerificationTier.registry,
          message: 'Перевозчик с USDOT $dot не найден в реестре FMCSA',
          source: 'fmcsa_qcmobile',
          checkedAt: now,
        );
      default:
        return VerificationResult.unavailable(
          'Реестр FMCSA пока недоступен. Формат номера верен — '
          'данные сохранятся, проверку повторим позже',
        );
    }
  }

  /// Ключи с сервера (snake_case) → подписи для интерфейса.
  Map<String, String> _autofillFromServer(Map<String, dynamic> c) {
    String v(String key) => '${c[key] ?? ''}'.trim();
    return {
      if (v('legal_name').isNotEmpty) 'Юр. название': v('legal_name'),
      if (v('dba_name').isNotEmpty) 'DBA': v('dba_name'),
      if (v('address').isNotEmpty) 'Адрес': v('address'),
      if (v('safety_rating').isNotEmpty)
        'Safety rating':
            v('safety_rating') == 'none' ? 'не присвоен' : v('safety_rating'),
      if (v('power_units').isNotEmpty) 'Тягачей': v('power_units'),
      if (v('drivers').isNotEmpty) 'Водителей': v('drivers'),
    };
  }

  // -----------------------------------------------------------------
  // Демо-режим: пока Cloud Function не задеплоена.
  // -----------------------------------------------------------------
  static const Map<String, Map<String, dynamic>> _demoDb = {
    '76830': {
      'legal_name': 'SWIFT TRANSPORTATION CO OF ARIZONA LLC',
      'dba_name': 'SWIFT TRANSPORTATION',
      'address': '2200 S 75TH AVE, PHOENIX, AZ 85043',
      'safety_rating': 'Satisfactory',
      'allowed': true,
      'power_units': '18342',
      'drivers': '17650',
    },
    '65119': {
      'legal_name': 'J B HUNT TRANSPORT INC',
      'address': '615 J B HUNT CORPORATE DR, LOWELL, AR 72745',
      'safety_rating': 'Satisfactory',
      'allowed': true,
      'power_units': '12500',
      'drivers': '14200',
    },
    '1000001': {
      'legal_name': 'RELIABLE AUTO CARRIERS LLC',
      'address': '410 W COMMERCE ST, DALLAS, TX 75208',
      'safety_rating': 'Conditional',
      'allowed': true,
      'power_units': '12',
      'drivers': '15',
    },
    // Ключевой кейс: запись есть, но авторитет отозван → mismatch.
    '2000002': {
      'legal_name': 'OUT OF SERVICE HAULERS INC',
      'address': '77 DEPOT RD, NEWARK, NJ 07105',
      'safety_rating': 'Unsatisfactory',
      'allowed': false,
    },
  };

  Future<VerificationResult> _demoLookup(String dot) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final hit = _demoDb[dot];
    if (hit == null) {
      return VerificationResult(
        status: VerificationStatus.notFound,
        tier: VerificationTier.registry,
        message: 'Демо-режим: проверка FMCSA ещё не задеплоена. '
            'Доступны номера 76830, 65119, 1000001, 2000002',
        source: 'fmcsa_qcmobile_demo',
        checkedAt: DateTime.now(),
      );
    }
    if (hit['allowed'] != true) {
      return VerificationResult(
        status: VerificationStatus.mismatch,
        tier: VerificationTier.registry,
        message: 'Демо-режим: у "${hit['legal_name']}" нет действующего '
            'разрешения на перевозки (allowedToOperate = N)',
        source: 'fmcsa_qcmobile_demo',
        checkedAt: DateTime.now(),
      );
    }
    final now = DateTime.now();
    return VerificationResult(
      status: VerificationStatus.verified,
      tier: VerificationTier.registry,
      message: 'Демо-режим: ${hit['legal_name']}',
      autofill: _autofillFromServer(hit),
      source: 'fmcsa_qcmobile_demo',
      checkedAt: now,
      expiresAt: now.add(const Duration(days: 30)),
    );
  }
}
