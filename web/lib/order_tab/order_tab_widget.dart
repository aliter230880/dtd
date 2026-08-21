import 'package:auto_deal_app/index.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/deals_list_mode_widget.dart';
import '/components/deals_map_mode_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_tab_model.dart';
export 'order_tab_model.dart';

class OrderTabWidget extends StatefulWidget {
  const OrderTabWidget({super.key});

  @override
  State<OrderTabWidget> createState() => _OrderTabWidgetState();
}

class _OrderTabWidgetState extends State<OrderTabWidget> {
  late OrderTabModel _model;
  bool showFilter = false;
  bool loading = true;
  List<DealsRecord> deals = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderTabModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'OrderTab'});
    init();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> init() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }
    final filterByAuction = FFAppState().filterByAuction;
    final filterByRate = FFAppState().filterByRate;
    final fiterByPriceMin = FFAppState().filterByCostMin;
    final fiterByPriceMax = FFAppState().filterByCostMax;
    final filterByGeo = FFAppState().filterByGeo;
    final filterByGeoRadius = FFAppState().filterByGeoRadius;

    List<DealsRecord> queryDealsRecord = await queryDealsRecordOnce(
      queryBuilder: (dealsRecord) {
        dealsRecord = dealsRecord.where('status', isEqualTo: DealStatus.InSearch.serialize());

        if (filterByAuction != null) {
          dealsRecord = dealsRecord.where('auction', isEqualTo: filterByAuction);
        }

        if (filterByRate != FilterRate.any) {
          switch (filterByRate) {
            case FilterRate.five:
              dealsRecord = dealsRecord.where('owner_rate', isGreaterThanOrEqualTo: 5.0);
            case FilterRate.fourAndOver:
              dealsRecord = dealsRecord.where('owner_rate', isGreaterThanOrEqualTo: 4.0);
            case FilterRate.threeAndOver:
              dealsRecord = dealsRecord.where('owner_rate', isGreaterThanOrEqualTo: 3.0);
            default:
              dealsRecord = dealsRecord;

              dealsRecord = dealsRecord.orderBy('owner_rate');
          }
        } else if (fiterByPriceMin != 0 || fiterByPriceMax != 0) {
          if (fiterByPriceMin != 0) {
            dealsRecord = dealsRecord.where('price', isGreaterThanOrEqualTo: fiterByPriceMin);
          } else {
            dealsRecord = dealsRecord.where('price', isLessThanOrEqualTo: fiterByPriceMax);
          }
          dealsRecord = dealsRecord.orderBy('price');
        }

        return dealsRecord;
      },
    );

    if ((fiterByPriceMin != 0 || fiterByPriceMax != 0) && filterByRate != FilterRate.any) {
      queryDealsRecord = queryDealsRecord
          .where((d) => d.price >= fiterByPriceMin && d.price <= (fiterByPriceMax == 0 ? 99999999999 : fiterByPriceMax))
          .toList();
    }

    if (filterByGeo != null && filterByGeoRadius != 0) {
      final filterGeoPoint = GeoPoint(filterByGeo.latitude, filterByGeo.longitude);

      queryDealsRecord = queryDealsRecord.where((d) {
        final dealGeoPoint = GeoPoint(d.location!.latitude, d.location!.longitude);
        final distance = GeoUtil.distance(filterGeoPoint, dealGeoPoint);

        bool dRes = (distance <= filterByGeoRadius);
        return dRes;
      }).toList();
    }

    setState(() {
      deals = queryDealsRecord;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        showFilter = false;
                      });
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        't8gwz8md' /* Поиск заказов */,
                                      ),
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if (_model.dealsViewMode == DealsViewMode.Map) {
                                            _model.dealsViewMode = DealsViewMode.List;
                                          } else {
                                            _model.dealsViewMode = DealsViewMode.Map;
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 44,
                                          width: 128,
                                          decoration: BoxDecoration(
                                            color: _model.dealsViewMode == DealsViewMode.Map
                                                ? const Color(0xFFF9FAFB)
                                                : FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(32),
                                              topLeft: Radius.circular(32),
                                            ),
                                            border: Border.all(color: const Color(0xFFE9E9E9)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF101828).withOpacity(0.05),
                                                blurRadius: 2.0,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/map.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  Text(
                                                    FFLocalizations.of(context).getText(
                                                      'ms631o22' /* Поиск заказов */,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            showFilter = !showFilter;
                                          });
                                        },
                                        child: Container(
                                          height: 44,
                                          width: 128,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(32),
                                              topRight: Radius.circular(32),
                                            ),
                                            border: Border.all(color: const Color(0xFFE9E9E9)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF101828).withOpacity(0.05),
                                                blurRadius: 2.0,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/images/Filter.svg',
                                                          width: 24.0,
                                                          height: 24.0,
                                                          fit: BoxFit.cover,
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
                                                            child: Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(
                                                                  0.0, 2.0, 2.0, 0.0),
                                                              child: Container(
                                                                width: 14.0,
                                                                height: 14.0,
                                                                decoration: BoxDecoration(
                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Align(
                                                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                                                  child: Builder(builder: (context) {
                                                                    int counter = 0;
                                                                    if (FFAppState().filterByRate != FilterRate.any) {
                                                                      counter++;
                                                                    }
                                                                    if (FFAppState().filterByCostMin != 0 ||
                                                                        FFAppState().filterByCostMax != 0) {
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
                                                                      style: FlutterFlowTheme.of(context)
                                                                          .bodyMedium
                                                                          .override(
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
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    FFLocalizations.of(context).getText('wny8w3hs'),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  if (valueOrDefault<bool>(
                                    _model.dealsViewMode == DealsViewMode.List,
                                    true,
                                  )) {
                                    return wrapWithModel(
                                      model: _model.dealsListModeModel,
                                      updateCallback: () => setState(() {}),
                                      child: DealsListModeWidget(
                                        deals: deals,
                                        onRefresh: init,
                                        onTapMapMode: () async {
                                          _model.dealsViewMode = DealsViewMode.Map;
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  } else {
                                    return wrapWithModel(
                                      model: _model.dealsMapModeModel,
                                      updateCallback: () => setState(() {}),
                                      child: DealsMapModeWidget(
                                        deals: deals,
                                        onRefresh: init,
                                        onListMode: () async {
                                          _model.dealsViewMode = DealsViewMode.List;
                                          setState(() {});
                                        },
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
                  ),
                  if (showFilter)
                    Align(
                      alignment: Alignment.topRight,
                      child: FilterPageWidget(
                        onClose: () {
                          setState(() {
                            showFilter = false;
                          });
                          init();
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
