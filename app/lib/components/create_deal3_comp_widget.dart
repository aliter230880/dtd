// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'create_deal3_comp_model.dart';
export 'create_deal3_comp_model.dart';

class CreateDeal3CompWidget extends StatefulWidget {
  const CreateDeal3CompWidget({
    super.key,
    required this.onTap,
  });

  final Future Function()? onTap;

  @override
  State<CreateDeal3CompWidget> createState() => _CreateDeal3CompWidgetState();
}

class _CreateDeal3CompWidgetState extends State<CreateDeal3CompWidget> {
  late CreateDeal3CompModel _model;
  bool loading = false;
  FlutterFlowMarker? flutterFlowMarker;
  List<Suggestion> result = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDeal3CompModel());

    _model.addressTextController ??= TextEditingController(text: FFAppState().createDealAddress);
    _model.descriptionFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String sessionToken = randomString(5, 7, true, false, false);

  void onSearchTap(Prediction prediction) async {
    final lat = prediction.lat;
    final lng = prediction.lng;
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не удалось определить гео-позицию')));
      return;
    }
    final latD = double.parse(lat);
    final lngD = double.parse(lng);
    final LatLng pos = LatLng(latD, lngD);
    _model.addressTextController.text = prediction.description ?? '-';
    FFAppState().createDealAddress = prediction.description ?? '-';
    FFAppState().createDealGeo = pos;
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  Future<Placemark?> _getAddressFromLatLng(LatLng pos) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return place;
    }

    return null;
  }

  void onCameraTap(LatLng pos) async {
    print('onCameraTap latLng: ${pos.toString()}');
    if (loading) return;
    setState(() {
      _model.addressTextController.text = '';
      FFAppState().createDealAddress = '';
      FFAppState().createDealGeo = null;
      loading = true;
    });

    try {
      final placemark = await _getAddressFromLatLng(pos);
      if (placemark != null) {
        final String markerIdVal = 'marker_id_${pos.hashCode}}';
        setState(() {
          flutterFlowMarker = FlutterFlowMarker(markerIdVal, pos);
          _model.addressTextController.text = getAddressFormattedName(placemark);
          FFAppState().createDealAddress = getAddressFormattedName(placemark);
          FFAppState().createDealGeo = pos;
          loading = false;
        });

        return;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Не удалось определить гео-позицию')));
        }
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не удалось определить гео-позицию')));
      }
      setState(() {
        loading = false;
      });
    }
  }

  String getAddressFormattedName(Placemark? placemark) {
    if (placemark == null) return '';
    String name = '';
    if (placemark.country != null) name += '${placemark.country}, ';
    if (placemark.administrativeArea != null) name += '${placemark.administrativeArea}, ';
    if (placemark.locality != null) name += '${placemark.locality}, ';
    if (placemark.street != null) name += '${placemark.street}, ';
    if (placemark.name != null) name += '${placemark.name}';
    return name;
  }

  Future<PlaceMarkWrapper?> searchQuery(LatLng pos) async {
    final urlString =
        'https://nominatim.openstreetmap.org/reverse?lat=${pos.latitude}&lon=${pos.longitude}&format=jsonv2';
    final result = await http.get(Uri.parse(urlString));

    if (result.statusCode == 200) {
      final data = jsonDecode(result.body);
      final latlng = LatLng(double.parse(data['lat']), double.parse(data['lon']));
      return PlaceMarkWrapper(placemark: data['display_name'], latLng: latlng);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 8.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  'le0i477y' /* Местоположение транспорта */,
                ),
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: _model.addressTextController!,
                googleAPIKey: "AIzaSyA4k-OQ3Pu-b3uWQMMSffFPuU0E1OlpHlw",
                inputDecoration: InputDecoration(
                  hintText: FFLocalizations.of(context).getText(
                    '772fktfe' /* Адрес объекта */,
                  ),
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).hintColor,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  errorStyle: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).error,
                        fontSize: 10.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  counterStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFF424245),
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0x00000000),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).border,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 18.0),
                  suffixIcon: _model.addressTextController!.text.isNotEmpty
                      ? InkWell(
                          onTap: () async {
                            _model.addressTextController?.clear();
                            FFAppState().createDealAddress = '';
                            FFAppState().createDealGeo = null;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.clear,
                            color: FlutterFlowTheme.of(context).border,
                            size: 20.0,
                          ),
                        )
                      : null,
                ),
                boxDecoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                debounceTime: 300,
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: onSearchTap,
                itemClick: (Prediction prediction) {},
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/Location.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: Text(
                            prediction.description ?? "-",
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                seperatedBuilder: Divider(color: FlutterFlowTheme.of(context).secondary),
                isCrossBtnShown: false,
                containerHorizontalPadding: 2,
                containerVerticalPadding: 0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
            // const SizedBox(height: 15),
            // Padding(
            //   padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            //   child: TextFormField(
            //     controller: _model.addressTextController!,
            //     onChanged: (value) async {
            //       setState(() {
            //         _model.mapVisible = false;
            //       });

            //       if (value.trim().isNotEmpty) {
            //         setState(() {
            //           loading = true;
            //         });
            //         List<Suggestion> suggestion = await GooglePlaceAutocompleteService().getAddres(value, sessionToken);

            //         if (result.isNotEmpty) {
            //           result.clear();
            //         }
            //         result.addAll(suggestion);
            //         setState(() {
            //           loading = false;
            //         });
            //       }
            //     },
            //     decoration: InputDecoration(
            //       hintText: FFLocalizations.of(context).getText('772fktfe'),
            //       hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            //             fontFamily: 'Inter',
            //             color: FlutterFlowTheme.of(context).hintColor,
            //             letterSpacing: 0.0,
            //             useGoogleFonts: false,
            //           ),
            //       errorStyle: FlutterFlowTheme.of(context).bodySmall.override(
            //             fontFamily: 'Inter',
            //             color: FlutterFlowTheme.of(context).error,
            //             fontSize: 10.0,
            //             letterSpacing: 0.0,
            //             useGoogleFonts: false,
            //           ),
            //       counterStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            //             fontFamily: 'Inter',
            //             color: const Color(0xFF424245),
            //             letterSpacing: 0.0,
            //             useGoogleFonts: false,
            //           ),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(
            //           color: Color(0x00000000),
            //           width: 1.0,
            //         ),
            //         borderRadius: BorderRadius.circular(12.0),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //           color: FlutterFlowTheme.of(context).border,
            //           width: 1.0,
            //         ),
            //         borderRadius: BorderRadius.circular(12.0),
            //       ),
            //       errorBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //           color: FlutterFlowTheme.of(context).error,
            //           width: 1.0,
            //         ),
            //         borderRadius: BorderRadius.circular(12.0),
            //       ),
            //       focusedErrorBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //           color: FlutterFlowTheme.of(context).error,
            //           width: 1.0,
            //         ),
            //         borderRadius: BorderRadius.circular(12.0),
            //       ),
            //       filled: true,
            //       fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            //       contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 16.0, 15.0, 16.0),
            //       suffixIcon: _model.addressTextController!.text.isNotEmpty
            //           ? InkWell(
            //               onTap: () async {
            //                 _model.addressTextController?.clear();
            //                 FFAppState().createDealAddress = '';
            //                 FFAppState().createDealGeo = null;
            //                 setState(() {});
            //               },
            //               child: Icon(
            //                 Icons.clear,
            //                 color: FlutterFlowTheme.of(context).border,
            //                 size: 20.0,
            //               ),
            //             )
            //           : null,
            //     ),
            //   ),
            // ),
            // Visibility(
            //   visible: !_model.mapVisible && _model.addressTextController.text.isNotEmpty,
            //   child: Container(
            //     constraints: const BoxConstraints(
            //       maxHeight: 200,
            //     ),
            //     child: loading
            //         ? const Center(child: CircularProgressIndicator())
            //         : result.isEmpty
            //             ? Center(
            //                 child: Text(
            //                   FFLocalizations.of(context).getText('no_result'),
            //                   style: FlutterFlowTheme.of(context).bodyMedium.override(
            //                         fontFamily: 'Inter',
            //                         color: FlutterFlowTheme.of(context).hintColor,
            //                         letterSpacing: 0.0,
            //                         useGoogleFonts: false,
            //                       ),
            //                 ),
            //               )
            //             : SingleChildScrollView(
            //                 child: Column(
            //                   children: result
            //                       .map((e) => Container(
            //                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //                             child: Row(
            //                               children: [
            //                                 SvgPicture.asset(
            //                                   'assets/images/Location.svg',
            //                                   width: 24,
            //                                   height: 24,
            //                                 ),
            //                                 const SizedBox(
            //                                   width: 7,
            //                                 ),
            //                                 Expanded(
            //                                   child: Text(
            //                                     e.description,
            //                                     style: FlutterFlowTheme.of(context).bodyMedium.override(
            //                                           fontFamily: 'Inter',
            //                                           letterSpacing: 0.0,
            //                                           fontSize: 16,
            //                                           fontWeight: FontWeight.normal,
            //                                           useGoogleFonts: false,
            //                                         ),
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ))
            //                       .toList(),
            //                 ),
            //               ),
            //   ),
            // ),
            
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_model.mapVisible) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 34.0),
                      child: Stack(
                        children: [
                          FlutterFlowGoogleMap(
                            onCameraTap: (l) {
                              onCameraTap(l);
                            },
                            controller: _model.googleMapsController,
                            onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                            initialLocation: _model.googleMapsCenter ??= const LatLng(55.7512, 37.6184),
                            markerColor: GoogleMarkerColor.violet,
                            markerImage: const MarkerImage(
                              imagePath: 'assets/images/Location_fill.svg',
                              isAssetImage: true,
                              size: 20.0,
                            ),
                            markers: [if (flutterFlowMarker != null) flutterFlowMarker!],
                            mapType: MapType.normal,
                            style: GoogleMapStyle.standard,
                            initialZoom: 14.0,
                            allowInteraction: true,
                            allowZoom: true,
                            showZoomControls: true,
                            showLocation: true,
                            showCompass: false,
                            showMapToolbar: false,
                            showTraffic: false,
                            centerMapOnMarkerTap: true,
                          ),
                          if (loading) const Align(child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.mapVisible = true;
                          setState(() {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                              child: SvgPicture.asset(
                                'assets/images/map.svg',
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.none,
                                // ignore: deprecated_member_use
                                color: FlutterFlowTheme.of(context).hintColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'nkkkg4f1' /* Показать на карте */,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).hintColor,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            if (FFAppState().createDealGeo != null && FFAppState().createDealAddress != '')
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    await widget.onTap?.call();
                  },
                  text: FFLocalizations.of(context).getText(
                    '7yyrs8y3' /* Далее */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                    elevation: 0.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PlaceMarkWrapper {
  final LatLng latLng;
  final String placemark;

  PlaceMarkWrapper({required this.latLng, required this.placemark});
}

class GooglePlaceAutocompleteService {
  String key = 'AIzaSyA4k-OQ3Pu-b3uWQMMSffFPuU0E1OlpHlw';
  String type = 'address';
  String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  Future<List<Suggestion>> getAddres(String query, String sessionToken) async {
    String request = '$baseURL?input=$query&types=$type&key=$key&sessiontoken=$sessionToken&language=ru';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      print(response.body);
      final result = jsonDecode(response.body);
      final items = result['predictions']
          .map<Suggestion>((p) => Suggestion(placeId: p['place_id'], description: p['description']))
          .toList();
      return items;
    } else {
      throw Exception('Ошибка при поиске');
    }
  }
}

String randomString(
  int minLength,
  int maxLength,
  bool lowercaseAz,
  bool uppercaseAz,
  bool digits,
) {
  var chars = '';
  if (lowercaseAz) {
    chars += 'abcdefghijklmnopqrstuvwxyz';
  }
  if (uppercaseAz) {
    chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  }
  if (digits) {
    chars += '0123456789';
  }
  final random = Random();
  return List.generate(randomInteger(minLength, maxLength), (index) => chars[random.nextInt(chars.length)]).join();
}

int randomInteger(int min, int max) {
  final random = Random();
  return random.nextInt(max - min + 1) + min;
}

class Suggestion {
  final String? placeId;
  final String description;

  Suggestion({this.placeId, required this.description});

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
