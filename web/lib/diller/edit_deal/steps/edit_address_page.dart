// ignore_for_file: avoid_print

import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/components/create_deal3_comp_widget.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_google_map.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

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
    addressTextController.clear();
    setState(() {
      selectedAdress = null;
      selectedGeo = null;
      loading = true;
    });

    try {
      final address = await _getAddressFromLatLng(pos);
      if (address != null) {
        final String markerIdVal = 'marker_id_${pos.hashCode}}';
        setState(() {
          flutterFlowMarker = FlutterFlowMarker(markerIdVal, pos);
          addressTextController.text = address.placemark;
          selectedAdress = address.placemark;
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: save,
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
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
            if (selectedGeo != null && selectedAdress != '')
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
                  controller: addressTextController,
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
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
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
                      controller: googleMapsController,
                      onCameraIdle: (latLng) => googleMapsCenter = latLng,
                      initialLocation: googleMapsCenter ??= const LatLng(55.7512, 37.6184),
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
          ],
        ),
      ),
    );
  }
}
