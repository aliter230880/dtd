import 'package:flutter/cupertino.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/diller_deal_card_widget.dart';
import '/components/diller_empty_active_deals_comp_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'diller_active_deals_model.dart';
export 'diller_active_deals_model.dart';

class DillerActiveDealsWidget extends StatefulWidget {
  const DillerActiveDealsWidget({super.key});

  @override
  State<DillerActiveDealsWidget> createState() => _DillerActiveDealsWidgetState();
}

class _DillerActiveDealsWidgetState extends State<DillerActiveDealsWidget> {
  late DillerActiveDealsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DillerActiveDealsModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'DillerActiveDeals'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

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
          FFLocalizations.of(context).getText(
            'gqbw82ra' /* Активные заказы */,
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
        child: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
              child: StreamBuilder<List<DealsRecord>>(
                stream: queryDealsRecord(
                  queryBuilder: (dealsRecord) =>
                      dealsRecord.where('owner', isEqualTo: currentUserReference).whereIn('status', [
                    DealStatus.InSearch.name,
                    DealStatus.InConfirm.name ,
                    DealStatus.InActive.name,
                    DealStatus.InConfirmComplete.name,
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
                  List<DealsRecord> listViewDealsRecordList = snapshot.data!;

                  if (listViewDealsRecordList.isEmpty) {
                    return wrapWithModel(
                      model: _model.dillerEmptyActiveDealsCompModel,
                      updateCallback: () => setState(() {}),
                      child: const DillerEmptyActiveDealsCompWidget(),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewDealsRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewDealsRecord = listViewDealsRecordList[listViewIndex];
                      return wrapWithModel(
                        model: _model.dillerDealCardModels.getModel(
                          listViewDealsRecord.reference.id,
                          listViewIndex,
                        ),
                        updateCallback: () => setState(() {}),
                        child: DillerDealCardWidget(
                          key: Key(
                            'Keyzks_${listViewDealsRecord.reference.id}',
                          ),
                          deal: listViewDealsRecord,
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
