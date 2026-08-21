import 'package:auto_route/auto_route.dart';

import '../auth/firebase_auth/auth_util.dart';
import '../backend/schema/enums/enums.dart';
import '../main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_nav_bar_model.dart';
export 'home_nav_bar_model.dart';

class HomeNavBarWidget extends StatefulWidget {
  final int currentIndex;
  const HomeNavBarWidget({super.key, required this.currentIndex});

  @override
  State<HomeNavBarWidget> createState() => _HomeNavBarWidgetState();
}

class _HomeNavBarWidgetState extends State<HomeNavBarWidget> {
  late HomeNavBarModel _model;
  bool isAnaliticts = true;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeNavBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF262626),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //logo
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 45.0),
              child: Row(
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
                      'assets/images/logo_white.png',
                      width: 48.0,
                      height: 48.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DTD',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 20.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          'Админ',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Аналитика
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAnaliticts = true;
                  });
                  if (widget.currentIndex != 0) {
                    context.navigateTo(destinations[0]);
                  }
                },
                child: Container(
                  width: 216.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: isAnaliticts
                        ? Border.all(
                            color: const Color(0xFFBDBDBD),
                            width: 1.0,
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/chart-bar.svg',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Аналитика',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Статистика по клиентам
            if (isAnaliticts)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                child: GestureDetector(
                  onTap: () {
                    if (widget.currentIndex != 0) {
                      context.navigateTo(destinations[0]);
                    }
                  },
                  child: Container(
                    width: 216.0,
                    decoration: BoxDecoration(
                      color: widget.currentIndex == 0 ? FlutterFlowTheme.of(context).primary : null,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(22.0, 8.0, 0.0, 8.0),
                      child: Text(
                        'Статистика по клиентам',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            //Сводные данные
            if (isAnaliticts)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                child: GestureDetector(
                  onTap: () {
                    if (widget.currentIndex != 1) {
                      context.navigateTo(destinations[1]);
                    }
                  },
                  child: Container(
                    width: 216.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: widget.currentIndex == 1 ? FlutterFlowTheme.of(context).primary : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(22.0, 8.0, 0.0, 8.0),
                      child: Text(
                        'Сводные данные',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            //Поддержка
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAnaliticts = false;
                  });
                  if (widget.currentIndex != 2) {
                    context.navigateTo(destinations[2]);
                  }
                },
                child: Container(
                  width: 216.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: widget.currentIndex == 2 ? FlutterFlowTheme.of(context).primary : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/supportIcon.svg',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Поддержка',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Чат
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAnaliticts = false;
                  });
                  if (widget.currentIndex != 3) {
                    context.navigateTo(destinations[3]);
                  }
                },
                child: Container(
                  width: 216.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: widget.currentIndex == 3 ? FlutterFlowTheme.of(context).primary : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 30.0,
                          height: 28.0,
                          child: Stack(
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(-1.0, 1.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(0.0),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/mail.svg',
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Align(
                              //   alignment: const AlignmentDirectional(1.0, -1.0),
                              //   child: Container(
                              //     width: 17.0,
                              //     height: 17.0,
                              //     decoration: const BoxDecoration(
                              //       color: Color(0xFFF54336),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: Align(
                              //       alignment: const AlignmentDirectional(0.0, 0.0),
                              //       child: Text(
                              //         '2',
                              //         style: FlutterFlowTheme.of(context).bodyMedium.override(
                              //               fontFamily: 'Inter',
                              //               color: FlutterFlowTheme.of(context).secondaryText,
                              //               fontSize: 10.0,
                              //               letterSpacing: 0.0,
                              //               fontWeight: FontWeight.bold,
                              //             ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Чат',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Сотрудники
            if (currentUserDocument?.role == Role.superuser)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isAnaliticts = false;
                    });
                    if (widget.currentIndex != 4) {
                      context.navigateTo(destinations[4]);
                    }
                  },
                  child: Container(
                    width: 216.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: widget.currentIndex == 4 ? FlutterFlowTheme.of(context).primary : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/users.svg',
                              width: 24.0,
                              height: 24.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Сотрудники',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            //Профиль
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAnaliticts = false;
                  });
                  if (widget.currentIndex != 5) {
                    context.navigateTo(destinations[5]);
                  }
                },
                child: Container(
                  width: 216.0,
                  decoration: BoxDecoration(
                    color: widget.currentIndex == 5 ? FlutterFlowTheme.of(context).primary : null,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/user.svg',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Профиль',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Настройки
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAnaliticts = false;
                  });
                  if (widget.currentIndex != 6) {
                    context.navigateTo(destinations[6]);
                  }
                },
                child: Container(
                  width: 216.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: widget.currentIndex == 6 ? FlutterFlowTheme.of(context).primary : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/cog.svg',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Настройки',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
