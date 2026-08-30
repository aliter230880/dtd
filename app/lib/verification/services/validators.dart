/// Уровень 1 — форматная валидация. Локально, мгновенно, без сети.
/// Ловит основную массу опечаток до любого обращения к реестрам.
library;

import '../models/verification.dart';

class Validators {
  // ---------------------------------------------------------------
  // VIN — ISO 3779, контрольная цифра в 9-й позиции.
  // Проверяется полностью офлайн, без единого запроса.
  // ---------------------------------------------------------------

  /// Транслитерация символов VIN в числа (стандарт ISO 3779).
  /// I, O, Q запрещены — исключены, чтобы не путались с 1 и 0.
  static const Map<String, int> _vinTranslit = {
    'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8,
    'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'P': 7, 'R': 9,
    'S': 2, 'T': 3, 'U': 4, 'V': 5, 'W': 6, 'X': 7, 'Y': 8, 'Z': 9,
    '0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7,
    '8': 8, '9': 9,
  };

  /// Веса позиций. 9-я позиция (индекс 8) — сама контрольная цифра, вес 0.
  static const List<int> _vinWeights = [
    8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2
  ];

  /// Полная офлайн-проверка VIN: длина, запрещённые символы, контрольная цифра.
  static VerificationResult validateVin(String input) {
    final vin = input.trim().toUpperCase();
    if (vin.isEmpty) return const VerificationResult.idle();

    if (vin.length != 17) {
      return VerificationResult.invalidFormat(
        'VIN должен содержать 17 символов (введено ${vin.length})',
      );
    }
    for (final forbidden in ['I', 'O', 'Q']) {
      if (vin.contains(forbidden)) {
        return VerificationResult.invalidFormat(
          'VIN не может содержать букву $forbidden — вероятно, это '
          '${forbidden == 'O' ? '0 (ноль)' : '1 (единица)'}',
        );
      }
    }
    if (!RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(vin)) {
      return VerificationResult.invalidFormat('VIN содержит недопустимые символы');
    }

    // Контрольная сумма.
    var sum = 0;
    for (var i = 0; i < 17; i++) {
      final value = _vinTranslit[vin[i]];
      if (value == null) {
        return VerificationResult.invalidFormat('Недопустимый символ: ${vin[i]}');
      }
      sum += value * _vinWeights[i];
    }
    final remainder = sum % 11;
    final expected = remainder == 10 ? 'X' : remainder.toString();

    if (vin[8] != expected) {
      return VerificationResult.invalidFormat(
        'Контрольная цифра не сходится (9-й символ: "${vin[8]}", '
        'ожидается "$expected") — проверьте, нет ли опечатки',
      );
    }

    return VerificationResult(
      status: VerificationStatus.checking,
      tier: VerificationTier.format,
      message: 'Формат верен, запрашиваем NHTSA…',
      source: 'format',
      checkedAt: DateTime.now(),
    );
  }

  // ---------------------------------------------------------------
  // DOT / MC номера перевозчика.
  // ---------------------------------------------------------------

  /// USDOT — от 1 до 8 цифр, без ведущих нулей.
  static VerificationResult validateDot(String input) {
    final dot = input.trim();
    if (dot.isEmpty) return const VerificationResult.idle();

    if (!RegExp(r'^\d+$').hasMatch(dot)) {
      return VerificationResult.invalidFormat('USDOT — только цифры');
    }
    if (dot.startsWith('0')) {
      return VerificationResult.invalidFormat(
          'USDOT не начинается с нуля');
    }
    if (dot.length > 8) {
      return VerificationResult.invalidFormat(
          'USDOT не длиннее 8 цифр (введено ${dot.length})');
    }
    if (dot.length < 4) {
      // Не ошибка, а «продолжайте вводить» — не пугаем пользователя.
      return const VerificationResult.idle();
    }
    return VerificationResult(
      status: VerificationStatus.checking,
      tier: VerificationTier.format,
      message: 'Проверяем в реестре FMCSA…',
      source: 'format',
      checkedAt: DateTime.now(),
    );
  }

  /// MC/MX/FF docket number. Допускаем префикс, храним цифры.
  static VerificationResult validateMc(String input) {
    var mc = input.trim().toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
    if (mc.isEmpty) return const VerificationResult.idle();

    mc = mc.replaceFirst(RegExp(r'^(MC|MX|FF)'), '');
    if (!RegExp(r'^\d+$').hasMatch(mc)) {
      return VerificationResult.invalidFormat(
          'Формат: MC-123456 или 123456');
    }
    if (mc.length > 7) {
      return VerificationResult.invalidFormat('MC не длиннее 7 цифр');
    }
    if (mc.length < 4) return const VerificationResult.idle();

    return VerificationResult(
      status: VerificationStatus.checking,
      tier: VerificationTier.format,
      source: 'format',
      checkedAt: DateTime.now(),
    );
  }

  // ---------------------------------------------------------------
  // Лицензия дилера. Федерального реестра НЕ существует —
  // 50 штатов, у большинства нет API. Максимум офлайн: маска штата.
  // Дальше — только ручная модерация админом.
  // ---------------------------------------------------------------

  /// Маски номеров дилерских лицензий по штатам.
  /// Значение: (регулярка, человекочитаемый пример).
  static const Map<String, (String, String)> dealerLicensePatterns = {
    'CA': (r'^\d{5,8}$', '12345678 — 5–8 цифр (CA DMV OL)'),
    'TX': (r'^[Pp]?\d{5,7}$', 'P12345 или 1234567 (TxDMV)'),
    'FL': (r'^(VI|VF|VD|DA)\d{6,8}$', 'VI1234567 (FLHSMV)'),
    'NY': (r'^\d{7}$', '1234567 — 7 цифр (NY DMV)'),
    'NJ': (r'^[A-Z]\d{5,6}$', 'D12345 (NJ MVC)'),
    'PA': (r'^[A-Z]{2}\d{5,6}$', 'DA12345 (PennDOT)'),
    'IL': (r'^\d{6,8}$', '12345678 (IL SOS)'),
    'OH': (r'^[A-Z]{2}\d{6}$', 'UD123456 (Ohio BMV)'),
    'GA': (r'^[A-Z]\d{6,7}$', 'D123456 (GA DOR)'),
    'AZ': (r'^[A-Z]\d{5,7}$', 'L1234567 (AZ MVD)'),
  };

  /// Проверка номера дилерской лицензии по маске штата.
  /// Итог — всегда needsReview: маска подтверждает вид номера, но не его
  /// существование. Реестра, который бы это подтвердил, нет.
  static VerificationResult validateDealerLicense(String input, String state) {
    final value = input.trim().toUpperCase();
    if (value.isEmpty) return const VerificationResult.idle();

    final pattern = dealerLicensePatterns[state];
    if (pattern == null) {
      return VerificationResult(
        status: VerificationStatus.needsReview,
        tier: VerificationTier.manual,
        message: 'Для $state нет маски — потребуется загрузка документа '
            'и проверка модератором',
        source: 'format',
        checkedAt: DateTime.now(),
      );
    }

    if (!RegExp(pattern.$1).hasMatch(value)) {
      return VerificationResult.invalidFormat(
        'Не похоже на лицензию $state. Пример: ${pattern.$2}',
      );
    }

    return VerificationResult(
      status: VerificationStatus.needsReview,
      tier: VerificationTier.manual,
      message: 'Формат $state верен. Единого реестра дилерских лицензий в США '
          'нет — номер подтвердит модератор по загруженному документу',
      source: 'format',
      checkedAt: DateTime.now(),
    );
  }

  /// Водительское удостоверение: только базовая маска.
  /// Реальная проверка невозможна — AAMVA DLDV закрыт для приложений (DPPA).
  /// Путь: Stripe Identity (скан + liveness) или Checkr (MVR, по согласию FCRA).
  static VerificationResult validateDriverLicense(String input, String state) {
    final value = input.trim().toUpperCase();
    if (value.isEmpty) return const VerificationResult.idle();
    if (value.length < 4 || value.length > 20) {
      return VerificationResult.invalidFormat('Проверьте номер: 4–20 символов');
    }
    if (!RegExp(r'^[A-Z0-9*-]+$').hasMatch(value)) {
      return VerificationResult.invalidFormat('Недопустимые символы');
    }
    return VerificationResult(
      status: VerificationStatus.needsReview,
      tier: VerificationTier.manual,
      message: 'Номер прав напрямую не проверяется (доступ к базам DMV '
          'ограничен DPPA). Подтверждение — через Stripe Identity',
      source: 'format',
      checkedAt: DateTime.now(),
    );
  }

  // ---------------------------------------------------------------
  // ФИЗЛИЦО. Три проверки, которые честно работают офлайн и бесплатно.
  // ---------------------------------------------------------------

  /// SSN — по официальным правилам выпуска SSA.
  ///
  /// Полностью офлайн: SSA публикует, какие номера НИКОГДА не выдавались.
  /// Это не подтверждение личности (её даёт Stripe Identity), но отсекает
  /// заведомо невозможные номера и мусор вида 123-45-6789 до платного запроса.
  ///
  /// Правила: area (первые 3) ≠ 000, ≠ 666, < 900; group (сер. 2) ≠ 00;
  /// serial (посл. 4) ≠ 0000. Плюс отсеиваем демо-номер 078-05-1120
  /// (кошелёк Woolworth, 1938 — самый растиражированный «живой» SSN).
  static VerificationResult validateSsn(String input) {
    final digits = input.replaceAll(RegExp(r'[\s-]'), '');
    if (digits.isEmpty) return const VerificationResult.idle();

    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return VerificationResult.invalidFormat('Только цифры и дефисы');
    }
    if (digits.length < 9) return const VerificationResult.idle();
    if (digits.length > 9) {
      return VerificationResult.invalidFormat(
          'SSN — ровно 9 цифр (введено ${digits.length})');
    }

    final area = int.parse(digits.substring(0, 3));
    final group = int.parse(digits.substring(3, 5));
    final serial = int.parse(digits.substring(5, 9));

    if (area == 0) {
      return VerificationResult.invalidFormat(
          'Первые три цифры не могут быть 000 — такие SSN не выдаются');
    }
    if (area == 666) {
      return VerificationResult.invalidFormat(
          'Группа 666 никогда не выдавалась SSA');
    }
    if (area >= 900) {
      return VerificationResult.invalidFormat(
          'Номера с 900+ не выдаются (это диапазон ITIN, не SSN)');
    }
    if (group == 0) {
      return VerificationResult.invalidFormat(
          'Средние две цифры не могут быть 00');
    }
    if (serial == 0) {
      return VerificationResult.invalidFormat(
          'Последние четыре цифры не могут быть 0000');
    }
    if (digits == '078051120') {
      return VerificationResult.invalidFormat(
          'Это демонстрационный номер из рекламы 1938 года, не действующий SSN');
    }

    return VerificationResult(
      status: VerificationStatus.needsReview,
      tier: VerificationTier.provider,
      message: 'Формат соответствует правилам выпуска SSA. Личность '
          'подтверждается Stripe Identity — SSN в базу платформы не пишется',
      source: 'format_ssa_rules',
      checkedAt: DateTime.now(),
    );
  }

  /// Дата рождения + возрастной порог FMCSA.
  ///
  /// 21 год — не произвольное число: 49 CFR §391.11 требует 21 год для
  /// interstate-перевозок. 18–20 лет допускаются только внутри штата,
  /// поэтому это не отказ, а ограничение области работы.
  static VerificationResult validateDateOfBirth(String input) {
    final value = input.trim();
    if (value.isEmpty) return const VerificationResult.idle();

    final m = RegExp(r'^(\d{2})[./-](\d{2})[./-](\d{4})$').firstMatch(value);
    if (m == null) {
      if (value.length < 10) return const VerificationResult.idle();
      return VerificationResult.invalidFormat('Формат: ДД.ММ.ГГГГ');
    }

    final day = int.parse(m.group(1)!);
    final month = int.parse(m.group(2)!);
    final year = int.parse(m.group(3)!);

    if (month < 1 || month > 12) {
      return VerificationResult.invalidFormat('Месяц должен быть 01–12');
    }
    final dob = DateTime(year, month, day);
    // Ловит 31.02: DateTime нормализует несуществующую дату в следующий месяц.
    if (dob.day != day || dob.month != month) {
      return VerificationResult.invalidFormat('Такой даты не существует');
    }

    final now = DateTime.now();
    if (dob.isAfter(now)) {
      return VerificationResult.invalidFormat('Дата в будущем');
    }

    var age = now.year - dob.year;
    if (now.month < month || (now.month == month && now.day < day)) age--;

    if (age > 100) {
      return VerificationResult.invalidFormat('Проверьте год рождения');
    }
    if (age < 18) {
      return VerificationResult.invalidFormat(
          'До 18 лет коммерческая перевозка запрещена (возраст: $age)');
    }
    if (age < 21) {
      return VerificationResult(
        status: VerificationStatus.mismatch,
        tier: VerificationTier.format,
        message: 'Возраст $age: 49 CFR §391.11 требует 21 год для перевозок '
            'между штатами. Доступны только внутриштатные заказы',
        source: 'format_fmcsa_age',
        checkedAt: DateTime.now(),
      );
    }

    return VerificationResult(
      status: VerificationStatus.verified,
      tier: VerificationTier.format,
      message: 'Возраст $age — соответствует 49 CFR §391.11 (21+)',
      autofill: {'Возраст': '$age года'},
      source: 'format_fmcsa_age',
      checkedAt: DateTime.now(),
    );
  }

  /// Телефон США — правила NANP (не просто «10 цифр»).
  /// Код города и код обмена не могут начинаться с 0 или 1.
  static VerificationResult validateUsPhone(String input) {
    var digits = input.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return const VerificationResult.idle();
    if (digits.length == 11 && digits.startsWith('1')) {
      digits = digits.substring(1);
    }
    if (digits.length < 10) return const VerificationResult.idle();
    if (digits.length > 10) {
      return VerificationResult.invalidFormat('Слишком много цифр');
    }
    if (digits[0] == '0' || digits[0] == '1') {
      return VerificationResult.invalidFormat(
          'Код города не может начинаться с ${digits[0]} (правила NANP)');
    }
    if (digits[3] == '0' || digits[3] == '1') {
      return VerificationResult.invalidFormat(
          'Код обмена не может начинаться с ${digits[3]} (правила NANP)');
    }
    final fmt = '(${digits.substring(0, 3)}) '
        '${digits.substring(3, 6)}-${digits.substring(6)}';
    return VerificationResult(
      status: VerificationStatus.verified,
      tier: VerificationTier.format,
      message: 'Формат NANP корректен: $fmt',
      source: 'format_nanp',
      checkedAt: DateTime.now(),
    );
  }
}
