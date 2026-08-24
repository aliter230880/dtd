import 'package:google_maps/google_maps.dart' as gmaps;

import '/flutter_flow/lat_lng.dart';
import 'geocoding_service.dart';

Future<LatLng?> locationFromAddressImpl(String address) async {
  if (address.trim().isEmpty) return null;
  final result = await _geocode(gmaps.GeocoderRequest()..address = address);
  final location = result?.geometry?.location;
  if (location == null) return null;
  return LatLng(location.lat.toDouble(), location.lng.toDouble());
}

Future<GeocodedPlace?> placeFromLocationImpl(LatLng position) async {
  final result = await _geocode(gmaps.GeocoderRequest()
    ..location = gmaps.LatLng(position.latitude, position.longitude));
  final address = result?.formattedAddress;
  if (address == null || address.isEmpty) return null;
  return GeocodedPlace(address: address, latLng: position);
}

Future<gmaps.GeocoderResult?> _geocode(gmaps.GeocoderRequest request) async {
  final response = await gmaps.Geocoder().geocode(request);
  final results = response.results;
  if (results == null || results.isEmpty) return null;
  return results.first;
}
