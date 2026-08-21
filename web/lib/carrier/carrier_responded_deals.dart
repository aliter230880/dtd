import 'package:auto_deal_app/components/carrier_deal_card_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/diller_empty_active_deals_comp_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class CarrierRespondedDealsWidget extends StatefulWidget {
  final int length;
  const CarrierRespondedDealsWidget({super.key, this.length = 0});

  @override
  State<CarrierRespondedDealsWidget> createState() => _CarrierRespondedDealsWidgetState();
}

class _CarrierRespondedDealsWidgetState extends State<CarrierRespondedDealsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          '${FFLocalizations.of(context).getText('carrier_status_in_search')} (${widget.length})',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Builder(
          builder: (context) {
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 640),
                child: StreamBuilder<List<DealsRecord>>(
                  stream: queryDealsRecord(
                    queryBuilder: (dealsRecord) =>
                        dealsRecord.where('carriers', arrayContains: currentUserReference).whereIn(
                      'status',
                      [
                        DealStatus.InSearch.name,
                        DealStatus.InConfirm.name,
                      ],
                    ).orderBy('created_time', descending: true),
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }
                    List<DealsRecord> listViewDealsRecordList = snapshot.data!;
                
                    if (listViewDealsRecordList.isEmpty) {
                      return const DillerEmptyActiveDealsCompWidget();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 40),
                      scrollDirection: Axis.vertical,
                      itemCount: listViewDealsRecordList.length,
                      itemBuilder: (context, listViewIndex) {
                        final listViewDealsRecord = listViewDealsRecordList[listViewIndex];
                        return GestureDetector(
                          onTap: () async {
                            context.pushNamed(
                              'DealDetailCarrier',
                              queryParameters: {
                                'dealRef': serializeParam(
                                  listViewDealsRecord.reference,
                                  ParamType.DocumentReference,
                                ),
                              }.withoutNulls,
                            );
                          },
                          child: CarrierDealCardWidget(
                            
                            key: Key('Keyzks_${listViewDealsRecord.reference.id}'),
                            deal: listViewDealsRecord,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
