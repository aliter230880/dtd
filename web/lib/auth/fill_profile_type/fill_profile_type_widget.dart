import 'package:flutter/cupertino.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/profile_type_comp_widget.dart';
import '/components/skip_registration_alert_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'fill_profile_type_model.dart';
export 'fill_profile_type_model.dart';

class FillProfileTypeWidget extends StatefulWidget {
  const FillProfileTypeWidget({super.key});

  @override
  State<FillProfileTypeWidget> createState() => _FillProfileTypeWidgetState();
}

class _FillProfileTypeWidgetState extends State<FillProfileTypeWidget> {
  late FillProfileTypeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FillProfileTypeModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'fill_profile_type'});
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
            'chqzzntl' /* Заполните профиль */,
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
        child: Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 640,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText('chqzzntl'),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.type = UserType.Diller;
                            setState(() {});
                          },
                          child: wrapWithModel(
                            model: _model.profileTypeCompModel1,
                            updateCallback: () => setState(() {}),
                            child: ProfileTypeCompWidget(
                              selected: _model.type == UserType.Diller,
                              type: 'diller',
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.type = UserType.Carrier;
                          setState(() {});
                        },
                        child: wrapWithModel(
                          model: _model.profileTypeCompModel2,
                          updateCallback: () => setState(() {}),
                          child: ProfileTypeCompWidget(
                            selected: _model.type == UserType.Carrier,
                            type: 'carrier',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FFButtonWidget(
                  onPressed: (_model.type == null)
                      ? null
                      : () async {
                          if (_model.type != null) {
                            await currentUserReference!.update(createUsersRecordData(
                              type: _model.type,
                            ));
                            if (_model.type == UserType.Diller) {
                              context.pushNamed('fill_profile_diller');

                              return;
                            } else {
                              context.pushNamed('fill_profile_carrier');

                              return;
                            }
                          } else {
                            return;
                          }
                        },
                  text: FFLocalizations.of(context).getText(
                    'ztj4xibk' /* Далее */,
                  ),
                  options: FFButtonOptions(
                    width: 380,
                    height: 56.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                    elevation: 0.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    hoverColor: FlutterFlowTheme.of(context).warning,
                    disabledColor: FlutterFlowTheme.of(context).buttonDisabel,
                    disabledTextColor: FlutterFlowTheme.of(context).hintColor,
                  ),
                ),
                Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        bool confirm = await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                  child: const SkipRegistrationAlertWidget(),
                                );
                              },
                            ) ??
                            false;

                        if (!confirm) return;

                        GoRouter.of(context).prepareAuthEvent();
                        await authManager.signOut();
                        GoRouter.of(context).clearRedirectLocation();
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        }
                        context.pushNamedAuth('HomePage', context.mounted);
                      },
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'z5e6j9hx' /* Пропустить */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintColor,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
