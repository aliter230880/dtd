import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/components/carrier_deal_card_widget.dart';
import 'package:flutter/cupertino.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/diller_deal_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'history_page_model.dart';
export 'history_page_model.dart';

class HistoryPageWidget extends StatefulWidget {
  const HistoryPageWidget({
    super.key,
    required this.userRef,
  });

  final DocumentReference? userRef;

  @override
  State<HistoryPageWidget> createState() => _HistoryPageWidgetState();
}

class _HistoryPageWidgetState extends State<HistoryPageWidget> {
  late HistoryPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HistoryPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'HistoryPage'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userType = currentUserDocument?.type;
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
          FFLocalizations.of(context).getText(
            'nmf3l6bm' 
          ),
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
        child: FutureBuilder<List<DealsRecord>>(
          future: queryDealsRecordOnce(
            queryBuilder: (dealsRecord) => dealsRecord
                .where(
              userType == UserType.Diller ? 'owner' : 'carrier',
              isEqualTo: widget.userRef,
            )
                .whereIn('status', [
              DealStatus.Canceled.name,
              DealStatus.Completed.name,
              DealStatus.CanceledByAdmin.name,
            ]).orderBy('created_time', descending: true),
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
            List<DealsRecord> containerDealsRecordList = snapshot.data!;
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(),
              child: Builder(
                builder: (context) {
                  if (containerDealsRecordList.isEmpty) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/no_deals.png',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '19xytohs' 
                              ,
                            ),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${FFLocalizations.of(context).getText('all')} ${getDealsCounterText(context,containerDealsRecordList.length )}',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: const Color(0xFF424245),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  final historyVar = containerDealsRecordList.map((e) => e).toList();
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: historyVar.length,
                                    itemBuilder: (context, historyVarIndex) {
                                      final historyVarItem = historyVar[historyVarIndex];
                                      if (userType == UserType.Diller) {
                                        return wrapWithModel(
                                          model: _model.dillerDealCardModels.getModel(
                                            historyVarItem.reference.id,
                                            historyVarIndex,
                                          ),
                                          updateCallback: () => setState(() {}),
                                          child: DillerDealCardWidget(
                                            key: Key(
                                              'Keylsw_${historyVarItem.reference.id}',
                                            ),
                                            deal: historyVarItem,
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                            onTap: () {
                                              context.pushNamed(
                                                'DealDetailCarrier',
                                                queryParameters: {
                                                  'dealRef': serializeParam(
                                                    historyVarItem.reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            child: CarrierDealCardWidget(deal: historyVarItem));
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
