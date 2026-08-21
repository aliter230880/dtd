import 'dart:developer';

import 'package:auto_deal_admin/backend/backend.dart';
import 'package:auto_deal_admin/backend/schema/enums/enums.dart';
import 'package:auto_route/auto_route.dart';


import '../flutter_flow/app_router.gr.dart';
import '../flutter_flow/snackbar_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/components/app_button_widget.dart';
import '/components/forgot_password_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';

@RoutePage()
class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  
  void onTapPrivacy() async {
    await launchURL('https://sites.google.com/view/dtdapp/privacy-policy');
  }

  void onTapAgr() async {
    await launchURL('https://sites.google.com/view/dtdapp/terms-and-conditions');
  }


  bool isEmail(String t) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(t);
  }

  bool isPasswordValid(String p1) {
    return p1.length > 5;
  }

  void onLogin() async {
    final router = AutoRouter.of(context);
    // GoRouter.of(context).prepareAuthEvent();
    String email = _model.emailTextController.text.trim();
    String password = _model.passwordTextController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'Заполните  поля');
      return;
    }

    if (!isEmail(email)) {
      showSnackBar(context, 'Email не валидный');
      return;
    }

    if (!isPasswordValid(password)) {
      showSnackBar(context, 'Пароль не валидный');
      return;
    }

    final user = await authManager.signInWithEmail(context, email, password);
    if (user == null) {
      return;
    }

    final admin = await getAdmin(user.uid);

    if (admin == null) {
      log('GO TO LOGIN: Admin is null');
      if (mounted) showSnackBar(context, 'Произошла ошибка');
      return;
    }

    if (admin.status != AdminStatus.accept) {
      log('GO TO Wait: no accepted');
      router.replace(const RegistrationStatusPageWidgetRoute());
      return;
    }

    log('GO TO Home: ');
    router.replace(const HomeNavigatorWidgetRoute());
  }

  Future<AdminsRecord?> getAdmin(String? uid) async {
    if (uid == null) return null;
    final user = await AdminsRecord.getDocumentOnce(AdminsRecord.collection.doc(uid));
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final isActive =
        _model.emailTextController.text.trim().isNotEmpty && _model.passwordTextController.text.trim().isNotEmpty;
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
                      width: 620.0,
                      height: 620.0,
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
                                  'Войти',
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
                                              obscureText: !_model.passwordVisibility,
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
                                                    () => _model.passwordVisibility = !_model.passwordVisibility,
                                                  ),
                                                  focusNode: FocusNode(skipTraversal: true),
                                                  child: Icon(
                                                    _model.passwordVisibility
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
                                  alignment: const AlignmentDirectional(1.0, 0.0),
                                  child: Builder(
                                    builder: (context) => Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 22.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (dialogContext) {
                                              return Dialog(
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                backgroundColor: Colors.transparent,
                                                alignment: const AlignmentDirectional(0.0, 0.0)
                                                    .resolve(Directionality.of(context)),
                                                child: const ForgotPasswordWidget(),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Забыли пароль?',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                decoration: TextDecoration.underline,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.appButtonModel,
                                  updateCallback: () => setState(() {}),
                                  child: AppButtonWidget(
                                    label: 'Войти',
                                    isActive: isActive,
                                    onPressed: isActive ? onLogin : null,
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
                                            text: 'Нет аккаунта? ',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                          TextSpan(
                                            text: 'Создать аккаунт',
                                            style: TextStyle(
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              decoration: TextDecoration.underline,
                                            ),
                                            mouseCursor: SystemMouseCursors.click,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final router = AutoRouter.of(context);
                                                router.push(const SignUpPageWidgetRoute());
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
