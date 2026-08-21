import 'dart:developer';

import 'package:auto_deal_admin/app_state.dart';
import 'package:auto_deal_admin/backend/backend.dart';
import 'package:auto_deal_admin/flutter_flow/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import '../backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'about_dispute_model.dart';
import 'dispute_dialog_widget.dart';
export 'about_dispute_model.dart';

class AboutDisputeWidget extends StatefulWidget {
  final DealsRecord dealsRecord;
  const AboutDisputeWidget({super.key, required this.dealsRecord});

  @override
  State<AboutDisputeWidget> createState() => _AboutDisputeWidgetState();
}

class _AboutDisputeWidgetState extends State<AboutDisputeWidget> {
  late AboutDisputeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AboutDisputeModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void onActivateDeal(Map<String, dynamic>? result) async {
    log('onActivateDeal: $result');
    try {
      if (result != null) {
        await widget.dealsRecord.reference.update({
          'status': DealStatus.InActive.serialize(),
          'disput_created_by': null,
          'disput_created_time': null,
        });

        int dillerRefund = result['diller'] ?? 0;
        int carrierRefund = result['carrier'] ?? 0;

        if (dillerRefund > 0) {
          await widget.dealsRecord.owner?.update({
            'balance': FieldValue.increment(dillerRefund),
          });

          final dillerTransaction = createTransactionsRecordData(
            amount: dillerRefund.toDouble(),
            userRef: widget.dealsRecord.owner,
            type: 'adminReturn',
            createdTime: DateTime.now(),
          );

          await TransactionsRecord.collection.doc().set(dillerTransaction);
        }

        if (carrierRefund > 0) {
          await widget.dealsRecord.carrier?.update({
            'balance': FieldValue.increment(carrierRefund),
          });

          final carrierTransaction = createTransactionsRecordData(
            amount: dillerRefund.toDouble(),
            userRef: widget.dealsRecord.carrier,
            type: 'adminReturn',
            createdTime: DateTime.now(),
          );

          await TransactionsRecord.collection.doc().set(carrierTransaction);
        }
      }
    } catch (e) {
      log('onActivateDeal error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).error2,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Открыт спор',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1.0,
              color: Color(0xFFE9E9E9),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        final result = await queryChatsRecordOnce(
                          queryBuilder: (q) {
                            q = q.where('type', isEqualTo: 'disput');
                            return q;
                          },
                        );
                        print(result.length);
                        if (result.isNotEmpty) {
                          FFAppState().currentChatRef = result.first.reference;
                        }
                        if (context.mounted) context.navigateTo(const ChatPageWidgetRoute());
                      } catch (e) {
                        log('error: $e');
                        if (context.mounted) context.navigateTo(const ChatPageWidgetRoute());
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 8.0),
                        child: Text(
                          'Чат спора',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                              child: DisputeDialogWidget(
                                dealsRecord: widget.dealsRecord,
                                onAction: onActivateDeal,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).success2,
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 8.0),
                          child: Text(
                            'Разрешить спор',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final data = {
                        'status': DealStatus.Completed.name,
                        'completed_by': null,
                        'disput_created_by': null,
                      };
                      await widget.dealsRecord.reference.update(data);

                      if (context.mounted) {
                        context.back();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        border: Border.all(
                          color: const Color(0xFFBDBDBD),
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 8.0),
                        child: Text(
                          'Завершить заказ',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        // } else {
        //   return Column(
        //     mainAxisSize: MainAxisSize.max,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
        //         child: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Container(
        //               width: 22.0,
        //               height: 22.0,
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 border: Border.all(
        //                   color: const Color(0xFF111111),
        //                   width: 1.0,
        //                 ),
        //               ),
        //               child: const Icon(
        //                 Icons.done_sharp,
        //                 color: Color(0xFF111111),
        //                 size: 15.0,
        //               ),
        //             ),
        //             Padding(
        //               padding:
        //                   const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
        //               child: Text(
        //                 'Открыт спор',
        //                 style: FlutterFlowTheme.of(context).bodyMedium.override(
        //                       fontFamily: 'Inter',
        //                       fontSize: 18.0,
        //                       letterSpacing: 0.0,
        //                     ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       const Divider(
        //         height: 1.0,
        //         color: Color(0xFFE9E9E9),
        //       ),
        //       Padding(
        //         padding: const EdgeInsetsDirectional.fromSTEB(0.0, 22.0, 0.0, 12.0),
        //         child: RichText(
        //           textScaler: MediaQuery.of(context).textScaler,
        //           text: TextSpan(
        //             children: [
        //               TextSpan(
        //                 text: 'Возвращено дилеру: ',
        //                 style: FlutterFlowTheme.of(context).bodyMedium.override(
        //                       fontFamily: 'Inter',
        //                       color: FlutterFlowTheme.of(context).primaryText,
        //                       fontSize: 16.0,
        //                       letterSpacing: 0.0,
        //                       fontWeight: FontWeight.normal,
        //                     ),
        //               ),
        //               TextSpan(
        //                 text: '110\$',
        //                 style: TextStyle(
        //                   color: FlutterFlowTheme.of(context).primaryText,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 16.0,
        //                 ),
        //               )
        //             ],
        //             style: FlutterFlowTheme.of(context).bodyMedium.override(
        //                   fontFamily: 'Inter',
        //                   letterSpacing: 0.0,
        //                 ),
        //           ),
        //         ),
        //       ),
        //       Row(
        //         mainAxisSize: MainAxisSize.max,
        //         children: [
        //           Container(
        //             decoration: BoxDecoration(
        //               color: FlutterFlowTheme.of(context).primary,
        //               borderRadius: BorderRadius.circular(32.0),
        //             ),
        //             child: Padding(
        //               padding:
        //                   const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 8.0),
        //               child: Text(
        //                 'Чат спора',
        //                 style: FlutterFlowTheme.of(context).bodyMedium.override(
        //                       fontFamily: 'Inter',
        //                       fontSize: 16.0,
        //                       letterSpacing: 0.0,
        //                     ),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding:
        //                 const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(32.0),
        //                 border: Border.all(
        //                   color: const Color(0xFFBDBDBD),
        //                   width: 1.0,
        //                 ),
        //               ),
        //               child: Padding(
        //                 padding: const EdgeInsetsDirectional.fromSTEB(
        //                     20.0, 6.0, 20.0, 8.0),
        //                 child: Text(
        //                   'Завершить заказ',
        //                   style:
        //                       FlutterFlowTheme.of(context).bodyMedium.override(
        //                             fontFamily: 'Inter',
        //                             fontSize: 16.0,
        //                             letterSpacing: 0.0,
        //                           ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   );
        // }
      },
    );
  }
}
