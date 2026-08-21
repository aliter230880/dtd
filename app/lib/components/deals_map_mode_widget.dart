// ignore_for_file: avoid_print

import 'dart:async';

import 'dart:ui' as ui;

import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/backend/backend.dart' hide LatLng;
import '/backend/schema/enums/enums.dart';
import '/components/no_deals_map_alert_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'deals_map_mode_model.dart';
import 'take_login_alert_widget.dart';
export 'deals_map_mode_model.dart';

class DealsMapModeWidget extends StatefulWidget {
  const DealsMapModeWidget({
    super.key,
    required this.deals,
    required this.onListMode,
    required this.onRefresh,
  });

  final List<DealsRecord>? deals;
  final Future Function()? onListMode;
  final Future Function() onRefresh;

  @override
  State<DealsMapModeWidget> createState() => _DealsMapModeWidgetState();
}

class MarkerInfoModel {
  final DealsRecord dealsRecord;
  final Offset offset;

  MarkerInfoModel({required this.dealsRecord, required this.offset});
}

class _DealsMapModeWidgetState extends State<DealsMapModeWidget> {
  late DealsMapModeModel _model;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  MarkerInfoModel? selectedMarker;
  LatLng? currentUserLocationValue;
  static const CameraPosition _initial = CameraPosition(
    target: LatLng(55.7522200, 37.6155600),
    zoom: 10.0,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DealsMapModeModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.deals!.isEmpty) {
        bool refresh = await showDialog(
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                  child: const NoDealsMapAlertWidget(),
                );
              },
            ) ??
            false;

        if (refresh) {
          widget.onRefresh.call();
        }

        return;
      } else {
        return;
      }
    });

    init();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void init() async {
    if (widget.deals!.isEmpty) {
      markers.clear();
      selectedMarker = null;
      setState(() {});
      return;
    }

    final icon = await getImage();

    for (var deal in widget.deals!) {
      final markerId = MarkerId(deal.reference.id);
      markers[markerId] = Marker(
        markerId: markerId,
        position: LatLng(deal.location!.latitude, deal.location!.longitude),
        icon: icon,
        onTap: () {
          onTapMarker(markerId);
        },
      );
    }
    if (mounted) {
      setState(() {});
    }

    final currentUserLocationValueLatlng = await queryCurrentUserLocation();
    final controller = await _controller.future;
    //если есть локация пользователя, то показываем самую близкую
    if (currentUserLocationValueLatlng != null) {
      currentUserLocationValue = LatLng(
        currentUserLocationValueLatlng.latitude,
        currentUserLocationValueLatlng.longitude,
      );
      if (mounted) {
        setState(() {});
      }

      final userGeoPoint = GeoPoint(currentUserLocationValue!.latitude, currentUserLocationValue!.longitude);
      late DealsRecord closestDeal;
      double? minDistance;

      for (var deal in widget.deals!) {
        final geoPoint = GeoPoint(deal.location!.latitude, deal.location!.longitude);
        final distance = GeoUtil.distance(userGeoPoint, geoPoint);
        if (minDistance == null || distance < minDistance) {
          minDistance = distance;
          closestDeal = deal;
        }
      }
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(closestDeal.location!.latitude, closestDeal.location!.longitude), zoom: 12.0),
        ),
      );
    } else {
      //показываем первую локацию
      final first = widget.deals!.first;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(first.location!.latitude, first.location!.longitude), zoom: 12.0),
        ),
      );
    }
  }

  void onTapMarker(MarkerId markerId) async {
    final selectedDeal = widget.deals!.firstWhereOrNull((deal) => deal.reference.id == markerId.value);

    if (selectedDeal != null) {
      // final location = selectedDeal.location!;
      // final controller = await _controller.future;
      // ScreenCoordinate screenCoordinate =
      //     await controller.getScreenCoordinate(LatLng(location.latitude, location.longitude));
      // Offset offset = Offset(screenCoordinate.x.toDouble(), screenCoordinate.y.toDouble());
      const offset = Offset(0, 0);

      if (mounted) {
        setState(() {
          selectedMarker = MarkerInfoModel(dealsRecord: selectedDeal, offset: offset);
        });
      }
    } else {
      print('Не удалось найти маркер');
    }
  }

  Future<BitmapDescriptor> getImage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final bytes = await getBytesFromAsset('assets/images/pin.png', 64);

    final icon = BitmapDescriptor.fromBytes(bytes);
    return icon;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  int getDealRadius(LatLng dealLocation, LatLng userLocation) {
    final userGeoPoint = GeoPoint(userLocation.latitude, userLocation.longitude);
    final dealGeoPoint = GeoPoint(dealLocation.latitude, dealLocation.longitude);
    final distance = GeoUtil.distance(userGeoPoint, dealGeoPoint);
    return distance.round();
  }

  void onTapMap() {
    if (selectedMarker != null) {
      setState(() {
        selectedMarker = null;
      });
    }
  }

  void onNavigatoToDeal() async {
    if (loggedIn) {
      if (currentUserDocument?.type == UserType.Diller) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Чтобы видеть заказы, войдите как перевозчик',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        );
        return;
      } else {
        context.pushNamed(
          'DealDetailCarrier',
          queryParameters: {
            'dealRef': serializeParam(
              selectedMarker!.dealsRecord.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
        );

        return;
      }
    } else {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
            child: const TakeLoginAlertWidget(),
          );
        },
      );

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Builder(
      builder: (context) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _initial,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (argument) {
                onTapMap();
              },
            ),
            if (selectedMarker != null) buildMarkerCard(),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 36.0, 24.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Container(
                      width: 34.0,
                      height: 34.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await widget.onListMode?.call();
                        },
                        child: SvgPicture.asset(
                          'assets/images/list.svg',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        await context.pushNamed('FilterPage');
                        await widget.onRefresh.call();
                      },
                      child: Container(
                        width: 34.0,
                        height: 34.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: SvgPicture.asset(
                                'assets/images/Filter.svg',
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.none,
                              ),
                            ),
                            if (valueOrDefault<bool>(
                              (FFAppState().filterByRate != FilterRate.any) ||
                                  (FFAppState().filterByCostMin != 0) ||
                                  (FFAppState().filterByCostMax != 0) ||
                                  (FFAppState().filterByAuction != null) ||
                                  (FFAppState().filterByGeo != null),
                              false,
                            ))
                              Align(
                                alignment: const AlignmentDirectional(1.0, -1.0),
                                child: Container(
                                  width: 14.0,
                                  height: 14.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: Builder(builder: (context) {
                                      int counter = 0;
                                      if (FFAppState().filterByRate != FilterRate.any) {
                                        counter++;
                                      }
                                      if (FFAppState().filterByCostMin != 0 || FFAppState().filterByCostMax != 0) {
                                        counter++;
                                      }
                                      if (FFAppState().filterByAuction != null) {
                                        counter++;
                                      }
                                      if (FFAppState().filterByGeo != null) {
                                        counter++;
                                      }
                                      return Text(
                                        counter.toString(),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              fontSize: 6.0,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMarkerCard() {
    final size = MediaQuery.of(context).size;
    final empty = size.width - 300;

    return Positioned(
      top: (size.height / 2) - 40.0,
      left: empty / 2,
      child: Container(
        width: 300.0,
        height: 124,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFFFEFEFE),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    imageUrl: selectedMarker!.dealsRecord.carPhotos.first,
                    width: 80.0,
                    height: 75.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const SizedBox(
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ));
                    },
                    errorWidget: (context, error, stackTrace) => Image.asset(
                      'assets/images/error_image.png',
                      width: 82.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onNavigatoToDeal,
                  child: Text(
                    'Подробнее',
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                          useGoogleFonts: false,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            //
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedMarker!.dealsRecord.carName,
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: false,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    selectedMarker!.dealsRecord.locationAddress,
                    maxLines: 2,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                          useGoogleFonts: false,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/Location.svg',
                        width: 18,
                        height: 18,
                      ),
                      Text(
                        currentUserLocationValue != null
                            ? '${getDealRadius(LatLng(selectedMarker!.dealsRecord.location!.latitude, selectedMarker!.dealsRecord.location!.longitude), currentUserLocationValue!)} км. от вас'
                            : 'Нет доступа',
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
