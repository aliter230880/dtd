import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'diller_deal_card_widget.dart';
import 'diller_profile_history_model.dart';
export 'diller_profile_history_model.dart';

class DillerProfileHistoryWidget extends StatefulWidget {
  const DillerProfileHistoryWidget({super.key});

  @override
  State<DillerProfileHistoryWidget> createState() => _DillerProfileHistoryWidgetState();
}

class _DillerProfileHistoryWidgetState extends State<DillerProfileHistoryWidget> {
  late DillerProfileHistoryModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DillerProfileHistoryModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<DealsRecord>>(
      future: queryDealsRecordOnce(
        queryBuilder: (dealsRecord) => dealsRecord
            .where(
          'owner',
          isEqualTo: currentUserReference,
        )
            .whereIn('status', [
          DealStatus.Canceled.name,
          DealStatus.Completed.name,
          DealStatus.CanceledByAdmin.name,
        ]).orderBy('created_time', descending: true),
      ),
      builder: (context, snapshot) {
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
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'tfx0cz1h' 
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                    Expanded(
                      child: Text(
                        '${FFLocalizations.of(context).getText('all')} ${getDealsCounterText(context,containerDealsRecordList.length )}',
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Builder(
                  builder: (context) {
                    if (containerDealsRecordList.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'gt3p2m8b' 
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ],
                      );
                    } else {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: containerDealsRecordList
                              .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: DillerDealCardWidget(
                                      key: Key('Keyzks_${e.reference.id}'),
                                      deal: e,
                                      width: size.width * 0.85,
                                    ),
                              ))
                              .toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
              if (containerDealsRecordList.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                          'HistoryPage',
                          queryParameters: {
                            'userRef': serializeParam(
                              currentUserReference,
                              ParamType.DocumentReference,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Text(
                        FFLocalizations.of(context).getText(
                          's1d7w77x' /* Просмотреть все */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondary,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
