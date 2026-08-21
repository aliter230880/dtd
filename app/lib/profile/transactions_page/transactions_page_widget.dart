import 'package:flutter/cupertino.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'transactions_page_model.dart';
export 'transactions_page_model.dart';

class TransactionsPageWidget extends StatefulWidget {
  const TransactionsPageWidget({super.key});

  @override
  State<TransactionsPageWidget> createState() => _TransactionsPageWidgetState();
}

class _TransactionsPageWidgetState extends State<TransactionsPageWidget> {
  late TransactionsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionsPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'TransactionsPage'});
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
              'jewjbyo3' /* История операций */,
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
          child: FutureBuilder<List<TransactionsRecord>>(
            future: queryTransactionsRecordOnce(
              queryBuilder: (transactionsRecord) => transactionsRecord
                  .where(
                    'user_ref',
                    isEqualTo: currentUserReference,
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
              List<TransactionsRecord> containerTransactionsRecordList = snapshot.data!;
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(),
                child: Builder(
                  builder: (context) {
                    if (containerTransactionsRecordList.isEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                '2rjx5ks0' /* У вас пока нет транзакций */,
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
                        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 14.0, 24.0, 14.0),
                        child: Builder(
                          builder: (context) {
                            final transactionsvar = containerTransactionsRecordList.map((e) => e).toList();

                            Map<String, List<TransactionsRecord>> groupedTransactions = {};

                            for (var transaction in transactionsvar) {
                              String dateKey =
                                  DateFormat('yyyy-MM-dd').format(transaction.createdTime ?? DateTime.now());
                              if (groupedTransactions.containsKey(dateKey)) {
                                groupedTransactions[dateKey]?.add(transaction);
                              } else {
                                groupedTransactions[dateKey] = [transaction];
                              }
                            }

                            List<String> sortedDates = groupedTransactions.keys.toList()
                              ..sort((a, b) => b.compareTo(a));

                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: groupedTransactions.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                              itemBuilder: (context, transactionsvarIndex) {
                                String date = sortedDates[transactionsvarIndex];

                                List<TransactionsRecord> dayTransactions = groupedTransactions[date]!
                                  ..sort((a, b) => a.createdTime == null || b.createdTime == null
                                      ? 0
                                      : (a.createdTime!).compareTo(b.createdTime!));
                                // final transactionsvarItem = transactionsvar[transactionsvarIndex];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    groupDivider(_formatDate(DateTime.parse(date))),
                                    ...dayTransactions.map(
                                      (transaction) => _TransactionTile(transaction: transaction),
                                    ),
                                    const SizedBox(height: 12),
                                    const Divider(height: 0, thickness: 1, color: Color(0xFFE9E9E9)),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget groupDivider(String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Text(
            date,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  useGoogleFonts: false,
                ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return FFLocalizations.of(context).getText('today');
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return FFLocalizations.of(context).getText('yesterday');
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionsRecord transaction;
  const _TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 51.0,
      decoration: const BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Center(
              child: Icon(
                icon(transaction.type!),
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          const SizedBox(height: 2),
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
