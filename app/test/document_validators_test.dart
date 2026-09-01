import 'package:flutter_test/flutter_test.dart';
import 'package:auto_deal_app/custom_code/document_validators.dart';

void main() {
  group('Баг: валидатор пропускал мусор (было length < 3)', () {
    test('строка "abc" больше НЕ проходит как номер перевозчика', () {
      // Именно этот кейс проходил в продакшне.
      expect(DocumentValidators.carrierNumber('abc'), isNotNull);
    });

    test('реальный USDOT принимается', () {
      expect(DocumentValidators.carrierNumber('80806'), isNull);
      expect(DocumentValidators.carrierNumber('1234567'), isNull);
    });

    test('MC-номер принимается с префиксом и без', () {
      expect(DocumentValidators.carrierNumber('MC123456'), isNull);
      expect(DocumentValidators.carrierNumber('MC-123456'), isNull);
      expect(DocumentValidators.carrierNumber('mc 123456'), isNull);
    });

    test('ведущий ноль отклоняется', () {
      expect(DocumentValidators.carrierNumber('0123456'), isNotNull);
    });

    test('перебор длины отклоняется', () {
      expect(DocumentValidators.carrierNumber('123456789'), isNotNull);
    });

    test('пустое поле даёт понятную ошибку', () {
      expect(DocumentValidators.carrierNumber(''), 'Введите номер перевозчика');
      expect(DocumentValidators.carrierNumber(null), isNotNull);
    });
  });

  group('Баг: фильтр [0-9] делал ввод прав невозможным', () {
    test('права с буквой теперь валидны (CA, FL)', () {
      expect(DocumentValidators.driverLicense('D1234567'), isNull);
      expect(DocumentValidators.driverLicense('A123456789012'), isNull);
    });

    test('чисто цифровые права тоже валидны (NY)', () {
      expect(DocumentValidators.driverLicense('123456789'), isNull);
    });

    test('регистр не важен — нормализуется', () {
      expect(DocumentValidators.driverLicense('d1234567'), isNull);
    });

    test('номер без цифр отклоняется', () {
      expect(DocumentValidators.driverLicense('ABCDEFG'), isNotNull);
    });

    test('слишком короткий отклоняется', () {
      expect(DocumentValidators.driverLicense('D12'), isNotNull);
    });

    test('кириллица и спецсимволы отклоняются', () {
      expect(DocumentValidators.driverLicense('Д1234567'), isNotNull);
      expect(DocumentValidators.driverLicense('D123#567'), isNotNull);
    });
  });

  group('Дилерская лицензия', () {
    test('форматы разных штатов принимаются', () {
      expect(DocumentValidators.dealerLicense('12345'), isNull);
      expect(DocumentValidators.dealerLicense('VI1234567'), isNull);
      expect(DocumentValidators.dealerLicense('P123456'), isNull);
    });

    test('мусор отклоняется', () {
      expect(DocumentValidators.dealerLicense('ab'), isNotNull);
      expect(DocumentValidators.dealerLicense('ABCDEF'), isNotNull);
    });
  });

  group('Название компании', () {
    test('нормальное название проходит', () {
      expect(DocumentValidators.companyName('FedEx Freight Inc'), isNull);
      expect(DocumentValidators.companyName('ООО Перевозчик'), isNull);
    });

    test('односимвольное и без букв отклоняется', () {
      expect(DocumentValidators.companyName('X'), isNotNull);
      expect(DocumentValidators.companyName('12345'), isNotNull);
    });
  });

  group('VIN — контрольная цифра ISO 3779', () {
    test('реальные VIN проходят', () {
      expect(DocumentValidators.vin('1HGCM82633A004352'), isNull);
      expect(DocumentValidators.vin('1M8GDM9AXKP042788'), isNull);
    });

    test('битая контрольная цифра отклоняется', () {
      expect(DocumentValidators.vin('1HGCM82633A004353'), isNotNull);
    });

    test('буквы I, O, Q отклоняются с отдельным сообщением', () {
      final err = DocumentValidators.vin('1HGCM82633A0O4352');
      expect(err, contains('I, O'));
    });

    test('неверная длина отклоняется', () {
      expect(DocumentValidators.vin('1HGCM82633A00435'), isNotNull);
    });
  });

  group('Форматтер ввода', () {
    test('приводит к верхнему регистру', () {
      const f = UpperCaseTextFormatter();
      final r = f.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: 'd1234567'),
      );
      expect(r.text, 'D1234567');
    });
  });
}
