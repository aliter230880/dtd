import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'carrier_verification_page_model.dart';
export 'carrier_verification_page_model.dart';

class CarrierVerificationPageWidget extends StatefulWidget {
  const CarrierVerificationPageWidget({super.key});

  @override
  State<CarrierVerificationPageWidget> createState() =>
      _CarrierVerificationPageWidgetState();
}

class _CarrierVerificationPageWidgetState
    extends State<CarrierVerificationPageWidget> {
  late CarrierVerificationPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarrierVerificationPageModel());

    _model.dotNumberTextController ??= TextEditingController();
    _model.dotNumberFocusNode ??= FocusNode();

    _model.mcNumberTextController ??= TextEditingController();
    _model.mcNumberFocusNode ??= FocusNode();

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'CarrierVerificationPage'});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _verifyCarrier() async {
    // Validate form
    if (_model.formKey.currentState?.validate() ?? false) {
      final dotValue = _model.dotNumberTextController?.text ?? '';
      final mcValue = _model.mcNumberTextController?.text ?? '';

      // Check if at least one field is filled
      if (dotValue.isEmpty && mcValue.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FFLocalizations.of(context).getText(
                'validation_error' /* Необходимо заполнить хотя бы одно поле */,
              ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
        return;
      }

      setState(() {
        _model.isLoading = true;
      });

      try {
        // Call Cloud Function.
        // Основной путь (28.08): verifyCarrierDot — реальная проверка в реестре
        // FMCSA QCMobile (флаг verified пишется только сервером).
        // Фолбэк: старый verifyCarrier, если новая функция ещё не задеплоена.
        Map<String, dynamic> data;
        try {
          final callable =
              FirebaseFunctions.instance.httpsCallable('verifyCarrierDot');
          final result = await callable.call({
            'dotNumber': dotValue.isNotEmpty ? dotValue : mcValue,
          });
          data = Map<String, dynamic>.from(result.data as Map);
        } on FirebaseFunctionsException catch (e) {
          if (e.code == 'not-found' || e.code == 'unimplemented') {
            // Новая функция не задеплоена — используем прежний путь.
            final legacy =
                FirebaseFunctions.instance.httpsCallable('verifyCarrier');
            await legacy.call({
              'dotNumber': dotValue.isNotEmpty ? dotValue : null,
              'mcNumber': mcValue.isNotEmpty ? mcValue : null,
              'userId': currentUserUid,
            });
            data = {'status': 'verified'};
          } else {
            rethrow;
          }
        }

        if (!mounted) return;

        setState(() {
          _model.isLoading = false;
        });

        final status = (data['status'] ?? '') as String;
        if (status != 'verified') {
          // Реестр ответил, но подтверждения нет — честно показываем причину.
          final msgKey = switch (status) {
            'not_found' => 'verification_not_found',
            'mismatch' => 'verification_mismatch',
            'unavailable' => 'verification_unavailable',
            _ => 'verification_error',
          };
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(FFLocalizations.of(context).getText(msgKey)),
              backgroundColor: status == 'unavailable'
                  ? FlutterFlowTheme.of(context).warning
                  : FlutterFlowTheme.of(context).error,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }

        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FFLocalizations.of(context).getText(
                'verification_success' /* Верификация успешна! ✓ */,
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back after short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _model.isLoading = false;
        });

        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FFLocalizations.of(context).getText(
                'verification_error' /* Ошибка верификации. Проверьте введенные данные. */,
              ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
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
              'carrier_verification_title' /* Верификация перевозчика */,
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
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description text
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        'carrier_verification_desc' /* Введите DOT или MC номер для верификации вашего статуса перевозчика. Необходимо заполнить хотя бы одно поле. */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),

                  // DOT Number field
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        'dot_number_label' /* DOT номер */,
                      ),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.dotNumberTextController,
                        focusNode: _model.dotNumberFocusNode,
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: FFLocalizations.of(context).getText(
                            'dot_number_hint' /* Например: 12345678 */,
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
                          contentPadding:
                              const EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 18.0),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                        maxLength: 8,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.number,
                        cursorColor: FlutterFlowTheme.of(context).primary,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),

                  // MC Number field
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        'mc_number_label' /* MC номер */,
                      ),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.mcNumberTextController,
                        focusNode: _model.mcNumberFocusNode,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: FFLocalizations.of(context).getText(
                            'mc_number_hint' /* Например: 1234567 */,
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
                          contentPadding:
                              const EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 18.0),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                        maxLength: 7,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.number,
                        cursorColor: FlutterFlowTheme.of(context).primary,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),

                  // Submit button
                  FFButtonWidget(
                    onPressed: _model.isLoading ? null : _verifyCarrier,
                    text: _model.isLoading
                        ? FFLocalizations.of(context).getText(
                            'verifying_text' /* Проверка... */,
                          )
                        : FFLocalizations.of(context).getText(
                            'verify_button' /* Проверить */,
                          ),
                    icon: _model.isLoading
                        ? const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : null,
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 56.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
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
                      disabledColor: FlutterFlowTheme.of(context).secondary,
                      disabledTextColor: FlutterFlowTheme.of(context).primaryText,
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
