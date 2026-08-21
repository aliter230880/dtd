import 'package:flutter/cupertino.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/skip_registration_alert_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'fill_profile_main_model.dart';
export 'fill_profile_main_model.dart';

class FillProfileMainWidget extends StatefulWidget {
  const FillProfileMainWidget({super.key});

  @override
  State<FillProfileMainWidget> createState() => _FillProfileMainWidgetState();
}

class _FillProfileMainWidgetState extends State<FillProfileMainWidget> {
  late FillProfileMainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FillProfileMainModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'fill_profile_main'});

    _model.emailAddressTextController ??= TextEditingController(text: currentUserDisplayName);
    _model.emailAddressFocusNode ??= FocusNode();

    _model.phoneTextController ??= TextEditingController(text: currentPhoneNumber);
    _model.phoneFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void onTapAvatar() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
        context: context, imageQuality: 50, allowPhoto: true, includeDimensions: true, pickerFontFamily: 'Inter');
    if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
      setState(() => _model.isDataUploading = true);
      var selectedUploadedFiles = <FFUploadedFile>[];

      var downloadUrls = <String>[];
      try {
        selectedUploadedFiles = selectedMedia
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                ))
            .toList();

        downloadUrls = (await Future.wait(
          selectedMedia.map(
            (m) async => await uploadData(m.storagePath, m.bytes),
          ),
        ))
            .where((u) => u != null)
            .map((u) => u!)
            .toList();
      } finally {
        _model.isDataUploading = false;
      }
      if (selectedUploadedFiles.length == selectedMedia.length && downloadUrls.length == selectedMedia.length) {
        setState(() {
          _model.uploadedLocalFile = selectedUploadedFiles.first;
          _model.uploadedFileUrl = downloadUrls.first;
        });
      } else {
        setState(() {});
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: (context.canPop())
            ? FlutterFlowIconButton(
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
                  if (context.canPop()) {
                    context.pop();
                  }
                },
              )
            : null,
        title: Text(
          FFLocalizations.of(context).getText(
            'f154sbeo' /* Заполните профиль */,
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText('f154sbeo'),
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
                const SizedBox(height: 40),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Builder(
                      builder: (context) {
                        if (_model.uploadedFileUrl == '') {
                          return GestureDetector(
                            onTap: onTapAvatar,
                            child: Container(
                              width: 85.0,
                              height: 85.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).buttonDisabel,
                                shape: BoxShape.circle,
                              ),
                              child: Builder(
                                builder: (context) {
                                  if (_model.isDataUploading == true) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/person.svg',
                                        width: 300.0,
                                        height: 200.0,
                                        fit: BoxFit.none,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: onTapAvatar,
                            child: Container(
                              width: 85.0,
                              height: 85.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Builder(builder: (context) {
                                if (_model.isDataUploading == true) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Image.memory(
                                    _model.uploadedLocalFile.bytes ?? Uint8List.fromList([]),
                                    fit: BoxFit.cover,
                                  );
                                }
                              }),
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onTapAvatar,
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '1izef6bt' /* Добавить фото */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).hintColor,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                              child: AuthUserStreamWidget(
                                builder: (context) => SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.emailAddressTextController,
                                    focusNode: _model.emailAddressFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.emailAddressTextController',
                                      const Duration(milliseconds: 200),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    autofillHints: const [AutofillHints.email],
                                    textCapitalization: TextCapitalization.none,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        'qi6vhve8' /* Ваше имя */,
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
                                      suffixIcon: _model.emailAddressTextController!.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                _model.emailAddressTextController?.clear();
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: FlutterFlowTheme.of(context).border,
                                                size: 20.0,
                                              ),
                                            )
                                          : null,
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                    textAlign: TextAlign.start,
                                    minLines: 1,
                                    maxLength: 60,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.emailAddressTextControllerValidator.asValidator(context),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'kktyb8cp' /* Контактный номер телефона */,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).hintColor,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                            AuthUserStreamWidget(
                              builder: (context) => SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.phoneTextController,
                                  focusNode: _model.phoneFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.phoneTextController',
                                    const Duration(milliseconds: 200),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  autofillHints: const [AutofillHints.telephoneNumber],
                                  textCapitalization: TextCapitalization.none,
                                  textInputAction: TextInputAction.done,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: FFLocalizations.of(context).getText(
                                      '01b2flz5' /* +7 */,
                                    ),
                                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).hintColor,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                    errorStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
                                    suffixIcon: _model.phoneTextController!.text.isNotEmpty
                                        ? InkWell(
                                            onTap: () async {
                                              _model.phoneTextController?.clear();
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              color: FlutterFlowTheme.of(context).border,
                                              size: 20.0,
                                            ),
                                          )
                                        : null,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  textAlign: TextAlign.start,
                                  minLines: 1,
                                  maxLength: 60,
                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                      null,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: FlutterFlowTheme.of(context).primary,
                                  validator: _model.phoneTextControllerValidator.asValidator(context),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    FFButtonWidget(
                      onPressed:
                          ((_model.emailAddressTextController.text == '') || (_model.phoneTextController.text == ''))
                              ? null
                              : () async {
                                  if (_model.formKey.currentState == null || !_model.formKey.currentState!.validate()) {
                                    return;
                                  }

                                  await currentUserReference!.update(createUsersRecordData(
                                    displayName: _model.emailAddressTextController.text,
                                    phoneNumber: _model.phoneTextController.text,
                                    photoUrl: _model.uploadedFileUrl != ''
                                        ? _model.uploadedFileUrl
                                        : 'https://firebasestorage.googleapis.com/v0/b/dealertodealer-84957.appspot.com/o/config%2Favatar.png?alt=media&token=83b57cc6-2b25-4c79-a195-04c51c6785a4',
                                  ));

                                  context.pushNamed('fill_profile_type');
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
                        hoverColor: FlutterFlowTheme.of(context).warning,
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
                                      alignment:
                                          const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
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
                              'fzqfnyss' /* Пропустить */,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
