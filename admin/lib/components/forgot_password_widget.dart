// ignore_for_file: use_build_context_synchronously

import 'package:auto_deal_admin/flutter_flow/snackbar_service.dart';


import '/auth/firebase_auth/auth_util.dart';
import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'forgot_password_model.dart';
export 'forgot_password_model.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForgotPasswordModel());

    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

   bool isEmail(String t) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(t);
  }

  void onForgot() async {
    String email = _model.emailTextController.text.trim();

    if (email.isEmpty) {
      showSnackBar(context, 'Заполните  Email');
      return;
    }

    if (!isEmail(email)) {
      showSnackBar(context, 'Email не валидный');
      return;
    }

    await authManager.resetPassword(email: email, context: context);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _model.emailTextController.text.trim().isNotEmpty;
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 680.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: const AlignmentDirectional(1.0, -1.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 45.0, 45.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.clear_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 40.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Text(
                'Забыли пароль?',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 26.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              'Введите адрес электронной почты, \nчтобы восстановить пароль',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: const Color(0xFFBDBDBD),
                    letterSpacing: 0.0,
                  ),
            ),
            Align(
              alignment: const AlignmentDirectional(-1.0, 0.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(150.0, 30.0, 0.0, 10.0),
                child: Text(
                  'Email',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(150.0, 0.0, 150.0, 25.0),
              child: Container(
                width: double.infinity,
                height: 55.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color(0xFFBDBDBD),
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.emailTextController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      onChanged: (value) {
                          setState(() {});
                      },
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Введите Email',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                        prefixIcon: const Icon(
                          Icons.mail_rounded,
                          color: Color(0xFF9E9E9E),
                          size: 18.0,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                      validator: _model.emailTextControllerValidator.asValidator(context),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(150.0, 0.0, 150.0, 60.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: isActive ? onForgot : null,
                // onTap: () async {
                //   if (_model.emailTextController.text != '') {
                //     if (_model.emailTextController.text.isEmpty) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text(
                //             'Email required!',
                //           ),
                //         ),
                //       );
                //       return;
                //     }
                //     await authManager.resetPassword(
                //       email: _model.emailTextController.text,
                //       context: context,
                //     );
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text(
                //           'Заполните email',
                //           style: TextStyle(
                //             color: FlutterFlowTheme.of(context).primaryText,
                //           ),
                //         ),
                //         duration: const Duration(milliseconds: 4000),
                //         backgroundColor: FlutterFlowTheme.of(context).secondary,
                //       ),
                //     );
                //     return;
                //   }

                //   // context.safePop();
                // },
                child: wrapWithModel(
                  model: _model.appButtonModel,
                  updateCallback: () => setState(() {}),
                  child: AppButtonWidget(
                    label: 'Отправить',
                    isActive: isActive,
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
