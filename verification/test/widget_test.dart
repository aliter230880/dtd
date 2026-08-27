import 'package:flutter_test/flutter_test.dart';
import 'package:dtd_verification/models/verification.dart';
import 'package:dtd_verification/services/validators.dart';
import 'package:dtd_verification/services/kyc_service.dart';
import 'package:dtd_verification/models/user_kind.dart';

void main() {
  group('VIN check digit (ISO 3779)', () {
    // Эти VIN сверены с реальным ответом NHTSA vPIC: ErrorCode "0".
    test('принимает реальные VIN', () {
      for (final vin in [
        '1HGCM82633A004352',
        'JH4KA7561PC008269',
        '3VWFE21C04M000001',
      ]) {
        expect(Validators.validateVin(vin).status,
            VerificationStatus.checking,
            reason: '$vin должен пройти формат');
      }
    });

    // vPIC на них отвечает ErrorCode "1" — контрольная цифра не сходится.
    test('отклоняет VIN с битой контрольной цифрой', () {
      for (final vin in [
        '5YJ3E1EA7KF317692',
        '1FTFW1ET5DFC10312',
        'WBA3A5C55DF357968',
      ]) {
        expect(Validators.validateVin(vin).status,
            VerificationStatus.invalidFormat,
            reason: '$vin должен быть отклонён офлайн');
      }
    });

    test('ловит запрещённые I, O, Q', () {
      final r = Validators.validateVin('1HGCM8263OA004352');
      expect(r.status, VerificationStatus.invalidFormat);
      expect(r.message, contains('O'));
    });

    test('проверяет длину', () {
      expect(Validators.validateVin('1HGCM8263').status,
          VerificationStatus.invalidFormat);
    });

    test('пустой ввод — idle, не ошибка', () {
      expect(Validators.validateVin('').status, VerificationStatus.idle);
    });
  });

  group('USDOT', () {
    test('валидный номер уходит в реестр', () {
      expect(Validators.validateDot('76830').status,
          VerificationStatus.checking);
    });

    test('короткий ввод не пугает пользователя ошибкой', () {
      expect(Validators.validateDot('76').status, VerificationStatus.idle);
    });

    test('отклоняет буквы, ведущий ноль и перебор длины', () {
      expect(Validators.validateDot('76A30').status,
          VerificationStatus.invalidFormat);
      expect(Validators.validateDot('076830').status,
          VerificationStatus.invalidFormat);
      expect(Validators.validateDot('123456789').status,
          VerificationStatus.invalidFormat);
    });
  });

  group('MC number', () {
    test('принимает с префиксом и без', () {
      expect(Validators.validateMc('MC-135790').status,
          VerificationStatus.checking);
      expect(Validators.validateMc('135790').status,
          VerificationStatus.checking);
    });
  });

  group('Лицензия дилера', () {
    test('верный формат CA уходит на модерацию, а не в verified', () {
      final r = Validators.validateDealerLicense('12345678', 'CA');
      expect(r.status, VerificationStatus.needsReview);
      // Ключевое: маска НЕ даёт бейджа доверия.
      expect(r.status.grantsBadge, isFalse);
      expect(r.tier, VerificationTier.manual);
    });

    test('нарушение маски штата отклоняется', () {
      expect(Validators.validateDealerLicense('ABC', 'CA').status,
          VerificationStatus.invalidFormat);
      expect(Validators.validateDealerLicense('123', 'NY').status,
          VerificationStatus.invalidFormat);
    });

    test('FL требует буквенный префикс', () {
      expect(Validators.validateDealerLicense('VI1234567', 'FL').status,
          VerificationStatus.needsReview);
      expect(Validators.validateDealerLicense('1234567', 'FL').status,
          VerificationStatus.invalidFormat);
    });
  });

  group('Семантика статусов', () {
    test('unavailable не блокирует отправку формы', () {
      expect(VerificationStatus.unavailable.allowsSubmit, isTrue);
      expect(VerificationStatus.unavailable.isBlocking, isFalse);
      // Но и бейджа не даёт.
      expect(VerificationStatus.unavailable.grantsBadge, isFalse);
    });

    test('только registry-verified даёт бейдж', () {
      expect(VerificationStatus.verified.grantsBadge, isTrue);
      expect(VerificationStatus.needsReview.grantsBadge, isFalse);
      expect(VerificationStatus.notFound.grantsBadge, isFalse);
    });

    test('расхождение и ненайденное блокируют', () {
      expect(VerificationStatus.mismatch.isBlocking, isTrue);
      expect(VerificationStatus.notFound.isBlocking, isTrue);
    });
  });

  group('SSN — правила выпуска SSA', () {
    test('area 000 / 666 / 900+ отклоняются', () {
      for (final bad in ['000-45-6789', '666-45-6789', '900-45-6789']) {
        expect(Validators.validateSsn(bad).status,
            VerificationStatus.invalidFormat,
            reason: bad);
      }
    });

    test('group 00 и serial 0000 отклоняются', () {
      expect(Validators.validateSsn('123-00-6789').status,
          VerificationStatus.invalidFormat);
      expect(Validators.validateSsn('123-45-0000').status,
          VerificationStatus.invalidFormat);
    });

    test('демо-номер 078-05-1120 отклоняется', () {
      expect(Validators.validateSsn('078-05-1120').status,
          VerificationStatus.invalidFormat);
    });

    test('корректный SSN уходит к провайдеру, а не подтверждается сам', () {
      final r = Validators.validateSsn('123-45-6789');
      expect(r.status, VerificationStatus.needsReview);
      // Формат НЕ даёт бейджа: личность подтверждает Stripe Identity.
      expect(r.status.grantsBadge, isFalse);
      expect(r.tier, VerificationTier.provider);
    });
  });

  group('Возраст — 49 CFR 391.11', () {
    String dob(int yearsAgo) {
      final n = DateTime.now();
      final d = DateTime(n.year - yearsAgo, n.month, n.day);
      return '${d.day.toString().padLeft(2, '0')}.'
          '${d.month.toString().padLeft(2, '0')}.${d.year}';
    }

    test('21+ проходит', () {
      expect(Validators.validateDateOfBirth(dob(25)).status,
          VerificationStatus.verified);
    });

    test('18-20 — не отказ, а ограничение внутриштатными заказами', () {
      final r = Validators.validateDateOfBirth(dob(19));
      expect(r.status, VerificationStatus.mismatch);
      expect(r.message, contains('391.11'));
    });

    test('до 18 — отказ', () {
      expect(Validators.validateDateOfBirth(dob(16)).status,
          VerificationStatus.invalidFormat);
    });

    test('несуществующая дата 31.02 отклоняется', () {
      expect(Validators.validateDateOfBirth('31.02.1990').status,
          VerificationStatus.invalidFormat);
    });
  });

  group('Телефон NANP', () {
    test('код города с 0/1 отклоняется', () {
      expect(Validators.validateUsPhone('0551234567').status,
          VerificationStatus.invalidFormat);
      expect(Validators.validateUsPhone('1551234567').status,
          VerificationStatus.invalidFormat);
    });

    test('код обмена с 1 отклоняется', () {
      expect(Validators.validateUsPhone('5551234567').status,
          VerificationStatus.invalidFormat);
    });

    test('валидный номер форматируется', () {
      final r = Validators.validateUsPhone('5552334567');
      expect(r.status, VerificationStatus.verified);
      expect(r.message, contains('(555) 233-4567'));
    });
  });

  group('Допуск физлица к заказам', () {
    test('без страховки допуск закрыт — главный риск платформы', () {
      final a = KycService.resolveIndividualAccess({
        KycLayer.identity: VerificationResult(
          status: VerificationStatus.pendingProvider,
          tier: VerificationTier.provider,
          checkedAt: DateTime.now(),
        ),
      });
      expect(a.allowed, isFalse);
      expect(a.reason, contains('страховка'));
    });

    test('MVR и криминальный фон не обязательны на старте', () {
      expect(KycLayer.drivingRecord.requiredAtLaunch, isFalse);
      expect(KycLayer.criminal.requiredAtLaunch, isFalse);
      expect(KycLayer.identity.requiredAtLaunch, isTrue);
      expect(KycLayer.insurance.requiredAtLaunch, isTrue);
    });

    test('оба обязательных слоя закрыты — допуск открыт', () {
      final a = KycService.resolveIndividualAccess({
        KycLayer.identity: VerificationResult(
          status: VerificationStatus.pendingProvider,
          tier: VerificationTier.provider,
          checkedAt: DateTime.now(),
        ),
        KycLayer.insurance: VerificationResult(
          status: VerificationStatus.needsReview,
          tier: VerificationTier.manual,
          checkedAt: DateTime.now(),
        ),
      });
      expect(a.allowed, isTrue);
      expect(a.label, 'Личность подтверждена');
    });
  });

  group('Страховка физлица', () {
    test('полис без non-owned покрытия — расхождение, не подтверждение', () async {
      final r = await const KycService()
          .submitInsurance(fileAttached: true, nonOwnedCoverage: false);
      expect(r.status, VerificationStatus.mismatch);
      expect(r.message, contains('non-owned'));
    });

    test('MVR без согласия FCRA запрещён', () async {
      final r = await const KycService()
          .startMvrCheck(hasConsent: false, state: 'CA');
      expect(r.status, VerificationStatus.invalidFormat);
      expect(r.message, contains('FCRA'));
    });

    test('Identity даёт pendingProvider, а не verified', () async {
      final r = await const KycService().startIdentitySession(dateOfBirth: '');
      expect(r.status, VerificationStatus.pendingProvider);
      // Клиент не имеет права считать проверку пройденной сразу.
      expect(r.status.grantsBadge, isFalse);
      expect(r.status.allowsSubmit, isTrue);
    });
  });

  group('Роль не подменяется типом перевозчика', () {
    test('carrier_kind по умолчанию company — обратная совместимость', () {
      expect(CarrierKindX.fromFirestore(null), CarrierKind.company);
      expect(CarrierKindX.fromFirestore('individual'), CarrierKind.individual);
    });
  });
}
