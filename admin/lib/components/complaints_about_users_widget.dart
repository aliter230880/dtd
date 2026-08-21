import 'package:auto_deal_admin/flutter_flow/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'complaints_about_users_model.dart';
export 'complaints_about_users_model.dart';

class ComplaintsAboutUsersWidget extends StatefulWidget {
  const ComplaintsAboutUsersWidget({super.key});

  @override
  State<ComplaintsAboutUsersWidget> createState() => _ComplaintsAboutUsersWidgetState();
}

class _ComplaintsAboutUsersWidgetState extends State<ComplaintsAboutUsersWidget> {
  late ComplaintsAboutUsersModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComplaintsAboutUsersModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ComplainsRecord>>(
        future: queryComplainsRecordOnce(
          queryBuilder: (complainsRecord) => complainsRecord
              .where(
                'type',
                isEqualTo: ComplainType.user.serialize(),
              )
              .orderBy('time', descending: true),
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

          List<ComplainsRecord> containerComplainsRecordList = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: Color(0xFFE0E0E0),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 20.0),
                    child: Builder(
                      builder: (context) {
                        if (containerComplainsRecordList.isNotEmpty) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFE0E0E0),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(32.0, 15.0, 32.0, 15.0),
                                      child: Text(
                                        '№',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).hintText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(34.0, 0.0, 150.0, 0.0),
                                      child: Text(
                                        'ФИО',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).hintText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      'Дата жалобы',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).hintText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(47.0, 0.0, 70.0, 0.0),
                                      child: Text(
                                        'Жалобу подал',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).hintText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: const AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 230.0, 0.0),
                                          child: Text(
                                            'Описание жалобы',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(context).hintText,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: containerComplainsRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewComplainsRecord = containerComplainsRecordList[listViewIndex];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      border: Border.all(
                                        color: const Color(0xFFE0E0E0),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: StreamBuilder<UsersRecord>(
                                      stream: UsersRecord.getDocument(listViewComplainsRecord.receiver!),
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

                                        final rowUsersRecord = snapshot.data!;

                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 72.0,
                                              decoration: const BoxDecoration(),
                                              child: Align(
                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 26.0, 0.0, 26.0),
                                                  child: Text(
                                                    (listViewIndex + 1).toString(),
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 212.0,
                                              decoration: const BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 12.0, 0.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100.0),
                                                      child: CachedNetworkImage(
                                                        fadeInDuration: const Duration(milliseconds: 500),
                                                        fadeOutDuration: const Duration(milliseconds: 500),
                                                        imageUrl: rowUsersRecord.photoUrl,
                                                        width: 36.0,
                                                        height: 36.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${rowUsersRecord.displayName}${rowUsersRecord.lastName}',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 82.0,
                                              decoration: const BoxDecoration(),
                                              child: Align(
                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                child: Text(
                                                  dateTimeFormat('dd.MM.yyyy', listViewComplainsRecord.time!),
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: FutureBuilder<UsersRecord>(
                                                future: UsersRecord.getDocumentOnce(listViewComplainsRecord.sender!),
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
                                              
                                                  final containerUsersRecord = snapshot.data!;
                                              
                                                  return Container(
                                                    width: 205.0,
                                                    decoration: const BoxDecoration(),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional.fromSTEB(48.0, 0.0, 12.0, 0.0),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(100.0),
                                                            child: CachedNetworkImage(
                                                              fadeInDuration: const Duration(milliseconds: 500),
                                                              fadeOutDuration: const Duration(milliseconds: 500),
                                                              imageUrl: containerUsersRecord.photoUrl,
                                                              width: 36.0,
                                                              height: 36.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${containerUsersRecord.displayName}${containerUsersRecord.lastName}',
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16.0,
                                                                letterSpacing: 0.0,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: const BoxDecoration(),
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 25.0, 0.0),
                                                  child: Text(
                                                    listViewComplainsRecord.text,
                                                    maxLines: 2,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(41.0, 0.0, 41.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () async {
                                                  context.pushRoute(ComplaintUserPageWidgetRoute(
                                                    user: rowUsersRecord,
                                                    appBarText: 'МОДЕРАЦИЯ ЖАЛОБ. ПРОФИЛЬ ПОЛЬЗОВАТЕЛЯ',
                                                    complainsRecord: listViewComplainsRecord,
                                                  ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    borderRadius: BorderRadius.circular(100.0),
                                                  ),
                                                  child: Align(
                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional.fromSTEB(16.0, 6.0, 16.0, 6.0),
                                                      child: Text(
                                                        rowUsersRecord.type == UserType.Carrier
                                                            ? 'Профиль перевозчика'
                                                            : 'Профиль дилера',
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              fontFamily: 'Inter',
                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                              fontSize: 12.0,
                                                              letterSpacing: 0.0,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(-0.2, 0.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(0.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/task.png',
                                      width: 142.0,
                                      height: 142.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0.02, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                        child: Text(
                                          'Жалоб нет',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                fontSize: 26.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        'Пока не поступило не одной жалобы на пользователей',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).hintText,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
