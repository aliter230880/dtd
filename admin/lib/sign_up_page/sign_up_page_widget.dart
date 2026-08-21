// ignore_for_file: use_build_context_synchronously

import 'package:auto_deal_admin/flutter_flow/snackbar_service.dart';
import 'package:auto_route/auto_route.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/app_button_widget.dart';
import '/components/registration_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'sign_up_page_model.dart';
export 'sign_up_page_model.dart';

@RoutePage()
class SignUpPageWidget extends StatefulWidget {
  const SignUpPageWidget({super.key});

  @override
  State<SignUpPageWidget> createState() => _SignUpPageWidgetState();
}

class _SignUpPageWidgetState extends State<SignUpPageWidget> {
  late SignUpPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpPageModel());

    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.confirmPasswordTextController ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  bool isEmail(String t) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(t);
  }

  bool isPasswordValid(String p1, String p2) {
    return p1.length > 5 && p2.length > 5;
  }

  void onSignUp() async {
    String email = _model.emailTextController.text.trim();
    String password = _model.passwordTextController.text.trim();
    String confirm = _model.confirmPasswordTextController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      showSnackBar(context, 'Заполните  поля');
      return;
    }

    if (password != confirm) {
      showSnackBar(context, 'Пароли не совпадают');
      return;
    }

    if (!isEmail(email)) {
      showSnackBar(context, 'Email не валидный');
      return;
    }

    if (!isPasswordValid(password, confirm)) {
      showSnackBar(context, 'Пароль не валидный');
      return;
    }

    final user = await authManager.createAccountWithEmail(context, email, password);
    if (user == null) {
      return;
    }

    await AdminsRecord.collection.doc(user.uid).update(createAdminsRecordData(
          email: email,
          createdTime: getCurrentTimestamp,
          photoUrl: null,
          displayName: 'undefined',
          status: AdminStatus.wait,
          isBlocked: false,
        ));

    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
            child: const RegistrationWidget(),
          );
        },
      );
    }
  }

  void onTapPrivacy() async {
    await launchURL('https://sites.google.com/view/dtdapp/privacy-policy');
  }

  void onTapAgr() async {
    await launchURL('https://sites.google.com/view/dtdapp/terms-and-conditions');
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _model.emailTextController.text.trim().isNotEmpty &&
        _model.passwordTextController.text.trim().isNotEmpty &&
        _model.confirmPasswordTextController.text.trim().isNotEmpty;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Positioned(
              bottom: -50.0,
              left: 75,
              child: Image.asset(
                'assets/images/image_2.png',
                width: 715.0,
                height: 715.0,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-1.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(55.0, 0.0, 0.0, 0.0),
                    child: Image.asset(
                      'assets/images/image_1.png',
                      width: 624.0,
                      height: 624.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-1.0, 1.0),
              child: Container(
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 30.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 20.0, 0.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          child: Image.asset(
                            'assets/images/cbi_alexa-logo.png',
                            width: 73.0,
                            height: 73.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        'DTD',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 420.0,
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Регистрация',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        fontSize: 46.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 10.0),
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
                                Container(
                                  width: double.infinity,
                                  height: 56.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: const Color(0xFFBDBDBD),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model.emailTextController,
                                              focusNode: _model.textFieldFocusNode1,
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
                                                contentPadding:
                                                    const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
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
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                                    child: Text(
                                      'Пароль',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 56.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: const Color(0xFFBDBDBD),
                                      width: 1.0,
                                    ),
                                  ),
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model.passwordTextController,
                                              focusNode: _model.textFieldFocusNode2,
                                              autofocus: false,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              textCapitalization: TextCapitalization.none,
                                              textInputAction: TextInputAction.next,
                                              obscureText: !_model.passwordVisibility1,
                                              decoration: InputDecoration(
                                                hintText: 'Введите пароль',
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
                                                contentPadding:
                                                    const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Color(0xFF9E9E9E),
                                                  size: 18.0,
                                                ),
                                                suffixIcon: InkWell(
                                                  onTap: () => setState(
                                                    () => _model.passwordVisibility1 = !_model.passwordVisibility1,
                                                  ),
                                                  focusNode: FocusNode(skipTraversal: true),
                                                  child: Icon(
                                                    _model.passwordVisibility1
                                                        ? Icons.visibility_outlined
                                                        : Icons.visibility_off_outlined,
                                                    color: FlutterFlowTheme.of(context).hintText,
                                                    size: 15.0,
                                                  ),
                                                ),
                                              ),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              validator: _model.passwordTextControllerValidator.asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                                    child: Text(
                                      'Повторите пароль',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 56.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: const Color(0xFFBDBDBD),
                                      width: 1.0,
                                    ),
                                  ),
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model.confirmPasswordTextController,
                                              focusNode: _model.textFieldFocusNode3,
                                              autofocus: false,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              textCapitalization: TextCapitalization.none,
                                              textInputAction: TextInputAction.next,
                                              obscureText: !_model.passwordVisibility2,
                                              decoration: InputDecoration(
                                                hintText: 'Повторите пароль',
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
                                                contentPadding:
                                                    const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Color(0xFF9E9E9E),
                                                  size: 18.0,
                                                ),
                                                suffixIcon: InkWell(
                                                  onTap: () => setState(
                                                    () => _model.passwordVisibility2 = !_model.passwordVisibility2,
                                                  ),
                                                  focusNode: FocusNode(skipTraversal: true),
                                                  child: Icon(
                                                    _model.passwordVisibility2
                                                        ? Icons.visibility_outlined
                                                        : Icons.visibility_off_outlined,
                                                    color: FlutterFlowTheme.of(context).hintText,
                                                    size: 15.0,
                                                  ),
                                                ),
                                              ),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              validator:
                                                  _model.confirmPasswordTextControllerValidator.asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Builder(
                                  builder: (context) => Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 22.0, 0.0, 0.0),
                                    child: AppButtonWidget(
                                      label: 'Зарегистрироваться',
                                      isActive: isActive,
                                      onPressed: isActive ? onSignUp : null,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                                    child: RichText(
                                      textScaler: MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Есть аккаунт? ',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                          TextSpan(
                                            text: 'Войти',
                                            style: TextStyle(
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              decoration: TextDecoration.underline,
                                            ),
                                            mouseCursor: SystemMouseCursors.click,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                AutoRouter.of(context).back();
                                              },
                                          )
                                        ],
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
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
                      Align(
                        alignment: const AlignmentDirectional(0.0, 1.0),
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: const BoxDecoration(),
                          child: Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Продолжая, Вы соглашаетесь с ',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: const Color(0xFFBDBDBD),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                  TextSpan(
                                    text: 'Условиями использования ',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 14.0,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = onTapAgr,
                                  ),
                                  const TextSpan(
                                    text: 'и ',
                                    style: TextStyle(
                                      color: Color(0xFFBDBDBD),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Политикой конфиденциальности.',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 14.0,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = onTapPrivacy,
                                  )
                                ],
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
