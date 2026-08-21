// ignore_for_file: avoid_print

import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_google_map.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditDealAddressPage extends StatefulWidget {
  const EditDealAddressPage({super.key, required this.deal});

  final DealsRecord? deal;
  @override
  State<EditDealAddressPage> createState() => _EditDealAddressPageState();
}

class _EditDealAddressPageState extends State<EditDealAddressPage> {
  late TextEditingController addressTextController;
  bool loading = false;
  bool mapVisible = false;
  FlutterFlowMarker? flutterFlowMarker;
  String? selectedAdress;
  LatLng? selectedGeo;
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  @override
  void initState() {
    addressTextController = TextEditingController(text: widget.deal?.locationAddress);
    selectedAdress = widget.deal?.locationAddress;
    selectedGeo = widget.deal?.location;
    super.initState();
  }

  @override
  void dispose() {
    addressTextController.dispose();
    super.dispose();
  }

  void save() async {
    await widget.deal?.reference.update(createDealsRecordData(locationAddress: selectedAdress, location: selectedGeo));
    if (mounted) context.pop();
  }

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
    addressTextController.text = prediction.description ?? '-';
    selectedAdress = prediction.description ?? '-';
    selectedGeo = pos;
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
    addressTextController.clear();
    setState(() {
      selectedAdress = null;
      selectedGeo = null;
      loading = true;
    });

    try {
      final placemark = await _getAddressFromLatLng(pos);
      if (placemark != null) {
        final String markerIdVal = 'marker_id_${pos.hashCode}}';
        setState(() {
          flutterFlowMarker = FlutterFlowMarker(markerIdVal, pos);
          addressTextController.text = getAddressFormattedName(placemark);
          selectedAdress = getAddressFormattedName(placemark);
          selectedGeo = pos;
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

  @override
  Widget build(BuildContext context) {
    bool isActive = selectedGeo != null && selectedAdress != null;
    return Scaffold(
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
        actions: [
          if (isActive)
            GestureDetector(
              onTap: save,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  FFLocalizations.of(context).getText('i4orpypq'),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        useGoogleFonts: false,
                      ),
                ),
              ),
            ),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
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
                  textEditingController: addressTextController,
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
                    suffixIcon: addressTextController.text.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              addressTextController.clear();
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
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (mapVisible) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 34.0),
                        child: Stack(
                          children: [
                            FlutterFlowGoogleMap(
                              onCameraTap: (l) {
                                onCameraTap(l);
                              },
                              controller: googleMapsController,
                              onCameraIdle: (latLng) => googleMapsCenter = latLng,
                              initialLocation: googleMapsCenter ??= const LatLng(55.7512, 37.6184),
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
                            mapVisible = true;
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
            ],
          ),
        ),
      ),
    );
  }
}
