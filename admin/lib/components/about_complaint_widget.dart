import 'package:auto_deal_admin/backend/backend.dart';



import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'about_complaint_model.dart';
export 'about_complaint_model.dart';

class AboutComplaintWidget extends StatefulWidget {
  const AboutComplaintWidget({
    super.key,
    required this.complains,
    required this.dealsRecord,
  });

  final ComplainsRecord complains;
  final DealsRecord dealsRecord;

  @override
  State<AboutComplaintWidget> createState() => _AboutComplaintWidgetState();
}

class _AboutComplaintWidgetState extends State<AboutComplaintWidget> {
  late AboutComplaintModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AboutComplaintModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 0.0),
      child: Builder(
        builder: (context) {
          // if (loggedIn) {
          //   return SizedBox(
          //     height: 200.0,
          //     child: wrapWithModel(
          //       model: _model.activeComplaintModel,
          //       updateCallback: () => setState(() {}),
          //       child: ActiveComplaintWidget(complaintRef: widget.complains.reference),
          //     ),
          //   );
          // } else if (loggedIn) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 3.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/alert-triangle.svg',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Заказ снят с публикации',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        border: Border.all(
                          color: const Color(0xFFBDBDBD),
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 20.0, 6.0),
                        child: Text(
                          'Объявление отклонено',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                              ),
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
              if (widget.dealsRecord.cancelReason != null)
                FutureBuilder<DocumentSnapshot>(
                    future: widget.dealsRecord.cancelReason!.get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final cancelReason = snapshot.data!.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Причина отказа: ',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: const Color(0xFF424242),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                  TextSpan(
                                    text: '${cancelReason['reason']}',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            if (cancelReason['comment'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Комментарий: ',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: const Color(0xFF424242),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                      TextSpan(
                                        text: '${cancelReason['comment']}',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                        ),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            if (cancelReason['return_token'] == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Возвращено: ',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: const Color(0xFF424242),
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                      TextSpan(
                                        text: '${cancelReason['return_value']}\$',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,fontWeight: FontWeight.w700
                                        ),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
            ],
          );
          // } else {
          //   return Container(
          //     height: 200.0,
          //     decoration: const BoxDecoration(),
          //     child: wrapWithModel(
          //       model: _model.noActiveComplaintsModel,
          //       updateCallback: () => setState(() {}),
          //       child: const NoActiveComplaintsWidget(),
          //     ),
          //   );
          // }
        },
      ),
    );
  }
}
