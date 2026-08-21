import 'package:auto_deal_admin/backend/backend.dart';
import 'package:auto_deal_admin/flutter_flow/app_router.gr.dart';
import 'package:auto_deal_admin/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'registration_status_page_model.dart';
export 'registration_status_page_model.dart';

@RoutePage()
class RegistrationStatusPageWidget extends StatefulWidget {
  const RegistrationStatusPageWidget({super.key});

  @override
  State<RegistrationStatusPageWidget> createState() => _RegistrationStatusPageWidgetState();
}

class _RegistrationStatusPageWidgetState extends State<RegistrationStatusPageWidget> {
  late RegistrationStatusPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegistrationStatusPageModel());
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
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(1.0, -1.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 44.0, 100.0, 0.0),
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                              child: Image.asset(
                                'assets/images/cbi_alexa-logo.png',
                                width: 55.0,
                                height: 55.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            'DTD',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(1.0, -1.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 60.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await authManager.signOut();
                        if (context.mounted) {
                          Phoenix.rebirth(context);
                        }
                      },
                      child: Container(
                        width: 210.0,
                        height: 58.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 100.0,
                              color: Color(0x14060F14),
                              offset: Offset(
                                0.0,
                                20.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(0.0),
                          ),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            'Выйти',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Builder(
                builder: (context) {
                  if (currentUserDocument?.status == AdminStatus.accept) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: Image.asset(
                            'assets/images/check-circle.png',
                            width: 140.0,
                            height: 140.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                          child: Text(
                            'Ваш профиль подтвержден',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Text(
                          'Начните работу!',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).hintText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              // context.goNamed('ProfilePage');
                            },
                            child: wrapWithModel(
                              model: _model.appButtonModel1,
                              updateCallback: () => setState(() {}),
                              child: const AppButtonWidget(
                                label: 'Далее',
                                isActive: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (currentUserDocument?.status == AdminStatus.reject) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: Image.asset(
                            'assets/images/alert-circle.png',
                            width: 140.0,
                            height: 140.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                          child: Text(
                            'Ваш профиль не подтвержден',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Text(
                          'Попробуйте зарегистрироваться заново!',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).hintText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              // context.goNamed('SignUpPage');
                            },
                            child: wrapWithModel(
                              model: _model.appButtonModel2,
                              updateCallback: () => setState(() {}),
                              child: const AppButtonWidget(
                                label: 'ОК',
                                isActive: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: Image.asset(
                            'assets/images/alert-triangle.png',
                            width: 140.0,
                            height: 140.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                          child: Text(
                            'Данные на проверке',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Text(
                          'Ожидайте решение администратора',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).hintText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminStatusWidget extends StatefulWidget {
  const _AdminStatusWidget();

  @override
  State<_AdminStatusWidget> createState() => __AdminStatusWidgetState();
}

class __AdminStatusWidgetState extends State<_AdminStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminsRecord>(
        initialData: currentUserDocument,
        future: AdminsRecord.getDocumentOnce(currentUserReference!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loadingWidget(context);
          }
          final admin = snapshot.data!;
          print('admin: ${admin.status}');
          return Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Container(
              width: 278.0,
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    icon(admin.status),
                    width: 140.0,
                    height: 140.0,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 0.0),
                    child: Text(
                      valueOrDefault<String>(
                        () {
                          if (admin.status == AdminStatus.wait) {
                            return 'Данные на проверке';
                          } else if (admin.status == AdminStatus.accept) {
                            return 'Ваш профиль подтвержден';
                          } else {
                            return 'Ваш профиль не подтвержден';
                          }
                        }(),
                        'Данные на проверке',
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      valueOrDefault<String>(
                        () {
                          if (admin.status == AdminStatus.wait) {
                            return 'Ожидайте решение администратора';
                          } else if (admin.status == AdminStatus.accept) {
                            return 'Начните работу';
                          } else if (admin.status == AdminStatus.reject) {
                            return 'Попробуйте зарегистрироваться заново';
                          } else {
                            return 'Ожидайте решение администратора';
                          }
                        }(),
                        'Ожидайте решение администратора',
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  if (admin.status != AdminStatus.wait && admin.status != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: AppButtonWidget(
                        label: 'ОК',
                        isActive: true,
                        onPressed: () async {
                          if (admin.status == AdminStatus.reject) {
                            await authManager.signOut();
                            if (context.mounted) {
                              Phoenix.rebirth(context);
                            }
                            return;
                          } else {
                            AutoRouter.of(context).replace(const HomeNavigatorWidgetRoute());
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }

  String icon(AdminStatus? s) {
    switch (s) {
      case AdminStatus.accept:
        return 'assets/images/check-circle.png';
      case AdminStatus.reject:
        return 'assets/images/alert-circle.png';
      case AdminStatus.wait:
        return 'assets/images/alert-triangle.png';
      default:
        return 'assets/images/alert-triangle.png';
    }
  }
}
