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
    print( _model.type);
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
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        // Второй шаг для перевозчика: путь верификации.
                        // Роль (UserType) при этом не меняется.
                        if (_model.type == UserType.Carrier)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                  child: Text(
                                    'Как вы работаете?',
                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                                _carrierKindTile(
                                  value: 'company',
                                  title: 'Компания',
                                  subtitle: 'Есть USDOT или MC — проверка по реестру FMCSA',
                                  icon: Icons.local_shipping_outlined,
                                ),
                                const SizedBox(height: 10.0),
                                _carrierKindTile(
                                  value: 'individual',
                                  title: 'Частное лицо',
                                  subtitle: 'Проверка личности и полиса, без авторитета FMCSA',
                                  icon: Icons.person_outline_rounded,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                FFButtonWidget(
                  onPressed: (_model.type == null ||
                          (_model.type == UserType.Carrier && _model.carrierKind == null))
                      ? null
                      : () async {
                          if (_model.type != null) {
                          final userRef = currentUserReference;
                          if (userRef == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Профиль пользователя ещё не готов. Повторите через несколько секунд.')),
                            );
                            return;
                          }

                          try {
                            await userRef.update(createUsersRecordData(
                              type: _model.type,
                              carrierKind:
                                  _model.type == UserType.Carrier ? _model.carrierKind : null,
                              verificationMethod: _model.type == UserType.Carrier
                                  ? (_model.carrierKind == 'individual' ? 'identity' : 'fmcsa')
                                  : null,
                            ));
                          } on FirebaseException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Не удалось сохранить роль: ${e.message ?? e.code}')),
                            );
                            return;
                          }

                          if (!context.mounted) return;
                          if (_model.type == UserType.Diller) {
                            context.pushNamed('fill_profile_diller');
                          } else {
                            context.pushNamed('fill_profile_carrier');
                          }
                        }
                        },
                  text: FFLocalizations.of(context).getText(
                    'ztj4xibk' /* Далее */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
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

  /// Плитка выбора пути верификации. Стиль повторяет карточки роли выше:
  /// жёлтая обводка и заливка primary у выбранной, серая обводка у остальных.
  Widget _carrierKindTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _model.carrierKind == value;
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        _model.carrierKind = value;
        setState(() {});
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: selected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: selected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).buttonDisabel,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      subtitle,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected
                    ? FlutterFlowTheme.of(context).primaryText
                    : FlutterFlowTheme.of(context).hintColor,
                size: 22.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
