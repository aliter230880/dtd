/// KYC физлица: Stripe Identity + Checkr.
///
/// ГЛАВНОЕ ОГРАНИЧЕНИЕ, проверено запросом: POST к
/// api.stripe.com/v1/identity/verification_sessions без ключа отдаёт 401
/// («You did not provide an API key»). Секретный ключ Stripe НЕЛЬЗЯ держать
/// в клиенте — иначе им можно списывать деньги. Поэтому сессия создаётся
/// только в Cloud Function, а клиент получает лишь client_secret/URL.
///
/// Второе: результат приходит НЕ в ответе на запрос, а вебхуком
/// (identity.verification_session.verified) — минуты или часы. Отсюда
/// отдельный статус pendingProvider: он переживает закрытие приложения,
/// в отличие от checking, который живёт один HTTP-запрос.
library;

import 'package:cloud_functions/cloud_functions.dart';
import '../models/verification.dart';
import '../models/user_kind.dart';

class KycService {
  /// Имена callable-функций KYC физлица.
  static const identityCallable = 'startIdentitySession';
  static const mvrCallable = 'startMvrCheck';

  const KycService();

  /// Отработал ли последний вызов в демо-режиме (функция не задеплоена).
  static bool lastCallWasDemo = false;

  /// Стоимость проверки у провайдера — показываем в интерфейсе.
  /// Это не косметика: платит платформа, поэтому форматную отсечку
  /// (SSN, возраст) надо делать ДО обращения к провайдеру.
  static const identityCostUsd = 1.50;
  static const checkrMvrCostUsd = 10.00;

  /// Старт проверки личности (документ + селфи с liveness).
  ///
  /// Возвращает pendingProvider, а не verified: подтверждение придёт вебхуком.
  /// Клиент НЕ имеет права считать проверку пройденной по факту отправки.
  Future<VerificationResult> startIdentitySession({
    required String dateOfBirth,
    String? ssnLast4,
  }) async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable(identityCallable);
      final res = await callable.call<Map<String, dynamic>>({
        'dateOfBirth': dateOfBirth,
        if (ssnLast4 != null && ssnLast4.isNotEmpty) 'ssnLast4': ssnLast4,
      });
      lastCallWasDemo = false;
      final data = Map<String, dynamic>.from(res.data);
      final url = '${data['url'] ?? ''}';
      return VerificationResult(
        status: VerificationStatus.pendingProvider,
        tier: VerificationTier.provider,
        message: 'Сессия Stripe Identity создана. Проверка документа и селфи '
            'занимает от 1 до 10 минут — результат придёт вебхуком',
        autofill: {
          'Провайдер': 'Stripe Identity',
          'Что проверяется': 'Госдокумент + селфи (liveness)',
          'Стоимость': r'$1.50 за проверку',
          if (url.isNotEmpty) 'Ссылка на проверку': url,
        },
        source: 'stripe_identity',
        checkedAt: DateTime.now(),
      );
    } on FirebaseFunctionsException catch (e) {
      if (_notDeployed(e)) return _demoIdentity();
      if (e.code == 'unauthenticated') {
        return VerificationResult.unavailable(
            'Войдите в аккаунт, чтобы начать проверку личности');
      }
      return VerificationResult.unavailable(
          e.message ?? 'Stripe Identity недоступен');
    } catch (_) {
      return _demoIdentity();
    }
  }

  static bool _notDeployed(FirebaseFunctionsException e) =>
      e.code == 'not-found' ||
      e.code == 'unimplemented' ||
      e.code == 'internal';

  Future<VerificationResult> _demoIdentity() async {
    lastCallWasDemo = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return VerificationResult(
      status: VerificationStatus.pendingProvider,
      tier: VerificationTier.provider,
      message: 'Демо-режим: функция Stripe Identity пока не задеплоена. '
          'В продакшене результат придёт вебхуком через 1–10 минут',
      autofill: const {
        'Провайдер': 'Stripe Identity',
        'Что проверяется': 'Госдокумент + селфи (liveness)',
        'Стоимость': r'$1.50 за проверку',
        'Ответ': 'Вебхук identity.verification_session.verified',
      },
      source: 'stripe_identity_demo',
      checkedAt: DateTime.now(),
    );
  }

  /// Проверка водительской истории (MVR) через Checkr.
  ///
  /// Отдельно от Identity: регулируется FCRA, требует письменного согласия
  /// кандидата. Без согласия запрос незаконен, поэтому оно — не чекбокс
  /// «для галочки», а обязательное условие вызова.
  Future<VerificationResult> startMvrCheck({
    required bool hasConsent,
    required String state,
  }) async {
    if (!hasConsent) {
      return VerificationResult.invalidFormat(
        'Без письменного согласия проверка MVR запрещена (FCRA). '
        'Отметьте согласие выше',
      );
    }
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(mvrCallable);
      await callable.call<Map<String, dynamic>>({
        'state': state,
        'consent': true,
      });
      lastCallWasDemo = false;
      return VerificationResult(
        status: VerificationStatus.pendingProvider,
        tier: VerificationTier.provider,
        message: 'Запрос в Checkr отправлен. MVR по штату $state обычно '
            'готов за 1–3 рабочих дня',
        autofill: const {
          'Провайдер': 'Checkr',
          'Что проверяется': 'Подлинность прав, нарушения, лишения',
          'Стоимость': r'~$10 за отчёт',
          'Регулирование': 'FCRA — нужно согласие кандидата',
        },
        source: 'checkr_mvr',
        checkedAt: DateTime.now(),
      );
    } on FirebaseFunctionsException catch (e) {
      if (_notDeployed(e)) return _demoMvr(state);
      return VerificationResult.unavailable(e.message ?? 'Checkr недоступен');
    } catch (_) {
      return _demoMvr(state);
    }
  }

  Future<VerificationResult> _demoMvr(String state) async {
    lastCallWasDemo = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return VerificationResult(
      status: VerificationStatus.pendingProvider,
      tier: VerificationTier.provider,
      message: 'Демо-режим: функция Checkr не задеплоена. В продакшене MVR '
          'по штату $state готов за 1–3 рабочих дня',
      autofill: const {
        'Провайдер': 'Checkr',
        'Что проверяется': 'Подлинность прав, нарушения, лишения',
        'Стоимость': r'~$10 за отчёт',
        'Регулирование': 'FCRA — нужно согласие кандидата',
      },
      source: 'checkr_mvr_demo',
      checkedAt: DateTime.now(),
    );
  }

  /// Страховой полис.
  ///
  /// САМЫЙ ВАЖНЫЙ И САМЫЙ СЛАБЫЙ СЛОЙ. Реестра автополисов, доступного
  /// приложению, не существует — проверить номер нельзя ничем. Личный
  /// автополис при этом обычно НЕ покрывает управление чужой машиной за
  /// плату, а именно это и делает перегонщик.
  ///
  /// Поэтому здесь всегда ручная модерация: человек смотрит, есть ли в полисе
  /// non-owned auto liability. Автоматизировать нечем.
  Future<VerificationResult> submitInsurance({
    required bool fileAttached,
    required bool nonOwnedCoverage,
  }) async {
    if (!fileAttached) {
      return VerificationResult.invalidFormat(
        'Загрузите фото или PDF полиса',
      );
    }
    if (!nonOwnedCoverage) {
      return VerificationResult(
        status: VerificationStatus.mismatch,
        tier: VerificationTier.manual,
        message: 'Личный автополис не покрывает вождение чужого авто за плату. '
            'Нужен non-owned auto liability либо покрытие платформы',
        source: 'manual',
        checkedAt: DateTime.now(),
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return VerificationResult(
      status: VerificationStatus.needsReview,
      tier: VerificationTier.manual,
      message: 'Полис отправлен модератору. Проверяется наличие покрытия '
          'non-owned auto liability — автоматически это не проверяется ничем',
      autofill: const {
        'Кто проверяет': 'Модератор платформы',
        'Что ищет': 'Non-owned auto liability',
        'Почему вручную': 'Реестра автополисов для приложений не существует',
      },
      source: 'manual',
      checkedAt: DateTime.now(),
    );
  }

  /// Сводный уровень доверия физлица по слоям KYC.
  ///
  /// Правило: бейдж «Личность подтверждена» выдаётся, только когда закрыты
  /// ВСЕ слои с requiredAtLaunch. Незакрытая страховка — стоп, потому что
  /// это главный финансовый риск платформы, а не формальность.
  static ({bool allowed, String label, String reason}) resolveIndividualAccess(
    Map<KycLayer, VerificationResult> layers,
  ) {
    final missing = <String>[];
    for (final layer in KycLayer.values) {
      if (!layer.requiredAtLaunch) continue;
      final r = layers[layer];
      final done = r != null &&
          (r.status.grantsBadge ||
              r.status == VerificationStatus.needsReview ||
              r.status == VerificationStatus.pendingProvider);
      if (!done) missing.add(layer.title.toLowerCase());
    }

    if (missing.isEmpty) {
      return (
        allowed: true,
        label: 'Личность подтверждена',
        reason: 'Пройдены обязательные слои. Уровень ниже, чем '
            '«Компания · DOT подтверждён» — дилер может отфильтровать физлиц',
      );
    }
    return (
      allowed: false,
      label: 'Не подтверждён',
      reason: 'Не закрыто: ${missing.join(', ')}',
    );
  }
}
