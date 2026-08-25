import 'package:flutter/cupertino.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/success_signup_custom_alert_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'fill_profile_carrier_model.dart';
export 'fill_profile_carrier_model.dart';

class FillProfileCarrierWidget extends StatefulWidget {
  const FillProfileCarrierWidget({super.key});

  @override
  State<FillProfileCarrierWidget> createState() => _FillProfileCarrierWidgetState();
}

class _FillProfileCarrierWidgetState extends State<FillProfileCarrierWidget> {
  late FillProfileCarrierModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FillProfileCarrierModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'fill_profile_carrier'});
    _model.companyNameTextController ??= TextEditingController();
    _model.companyNameFocusNode ??= FocusNode();

    _model.carrierNumberTextController ??= TextEditingController();
    _model.carrierNumberFocusNode ??= FocusNode();

    _model.driverNumberTextController ??= TextEditingController();
    _model.driverNumberFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
              'bigi7ln2' /* Введите данные */,
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
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'kephjo9u' /* Для идентификации необходимо з... */,
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: const Color(0xFF424245),
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
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
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.companyNameTextController,
                                    focusNode: _model.companyNameFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.companyNameTextController',
                                      const Duration(milliseconds: 200),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    autofillHints: const [AutofillHints.organizationName],
                                    textCapitalization: TextCapitalization.sentences,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        'ha47uvje' /* Название компании */,
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
                                      suffixIcon: _model.companyNameTextController!.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                _model.companyNameTextController?.clear();
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
                                    maxLength: 255,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.name,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.companyNameTextControllerValidator.asValidator(context),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.carrierNumberTextController,
                                    focusNode: _model.carrierNumberFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.carrierNumberTextController',
                                      const Duration(milliseconds: 200),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    textCapitalization: TextCapitalization.none,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        '3xf4ad0w' /* Номер перевозчика */,
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
                                      suffixIcon: _model.carrierNumberTextController!.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                _model.carrierNumberTextController?.clear();
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
                                    maxLength: 50,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.number,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.carrierNumberTextControllerValidator.asValidator(context),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.driverNumberTextController,
                                    focusNode: _model.driverNumberFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.driverNumberTextController',
                                      const Duration(milliseconds: 200),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    textCapitalization: TextCapitalization.none,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        'oh1l6hxg' /* Номер водительских прав */,
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
                                      suffixIcon: _model.driverNumberTextController!.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                _model.driverNumberTextController?.clear();
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
                                    maxLength: 50,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.number,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.driverNumberTextControllerValidator.asValidator(context),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                    child: Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          if (valueOrDefault<bool>(
                                            _model.driverLicenceFile != null &&
                                                (_model.driverLicenceFile?.bytes?.isNotEmpty ?? false),
                                            false,
                                          )) {
                                            return SvgPicture.asset(
                                              'assets/images/attach.svg',
                                              width: 18.0,
                                              height: 18.0,
                                              fit: BoxFit.none,
                                            );
                                          } else {
                                            return SvgPicture.asset(
                                              'assets/images/upload.svg',
                                              width: 18.0,
                                              height: 18.0,
                                              fit: BoxFit.none,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'irgp8ktm' /* Водительские права */,
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                        if (valueOrDefault<bool>(
                                          _model.driverLicenceFile != null &&
                                              (_model.driverLicenceFile?.bytes?.isNotEmpty ?? false),
                                          false,
                                        ))
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context).getText(
                                                  '0wge1f35' /* Файл загружен */,
                                                ),
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      color: const Color(0xFFA9A9AA),
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: false,
                                                    ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.driverLicenceFile != null &&
                                          (_model.driverLicenceFile?.bytes?.isNotEmpty ?? false)) {
                                        setState(() {
                                          _model.isDataUploading = false;
                                          _model.uploadedLocalFile = FFUploadedFile(bytes: Uint8List.fromList([]));
                                          _model.uploadedFileUrl = '';
                                        });
                                        _model.driverLicenceFile = null;
                                        setState(() {});
                                        return;
                                      } else {
                                        final selectedFiles = await selectFiles(
                                          multiFile: false,
                                        );
                                        if (selectedFiles != null) {
                                          setState(() => _model.isDataUploading = true);
                                          var selectedUploadedFiles = <FFUploadedFile>[];
                                          var downloadUrls = <String>[];
                                          try {
                                            selectedUploadedFiles = selectedFiles
                                                .map((m) => FFUploadedFile(
                                                      name: m.storagePath.split('/').last,
                                                      bytes: m.bytes,
                                                    ))
                                                .toList();
                                            downloadUrls = (await Future.wait(
                                              selectedFiles.map(
                                                (f) async => await uploadData(f.storagePath, f.bytes),
                                              ),
                                            ))
                                                .where((u) => u != null)
                                                .map((u) => u!)
                                                .toList();
                                          } finally {
                                            _model.isDataUploading = false;
                                          }
                                          if (selectedUploadedFiles.length == selectedFiles.length &&
                                              downloadUrls.length == selectedFiles.length) {
                                            setState(() {
                                              _model.uploadedLocalFile = selectedUploadedFiles.first;
                                              _model.uploadedFileUrl = downloadUrls.first;
                                            });
                                          } else {
                                            setState(() {});
                                            return;
                                          }
                                        }
                                        _model.driverLicenceFile = _model.uploadedLocalFile;
                                        setState(() {});
                                        return;
                                      }
                                    },
                                    text: _model.driverLicenceFile != null &&
                                            (_model.driverLicenceFile?.bytes?.isNotEmpty ?? false)
                                        ? 'Удалить'
                                        : 'Загрузить',
                                    options: FFButtonOptions(
                                      width: 122.0,
                                      height: 36.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: valueOrDefault<Color>(
                                        _model.driverLicenceFile != null &&
                                                (_model.driverLicenceFile?.bytes?.isNotEmpty ?? false)
                                            ? FlutterFlowTheme.of(context).primaryText
                                            : FlutterFlowTheme.of(context).primary,
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'Inter',
                                            color: valueOrDefault<Color>(
                                              _model.driverLicenceFile != null &&
                                                      (_model.driverLicenceFile?.bytes?.isNotEmpty ?? false)
                                                  ? FlutterFlowTheme.of(context).secondaryBackground
                                                  : FlutterFlowTheme.of(context).primaryText,
                                              FlutterFlowTheme.of(context).primaryText,
                                            ),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                      elevation: 0.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0.0,
                                      ),
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => FFButtonWidget(
                    onPressed: (valueOrDefault<bool>(
                              _model.companyNameTextController.text == '',
                              false,
                            ) ||
                            valueOrDefault<bool>(
                              _model.carrierNumberTextController.text == '',
                              false,
                            ) ||
                            valueOrDefault<bool>(
                              _model.driverNumberTextController.text == '',
                              false,
                            ) ||
                            (_model.isDataUploading == true))
                        ? null
                        : () async {
                            if (_model.formKey.currentState == null || !_model.formKey.currentState!.validate()) {
                              return;
                            }
                            if (_model.isDataUploading == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Дождитесь загрузки файла',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 4000),
                                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                              return;
                            } else {
                              await currentUserReference!.update(createUsersRecordData(
                                profileFilled: true,
                                balance: 0.0,
                                rate: 0.0,
                                carrierCompanyName: _model.companyNameTextController.text,
                                carrierNumber: _model.carrierNumberTextController.text,
                                carrierDriverLicense: _model.driverNumberTextController.text,
                                freeResponseCount: 5,
                                file: _model.uploadedFileUrl,
                              ));
                            }

                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                  child: const SuccessSignupCustomAlertWidget(
                                    isDiller: false,
                                  ),
                                );
                              },
                            );

                            context.goNamed('HomePage');
                          },
                    text: FFLocalizations.of(context).getText(
                      '4033ooas' /* Завершить регистрацию */,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
