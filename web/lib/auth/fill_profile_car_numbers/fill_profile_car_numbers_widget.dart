import 'package:flutter/cupertino.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/success_signup_custom_alert_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'fill_profile_car_numbers_model.dart';
export 'fill_profile_car_numbers_model.dart';

class FillProfileCarNumbersWidget extends StatefulWidget {
  const FillProfileCarNumbersWidget({super.key});

  @override
  State<FillProfileCarNumbersWidget> createState() => _FillProfileCarNumbersWidgetState();
}

class _FillProfileCarNumbersWidgetState extends State<FillProfileCarNumbersWidget> {
  late FillProfileCarNumbersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FillProfileCarNumbersModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'fill_profile_car_numbers'});

    _model.carNumberTextController ??= TextEditingController();
    _model.carNumberFocusNode ??= FocusNode();
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
            'x0z61hue' /* Добавьте номер */,
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
              maxWidth: 380,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText('x0z61hue'),
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
                  const SizedBox(height: 20),
                  Text(
                    FFLocalizations.of(context).getText(
                      'oane6xmt' /* Добавьте номер автомолибя */,
                    ),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: const Color(0xFF424245),
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '77grakml' /* Номер авто */,
                            ),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: const Color(0xFF424245),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.carNumberTextController,
                                  focusNode: _model.carNumberFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.carNumberTextController',
                                    const Duration(milliseconds: 200),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.done,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: FFLocalizations.of(context).getText(
                                      '4d7wim9b' /* Например, 4567AA */,
                                    ),
                                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).hintColor,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                    errorStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).error,
                                          fontSize: 10.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).border,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  textAlign: TextAlign.start,
                                  minLines: 1,
                                  maxLength: 50,
                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                      null,
                                  cursorColor: FlutterFlowTheme.of(context).primary,
                                  validator: _model.carNumberTextControllerValidator.asValidator(context),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if(_model.carNumberTextController.text.trim().isEmpty) return;
                                  await currentUserReference!.update({
                                    ...mapToFirestore(
                                      {
                                        'diller_cars': FieldValue.arrayUnion([_model.carNumberTextController.text]),
                                      },
                                    ),
                                  });
                                  setState(() {
                                    _model.carNumberTextController?.clear();
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: Container(
                                  width: 53.0,
                                  height: 53.0,
                                  decoration: BoxDecoration(
                                    color: valueOrDefault<Color>(
                                      _model.carNumberTextController.text != ''
                                          ? const Color(0xFFF2AB58)
                                          : const Color(0x7FF2AB58),
                                      const Color(0xFFF2AB58),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 40.0,
                                        color: Color(0x1A0C0C0D),
                                        offset: Offset(0.0, 16.0),
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add_circle_rounded,
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    size: 28.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (((currentUserDocument?.dillerCars.toList() ?? []).isNotEmpty))
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '90nliwbe' /* Ваши номера */,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: const Color(0xFF424245),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                                  child: AuthUserStreamWidget(
                                    builder: (context) => Builder(
                                      builder: (context) {
                                        final userCars =
                                            (currentUserDocument?.dillerCars.toList() ?? []).map((e) => e).toList();
                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: userCars.length,
                                          itemBuilder: (context, userCarsIndex) {
                                            final userCarsItem = userCars[userCarsIndex];
                                            return
                                                // Изменить бордер на нижний
                                                Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 48.0,
                                                decoration: const BoxDecoration(
                                                    border: Border(bottom: BorderSide(color: Color(0xFFE9E9E9)))),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                                                      child: Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFE0E0E0),
                                                          borderRadius: BorderRadius.circular(12.0),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          child: SvgPicture.asset(
                                                            'assets/images/license.svg',
                                                            width: 300.0,
                                                            height: 200.0,
                                                            fit: BoxFit.none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                            0.0, 6.0, 0.0, 0.0),
                                                        child: Text(
                                                          userCarsItem,
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16.0,
                                                                letterSpacing: 0.0,
                                                                useGoogleFonts: false,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                      child: InkWell(
                                                        splashColor: Colors.transparent,
                                                        focusColor: Colors.transparent,
                                                        hoverColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        onTap: () async {
                                                          await currentUserReference!.update({
                                                            ...mapToFirestore(
                                                              {
                                                                'diller_cars':
                                                                    FieldValue.arrayRemove([userCarsItem]),
                                                              },
                                                            ),
                                                          });
                                                          setState(() {});
                                                        },
                                                        child: Icon(
                                                          Icons.clear_rounded,
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Builder(
                    builder: (context) => AuthUserStreamWidget(
                      builder: (context) => FFButtonWidget(
                        onPressed: ((currentUserDocument?.dillerCars.toList() ?? []).isEmpty)
                            ? null
                            : () async {
                                if ((currentUserDocument?.dillerCars.toList() ?? []).isEmpty) {
                                  return;
                                }

                                await currentUserReference!.update(createUsersRecordData(
                                  profileFilled: true,
                                  balance: 0.0,
                                  rate: 0.0,
                                ));
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment:
                                          const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                      child: const SuccessSignupCustomAlertWidget(
                                        isDiller: true,
                                      ),
                                    );
                                  },
                                ).then((value) => setState(() {}));

                                context.goNamed('HomePage');
                              },
                        text: FFLocalizations.of(context).getText(
                          'm1whe20l' /* Завершить регистрацию */,
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
                          hoverColor:  FlutterFlowTheme.of(context).warning,
                          disabledTextColor: FlutterFlowTheme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
