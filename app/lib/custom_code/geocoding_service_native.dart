import 'package:geocoding/geocoding.dart' as geocoding;

import '/flutter_flow/lat_lng.dart';
import 'geocoding_service.dart';

Future<LatLng?> locationFromAddressImpl(String address) async {
  if (address.trim().isEmpty) return null;
  final locations = await geocoding.locationFromAddress(address);
  if (locations.isEmpty) return null;
  return LatLng(locations.first.latitude, locations.first.longitude);
}

Future<GeocodedPlace?> placeFromLocationImpl(LatLng position) async {
  final placemarks = await geocoding.placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  if (placemarks.isEmpty) return null;
  return GeocodedPlace(
    address: _formatted(placemarks.first),
    latLng: position,
  );
}

String _formatted(geocoding.Placemark placemark) {
  final parts = [
    placemark.country,
    placemark.administrativeArea,
    placemark.locality,
    placemark.street,
    placemark.name,
  ].where((part) => part != null && part.isNotEmpty);
  return parts.join(', ');
}
