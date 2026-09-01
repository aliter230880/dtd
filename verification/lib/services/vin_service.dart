/// Уровень 2 для VIN — NHTSA vPIC.
///
/// Проверено вживую: vPIC отдаёт `access-control-allow-origin: *`,
/// ключ не нужен → можно звать прямо из браузера, без Cloud Function.
///
/// ВАЖНАЯ ЛОВУШКА, подтверждённая на живом API: для битого VIN
/// (1HGCM82633A00435X) vPIC ВСЁ РАВНО вернул Make=HONDA, Model=Accord.
/// Наличие Make ничего не доказывает — решение принимается ТОЛЬКО
/// по полю ErrorCode. Код "0" = всё чисто; "1" = контрольная цифра
/// не сходится; "400" = недопустимые символы; "6"/"11" = VIN не найден.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verification.dart';
import 'validators.dart';

class VinService {
  static const _base = 'https://vpic.nhtsa.dot.gov/api/vehicles';
  final http.Client _client;

  VinService({http.Client? client}) : _client = client ?? http.Client();

  Future<VerificationResult> decode(String rawVin) async {
    // Сначала офлайн: если контрольная цифра не сходится, сеть не нужна.
    final local = Validators.validateVin(rawVin);
    if (local.status == VerificationStatus.invalidFormat ||
        local.status == VerificationStatus.idle) {
      return local;
    }

    final vin = rawVin.trim().toUpperCase();
    try {
      final uri = Uri.parse('$_base/decodevinvalues/$vin?format=json');
      final resp =
          await _client.get(uri).timeout(const Duration(seconds: 12));

      if (resp.statusCode != 200) {
        return VerificationResult.unavailable(
          'NHTSA недоступен (${resp.statusCode}). Формат VIN верен — '
          'можно продолжить, проверим позже',
        );
      }

      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final results = body['Results'] as List<dynamic>?;
      if (results == null || results.isEmpty) {
        return VerificationResult.unavailable('NHTSA вернул пустой ответ');
      }
      final r = results.first as Map<String, dynamic>;

      final codes = (r['ErrorCode'] as String? ?? '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet();
      final errorText = r['ErrorText'] as String? ?? '';

      // VIN не найден в базе.
      if (codes.contains('6') || codes.contains('11')) {
        return VerificationResult(
          status: VerificationStatus.notFound,
          tier: VerificationTier.registry,
          message: 'NHTSA не нашёл этот VIN в базе',
          source: 'nhtsa_vpic',
          checkedAt: DateTime.now(),
          raw: r,
        );
      }

      // Любой ненулевой код — расхождение. Автозаполнение не применяем.
      if (codes.isNotEmpty && !codes.contains('0')) {
        return VerificationResult(
          status: VerificationStatus.mismatch,
          tier: VerificationTier.registry,
          message: 'NHTSA: ${_humanize(errorText)}',
          source: 'nhtsa_vpic',
          checkedAt: DateTime.now(),
          raw: r,
        );
      }

      String pick(String key) => (r[key] as String? ?? '').trim();
      final make = pick('Make');
      final model = pick('Model');
      final year = pick('ModelYear');

      if (make.isEmpty && model.isEmpty) {
        return VerificationResult(
          status: VerificationStatus.notFound,
          tier: VerificationTier.registry,
          message: 'NHTSA не смог распознать автомобиль по этому VIN',
          source: 'nhtsa_vpic',
          checkedAt: DateTime.now(),
          raw: r,
        );
      }

      final autofill = <String, String>{
        if (make.isNotEmpty) 'Марка': make,
        if (model.isNotEmpty) 'Модель': model,
        if (year.isNotEmpty) 'Год': year,
        if (pick('BodyClass').isNotEmpty) 'Кузов': pick('BodyClass'),
        if (pick('VehicleType').isNotEmpty) 'Тип': pick('VehicleType'),
        if (pick('FuelTypePrimary').isNotEmpty) 'Топливо': pick('FuelTypePrimary'),
        if (pick('PlantCountry').isNotEmpty) 'Сборка': pick('PlantCountry'),
        if (pick('GVWR').isNotEmpty) 'GVWR': pick('GVWR'),
      };

      return VerificationResult(
        status: VerificationStatus.verified,
        tier: VerificationTier.registry,
        message: '$year $make $model — подтверждено NHTSA',
        autofill: autofill,
        source: 'nhtsa_vpic',
        checkedAt: DateTime.now(),
        raw: r,
      );
    } catch (e) {
      // Сеть упала — это НЕ «неверный VIN». Форму не блокируем.
      return VerificationResult.unavailable(
        'Не удалось связаться с NHTSA. Формат VIN верен — можно продолжить',
      );
    }
  }

  String _humanize(String errorText) {
    if (errorText.contains('Check Digit')) {
      return 'контрольная цифра VIN не сходится';
    }
    if (errorText.contains('Invalid Character')) {
      return 'недопустимые символы в VIN';
    }
    if (errorText.contains('incomplete')) return 'VIN неполный';
    final cut = errorText.split(';').first.trim();
    return cut.isEmpty ? 'расхождение в данных' : cut;
  }
}
