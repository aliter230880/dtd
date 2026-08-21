import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'user_profile_transactions_model.dart';
export 'user_profile_transactions_model.dart';

class UserProfileTransactionsWidget extends StatefulWidget {
  const UserProfileTransactionsWidget({super.key});

  @override
  State<UserProfileTransactionsWidget> createState() => _UserProfileTransactionsWidgetState();
}

class _UserProfileTransactionsWidgetState extends State<UserProfileTransactionsWidget> {
  late UserProfileTransactionsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileTransactionsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionsRecord>>(
      stream: queryTransactionsRecord(
        queryBuilder: (transactionsRecord) => transactionsRecord
            .where(
              'user_ref',
              isEqualTo: currentUserReference,
            )
            .orderBy('created_time', descending: true).limit(5),
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
        List<TransactionsRecord> containerTransactionsRecordList = snapshot.data!;
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
                        '1bfvjn7y' /* История операций */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Builder(
                  builder: (context) {
                    if (containerTransactionsRecordList.isEmpty) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'iegasi4g' /* Операций пока нет */,
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
                      return Builder(
                        builder: (context) {
                          final transactionsVar = containerTransactionsRecordList.map((e) => e).toList();
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: transactionsVar.length,
                            itemBuilder: (context, transactionsVarIndex) {
                              final transactionsVarItem = transactionsVar[transactionsVarIndex];
                              return TransactionTile(transaction: transactionsVarItem);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              if (containerTransactionsRecordList.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('TransactionsPage');
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
                ),
            ],
          ),
        );
      },
    );
  }
}

class TransactionTile extends StatelessWidget {
  final TransactionsRecord transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 62.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      icon(transaction.type!),
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(text(transaction.type!)),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    Text(
                                      dateTimeFormat(
                                        'dd MMMM, HH:mm',
                                        transaction.createdTime!,
                                        locale: FFLocalizations.of(context).languageCode,
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
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                              child: Text(
                                '${prefix(transaction.type!)}${formatNumber(
                                  transaction.amount,
                                  formatType: FormatType.custom,
                                  currency: '\$',
                                  format: '',
                                  locale: '',
                                )}',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0.0,
              thickness: 1.0,
              color: Color(0xFFE9E9E9),
            ),
          ],
        ),
      ),
    );
  }

  String prefix(String type) {
    switch (type) {
      case 'response':
      case 'publication':
        return '-';
      case 'popup':
      case 'adminReturn':
        return '+';
      default:
        return '';
    }
  }

  IconData icon(String type) {
    switch (type) {
      case 'response':
      case 'publication':
        return Icons.north_east_outlined;
      case 'popup':
        return Icons.add_card;

      default:
        return Icons.price_check_outlined;
    }
  }

  String text(String type) {
    switch (type) {
      case 'response':
        return 'rug8otza';
      case 'publication':
        return 'rug8otza2';
      case 'adminReturn':
        return 'rug8otza3';
      case 'popup':
        return 'q381mube';

      default:
        return 'error';
    }
  }
}
