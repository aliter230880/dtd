import 'package:auto_deal_app/flutter_flow/flutter_flow_google_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/permissions_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'filter_location_page_model.dart';
export 'filter_location_page_model.dart';

class FilterLocationPageWidget extends StatefulWidget {
  const FilterLocationPageWidget({super.key});

  @override
  State<FilterLocationPageWidget> createState() => _FilterLocationPageWidgetState();
}

class _FilterLocationPageWidgetState extends State<FilterLocationPageWidget> {
  late FilterLocationPageModel _model;
  bool loading = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  final googleMapsController = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FilterLocationPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'FilterLocationPage'});

    _model.locationTextController ??= TextEditingController();
    _model.locationFocusNode ??= FocusNode();

    _model.sliderValue = FFAppState().filterByGeoRadius == 0 ? 100 : FFAppState().filterByGeoRadius.toDouble();

    getLocation();
  }

  void getLocation() async {
    currentUserLocationValue = await queryCurrentUserLocation();

    if (currentUserLocationValue != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(currentUserLocationValue!.latitude, currentUserLocationValue!.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        _model.locationTextController!.text = getAddressFormattedName(place);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (loading) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 20.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              'kyd3t5yu' /* Локация */,
            ),
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          actions: [
            InkWell(
              onTap: () async {
                context.pop('reset');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Text(
                  FFLocalizations.of(context).getText(
                    'cr7bvjc2' /* Сбросить */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondary,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Builder(
            builder: (context) {
              if (currentUserLocationValue != null) {
                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 20.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'agpce6fx' /* Локация */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: false,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.locationTextController,
                                  focusNode: _model.locationFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.locationTextController',
                                    const Duration(milliseconds: 0),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.next,
                                  readOnly: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: FFLocalizations.of(context).getText(
                                      'v9o7868x' /* Все города */,
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
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  textAlign: TextAlign.start,
                                  minLines: 1,
                                  maxLength: 250,
                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                      null,
                                  keyboardType: TextInputType.streetAddress,
                                  cursorColor: FlutterFlowTheme.of(context).primary,
                                  validator: _model.locationTextControllerValidator.asValidator(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: Text(
                                      '${(_model.sliderValue ?? 100).toStringAsFixed(0)} км',
                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                activeColor: FlutterFlowTheme.of(context).primaryText,
                                thumbColor: FlutterFlowTheme.of(context).secondaryBackground,
                                inactiveColor: const Color(0xFFE9E9E9),
                                min: 1.0,
                                max: 100.0,
                                value: _model.sliderValue ?? 100,
                                label: (_model.sliderValue ?? 100).toString(),
                                onChanged: (newValue) {
                                  newValue = double.parse(newValue.toStringAsFixed(0));
                                  setState(() => _model.sliderValue = newValue);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FlutterFlowGoogleMap(
                          onCameraTap: (l) {},
                          controller: googleMapsController,
                          initialLocation: currentUserLocationValue,
                          markerColor: GoogleMarkerColor.violet,
                          markerImage: const MarkerImage(
                            imagePath: 'assets/images/Location_fill.svg',
                            isAssetImage: true,
                            size: 20.0,
                          ),
                          markers: [FlutterFlowMarker('marker', currentUserLocationValue!)],
                          mapType: MapType.normal,
                          style: GoogleMapStyle.standard,
                          initialZoom: 14.0,
                          allowInteraction: true,
                          allowZoom: true,
                          showZoomControls: true,
                          showLocation: false,
                          showCompass: false,
                          showMapToolbar: false,
                          showTraffic: false,
                          centerMapOnMarkerTap: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 40.0, 24.0, 24.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            final location = {
                              "geo": currentUserLocationValue,
                              "address": _model.locationTextController.text.trim(),
                              "radius": (_model.sliderValue ?? 100).toInt(),
                            };
                            context.pop(location);
                          },
                          text: FFLocalizations.of(context).getText(
                            'u9koen24' /* Сохранить */,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 56.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                            borderSide: BorderSide(
                              width: 0.0,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/location-pin.svg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 10.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '8927p2r9' /* Дать доступ к местоположению */,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                            Text(
                              FFLocalizations.of(context).getText(
                                'r3jwqfcq' /* Нам нужно знать ваше местополо... */,
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          await requestPermission(locationPermission);
                        },
                        text: FFLocalizations.of(context).getText(
                          'g8pzikgj' /* Дать доступ */,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
