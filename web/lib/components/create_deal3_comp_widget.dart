// ignore_for_file: avoid_print

import 'dart:async';

import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_deal3_comp_model.dart';
export 'create_deal3_comp_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

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

  Future<PlaceMarkWrapper?> _getAddressFromLatLng(LatLng pos) async {
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
      final address = await _getAddressFromLatLng(pos);
      if (address != null) {
        final String markerIdVal = 'marker_id_${pos.hashCode}}';
        setState(() {
          flutterFlowMarker = FlutterFlowMarker(markerIdVal, pos);
          _model.addressTextController.text = address.placemark;
          FFAppState().createDealAddress = address.placemark;
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 384),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
              ],
            ),
          ),
          if (FFAppState().createDealGeo != null && FFAppState().createDealAddress != '')
            Container(
              margin: const EdgeInsets.only(top: 18),
              width: 384,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _model.addressTextController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      useGoogleFonts: false,
                    ),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 34.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 640,
                maxHeight: size.height * 0.6,
              ),
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
                      imagePath: 'assets/images/pin.png',
                      isAssetImage: true,
                      size: 30.0,
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
            ),
          ),
          if (FFAppState().createDealGeo != null && FFAppState().createDealAddress != '')
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 384),
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
                    hoverColor: FlutterFlowTheme.of(context).warning,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PlaceMarkWrapper {
  final LatLng latLng;
  final String placemark;

  PlaceMarkWrapper({required this.latLng, required this.placemark});
}
