

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
            : Builder(
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
    );
  }
}
