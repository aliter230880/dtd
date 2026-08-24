import '/flutter_flow/lat_lng.dart';

import 'geocoding_service_native.dart'
    if (dart.library.js_util) 'geocoding_service_web.dart' as impl;

/// Результат обратного геокодирования: координаты плюс читаемый адрес.
class GeocodedPlace {
  const GeocodedPlace({required this.address, required this.latLng});

  final String address;
  final LatLng latLng;
}

/// Геокодирование, работающее и на мобильных платформах, и в браузере.
///
/// На Android/iOS используется плагин `geocoding`, у которого нет
/// веб-реализации; в браузере вместо него вызывается Geocoder из
/// Google Maps JavaScript API (он уже подключён в web/index.html).
abstract final class GeocodingService {
  /// Адрес -> координаты. Возвращает null, если адрес не найден.
  static Future<LatLng?> locationFromAddress(String address) =>
      impl.locationFromAddressImpl(address);

  /// Координаты -> адрес. Возвращает null, если адрес не найден.
  static Future<GeocodedPlace?> placeFromLocation(LatLng position) =>
      impl.placeFromLocationImpl(position);
}
