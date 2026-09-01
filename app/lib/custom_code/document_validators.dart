// Валидаторы номеров документов для форм профиля.
//
// Заменяют проверку `val.length < 3`, при которой строка «abc» проходила
// как номер перевозчика.
//
// Здесь ТОЛЬКО офлайн-проверка формата: она отсекает опечатки и явный мусор,
// не требует сети и не может заблокировать пользователя из-за недоступности
// внешнего реестра. Подтверждение существования номера в FMCSA — отдельный
// шаг через Cloud Function, см. docs/VERIFICATION_KYC_IMPLEMENTATION.md.
//
// Возвращаемое значение соответствует контракту FlutterFlow-валидаторов:
// null — поле валидно, строка — текст ошибки.

import 'package:flutter/services.dart';

/// Разрешённые символы в полях номеров документов США.
///
/// КРИТИЧНО: не заменять на `[0-9]`. Номера водительских прав и дилерских
/// лицензий почти во всех штатах содержат буквы (CA — `D1234567`,
/// FL — `A123456789012`), и цифровой фильтр удаляет их при вводе, делая
/// корректный ввод невозможным.
final documentNumberFilter =
    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]'));

/// Приводит ввод к верхнему регистру.
///
/// Номера документов США записываются заглавными буквами; без этого
/// `d1234567` и `D1234567` попадали бы в базу как разные значения.
class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}

/// Готовый набор форматтеров для поля номера документа.
const documentNumberFormatters = <TextInputFormatter>[
  UpperCaseTextFormatter(),
];

/// Валидаторы номеров документов США.
class DocumentValidators {
  DocumentValidators._();

  // ---------------------------------------------------------------------------
  // Номер перевозчика: USDOT или MC
  // ---------------------------------------------------------------------------

  /// Проверяет номер перевозчика — принимает и USDOT, и MC (с префиксом и без).
  ///
  /// Намеренно НЕ требует минимальной длины 7: реальные USDOT-номера бывают
  /// и короткими (у старых перевозчиков — 5–6 цифр). Отсекается то, что
  /// не может быть номером в принципе.
  static String? carrierNumber(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'Введите номер перевозчика';

    // MC-номер: допускается префикс MC / MC- / MX / FF.
    final mcMatch =
        RegExp(r'^(MC|MX|FF)[\s-]?(\d+)$', caseSensitive: false).firstMatch(raw);
    if (mcMatch != null) {
      return _mcDigits(mcMatch.group(2)!);
    }

    // Иначе ожидаем USDOT: только цифры.
    final digitsOnly = raw.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
      return 'Номер перевозчика — это цифры USDOT или номер MC. '
          'Буквы допустимы только в префиксе MC.';
    }
    return _dotDigits(digitsOnly);
  }

  static String? _dotDigits(String digits) {
    if (digits.startsWith('0')) {
      return 'USDOT-номер не начинается с нуля';
    }
    if (digits.length < 4) {
      return 'USDOT-номер слишком короткий';
    }
    if (digits.length > 8) {
      return 'USDOT-номер не длиннее 8 цифр';
    }
    return null;
  }

  static String? _mcDigits(String digits) {
    if (digits.startsWith('0')) {
      return 'MC-номер не начинается с нуля';
    }
    if (digits.length < 4 || digits.length > 8) {
      return 'MC-номер содержит от 4 до 8 цифр';
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Водительское удостоверение
  // ---------------------------------------------------------------------------

  /// Проверяет номер водительского удостоверения США.
  ///
  /// Форматы различаются по штатам, единой маски не существует:
  /// Калифорния — `D1234567`, Флорида — `A123456789012`, Нью-Йорк — 9 цифр.
  /// Поэтому проверка нестрогая: допускаются буквы и цифры, длина 5–20.
  ///
  /// КРИТИЧНО: поле НЕ должно фильтровать ввод по `[0-9]` — в большинстве
  /// штатов номер содержит букву, и такой фильтр делает корректный ввод
  /// невозможным. Используйте `RegExp(r'[A-Za-z0-9*-]')`.
  static String? driverLicense(String? value) {
    final raw = (value ?? '').trim().toUpperCase();
    if (raw.isEmpty) return 'Введите номер водительских прав';

    if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(raw)) {
      return 'Допустимы только латинские буквы, цифры и дефис';
    }

    final clean = raw.replaceAll('-', '');
    if (clean.length < 5) {
      return 'Номер водительских прав слишком короткий';
    }
    if (clean.length > 20) {
      return 'Номер водительских прав слишком длинный';
    }
    if (!RegExp(r'\d').hasMatch(clean)) {
      return 'Номер должен содержать хотя бы одну цифру';
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Дилерская лицензия
  // ---------------------------------------------------------------------------

  /// Проверяет номер дилерской лицензии.
  ///
  /// Единого федерального реестра дилерских лицензий в США нет — их выдают
  /// DMV отдельных штатов, форматы различаются (CA — 5–8 цифр,
  /// FL — `VI`/`VF` + цифры, TX — `P` + цифры). Поэтому проверка нестрогая:
  /// подтверждение остаётся за ручной модерацией.
  static String? dealerLicense(String? value) {
    final raw = (value ?? '').trim().toUpperCase();
    if (raw.isEmpty) return 'Введите номер дилерской лицензии';

    if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(raw)) {
      return 'Допустимы только латинские буквы, цифры и дефис';
    }

    final clean = raw.replaceAll('-', '');
    if (clean.length < 4) {
      return 'Номер лицензии слишком короткий';
    }
    if (clean.length > 20) {
      return 'Номер лицензии слишком длинный';
    }
    if (!RegExp(r'\d').hasMatch(clean)) {
      return 'Номер лицензии должен содержать цифры';
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Название компании
  // ---------------------------------------------------------------------------

  /// Проверяет название компании — отсекает односимвольный мусор.
  static String? companyName(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'Введите название компании';
    if (raw.length < 2) return 'Название слишком короткое';
    if (raw.length > 120) return 'Название слишком длинное';
    if (!RegExp(r'[A-Za-zА-Яа-яЁё]').hasMatch(raw)) {
      return 'Название должно содержать буквы';
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // VIN — контрольная цифра ISO 3779
  // ---------------------------------------------------------------------------

  static const Map<String, int> _vinTranslit = {
    'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8,
    'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'P': 7, 'R': 9,
    'S': 2, 'T': 3, 'U': 4, 'V': 5, 'W': 6, 'X': 7, 'Y': 8, 'Z': 9,
  };

  static const List<int> _vinWeights = [
    8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2
  ];

  /// Проверяет VIN по стандарту ISO 3779, включая контрольную цифру.
  static String? vin(String? value) {
    final raw = (value ?? '').trim().toUpperCase();
    if (raw.isEmpty) return 'Введите VIN';

    if (RegExp(r'[IOQ]').hasMatch(raw)) {
      return 'В VIN не используются буквы I, O и Q — их путают с 1 и 0';
    }
    if (raw.length != 17) {
      return 'VIN состоит из 17 символов, введено ${raw.length}';
    }
    if (!RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(raw)) {
      return 'Недопустимые символы в VIN';
    }

    var sum = 0;
    for (var i = 0; i < 17; i++) {
      final ch = raw[i];
      final digit = int.tryParse(ch) ?? _vinTranslit[ch];
      if (digit == null) return 'Недопустимый символ «$ch» в VIN';
      sum += digit * _vinWeights[i];
    }
    final remainder = sum % 11;
    final expected = remainder == 10 ? 'X' : remainder.toString();
    if (raw[8] != expected) {
      return 'VIN не проходит проверку контрольной цифры — проверьте номер';
    }
    return null;
  }
}
