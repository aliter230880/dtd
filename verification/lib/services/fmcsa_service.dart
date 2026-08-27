/// Уровень 2 для DOT/MC — FMCSA QCMobile.
///
/// Проверено вживую: без webKey API отвечает {"content":"Webkey not found"}.
/// Значит ключ обязателен, и держать его в клиенте НЕЛЬЗЯ — иначе он
/// вытаскивается из APK/JS. Поэтому клиент зовёт Cloud Function
/// `verifyCarrier`, а та проксирует запрос с ключом из конфига.
///
/// Здесь два режима:
///  • production — вызов Cloud Function (боевой путь);
///  • demo — детерминированный симулятор для этого превью, где нет
///    ни ключа FMCSA, ни задеплоенных функций.
/// Симулятор намеренно НЕ пропускает всё подряд: он моделирует
/// отозванный авторитет и отсутствие записи — ровно те случаи, которые
/// текущий mock `verifyCarrier` в проекте не различает (принимает DOT 12345).
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
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
  /// URL Cloud Function. Пусто → работает демо-режим.
  final String? cloudFunctionUrl;
  final http.Client _client;

  FmcsaService({this.cloudFunctionUrl, http.Client? client})
      : _client = client ?? http.Client();

  bool get isDemo => !(cloudFunctionUrl?.isNotEmpty ?? false);

  Future<VerificationResult> verifyDot(String rawDot) async {
    final local = Validators.validateDot(rawDot);
    if (local.status != VerificationStatus.checking) return local;

    final dot = rawDot.trim();
    if (isDemo) return _demoLookup(dot);

    try {
      final resp = await _client
          .post(
            Uri.parse(cloudFunctionUrl!),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'dotNumber': dot}),
          )
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode != 200) {
        return VerificationResult.unavailable(
            'Реестр FMCSA недоступен (${resp.statusCode})');
      }
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return _fromPayload(data, dot);
    } catch (_) {
      return VerificationResult.unavailable(
        'Не удалось связаться с реестром FMCSA. Данные сохранятся, '
        'проверку повторим автоматически',
      );
    }
  }

  VerificationResult _fromPayload(Map<String, dynamic> data, String dot) {
    if (data['found'] != true) {
      return VerificationResult(
        status: VerificationStatus.notFound,
        tier: VerificationTier.registry,
        message: 'Перевозчик с USDOT $dot не найден в реестре FMCSA',
        source: 'fmcsa_qcmobile',
        checkedAt: DateTime.now(),
      );
    }
    final c = data['carrier'] as Map<String, dynamic>;
    final allowed = c['allowedToOperate'] == true;
    final now = DateTime.now();

    if (!allowed) {
      return VerificationResult(
        status: VerificationStatus.mismatch,
        tier: VerificationTier.registry,
        message: 'FMCSA: у перевозчика "${c['legalName']}" НЕТ действующего '
            'разрешения на перевозки (allowedToOperate = N)',
        source: 'fmcsa_qcmobile',
        checkedAt: now,
        raw: c,
      );
    }

    return VerificationResult(
      status: VerificationStatus.verified,
      tier: VerificationTier.registry,
      message: '${c['legalName']} — подтверждено FMCSA',
      autofill: {
        'Юр. название': '${c['legalName']}',
        if (c['dbaName'] != null && '${c['dbaName']}'.isNotEmpty)
          'DBA': '${c['dbaName']}',
        'Адрес': '${c['address']}',
        'Safety rating': '${c['safetyRating'] ?? 'не присвоен'}',
        if (c['mcNumber'] != null) 'MC': 'MC-${c['mcNumber']}',
        if (c['powerUnits'] != null) 'Тягачей': '${c['powerUnits']}',
        if (c['drivers'] != null) 'Водителей': '${c['drivers']}',
      },
      source: 'fmcsa_qcmobile',
      checkedAt: now,
      // Авторитет и рейтинг отзываются — проверка обязана истекать.
      expiresAt: now.add(const Duration(days: 30)),
      raw: c,
    );
  }

  // -----------------------------------------------------------------
  // Демо-режим: детерминированные ответы для превью.
  // -----------------------------------------------------------------
  static const Map<String, Map<String, dynamic>> _demoDb = {
    '76830': {
      'found': true,
      'carrier': {
        'legalName': 'SWIFT TRANSPORTATION CO OF ARIZONA LLC',
        'dbaName': 'SWIFT TRANSPORTATION',
        'address': '2200 S 75TH AVE, PHOENIX, AZ 85043',
        'safetyRating': 'Satisfactory',
        'allowedToOperate': true,
        'powerUnits': 18342,
        'drivers': 17650,
        'mcNumber': '135790',
      },
    },
    '65119': {
      'found': true,
      'carrier': {
        'legalName': 'J B HUNT TRANSPORT INC',
        'address': '615 J B HUNT CORPORATE DR, LOWELL, AR 72745',
        'safetyRating': 'Satisfactory',
        'allowedToOperate': true,
        'powerUnits': 12500,
        'drivers': 14200,
        'mcNumber': '130350',
      },
    },
    '1000001': {
      'found': true,
      'carrier': {
        'legalName': 'RELIABLE AUTO CARRIERS LLC',
        'address': '410 W COMMERCE ST, DALLAS, TX 75208',
        'safetyRating': 'Conditional',
        'allowedToOperate': true,
        'powerUnits': 12,
        'drivers': 15,
        'mcNumber': '884210',
      },
    },
    // Ключевой кейс: запись есть, но авторитет отозван → mismatch.
    '2000002': {
      'found': true,
      'carrier': {
        'legalName': 'OUT OF SERVICE HAULERS INC',
        'address': '77 DEPOT RD, NEWARK, NJ 07105',
        'safetyRating': 'Unsatisfactory',
        'allowedToOperate': false,
        'powerUnits': 3,
        'drivers': 2,
      },
    },
  };

  Future<VerificationResult> _demoLookup(String dot) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final hit = _demoDb[dot];
    if (hit == null) {
      // Именно так должен вести себя реальный API с DOT 12345,
      // который текущий mock проекта пропускает как валидный.
      return VerificationResult(
        status: VerificationStatus.notFound,
        tier: VerificationTier.registry,
        message: 'Перевозчик с USDOT $dot не найден в реестре FMCSA. '
            'В демо-режиме доступны: 76830, 65119, 1000001, 2000002',
        source: 'fmcsa_qcmobile_demo',
        checkedAt: DateTime.now(),
      );
    }
    return _fromPayload(hit, dot);
  }
}
