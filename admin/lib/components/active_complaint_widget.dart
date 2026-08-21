import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'active_complaint_model.dart';
export 'active_complaint_model.dart';

class ActiveComplaintWidget extends StatefulWidget {
  const ActiveComplaintWidget({
    super.key,
    required this.complaintRef,
  });

  final DocumentReference? complaintRef;

  @override
  State<ActiveComplaintWidget> createState() => _ActiveComplaintWidgetState();
}

class _ActiveComplaintWidgetState extends State<ActiveComplaintWidget> {
  late ActiveComplaintModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActiveComplaintModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ComplainsRecord>(
      future: ComplainsRecord.getDocumentOnce(widget.complaintRef!),
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

        final columnComplainsRecord = snapshot.data!;

        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
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
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Активная жалоба',
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
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 22.0, 0.0, 0.0),
              child: Text(
                'Заказ № ',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 5.0),
              child: Text(
                'Дата жалобы: ${dateTimeFormat('d/M/y', columnComplainsRecord.time)}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: const Color(0xFF424242),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            FutureBuilder<UsersRecord>(
              future:
                  UsersRecord.getDocumentOnce(columnComplainsRecord.sender!),
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

                final richTextUsersRecord = snapshot.data!;

                return RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Жалобу подал: ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: const Color(0xFF424242),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      TextSpan(
                        text:
                            '${richTextUsersRecord.displayName}${richTextUsersRecord.lastName}',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).hintText,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 5.0),
              child: Text(
                'Описание жалобы',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: const Color(0xFF424242),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Text(
              columnComplainsRecord.text,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        );
      },
    );
  }
}
