import 'package:flutter/cupertino.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/diller_deal_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'diller_dispute_deals_model.dart';
export 'diller_dispute_deals_model.dart';

class DillerDisputeDealsWidget extends StatefulWidget {
  const DillerDisputeDealsWidget({super.key});

  @override
  State<DillerDisputeDealsWidget> createState() => _DillerDisputeDealsWidgetState();
}

class _DillerDisputeDealsWidgetState extends State<DillerDisputeDealsWidget> {
  late DillerDisputeDealsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DillerDisputeDealsModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'DillerDisputeDeals'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'uk5wdd6r' /* Спор открыт */,
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
                child: FutureBuilder<List<DealsRecord>>(
                  future: queryDealsRecordOnce(
                    queryBuilder: (dealsRecord) => dealsRecord
                        .where(
                          'status',
                          isEqualTo: DealStatus.InDispute.serialize(),
                        )
                        .orderBy('created_time', descending: true),
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
                              'Key0xd_${listViewDealsRecord.reference.id}',
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
      ),
    );
  }
}
