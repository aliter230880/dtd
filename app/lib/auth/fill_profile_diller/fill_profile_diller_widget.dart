// ignore_for_file: deprecated_member_use

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'fill_profile_diller_model.dart';
export 'fill_profile_diller_model.dart';

class FillProfileDillerWidget extends StatefulWidget {
  const FillProfileDillerWidget({super.key});

  @override
  State<FillProfileDillerWidget> createState() => _FillProfileDillerWidgetState();
}

class _FillProfileDillerWidgetState extends State<FillProfileDillerWidget> {
  late FillProfileDillerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FillProfileDillerModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'fill_profile_diller'});
    _model.dillerNumberTextController ??= TextEditingController();
    _model.dillerNumberFocusNode ??= FocusNode();

    _model.driverNumberTextController ??= TextEditingController();
    _model.driverNumberFocusNode ??= FocusNode();

    _model.takeDateTextController ??= TextEditingController();
    _model.takeDateFocusNode ??= FocusNode();
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
              'xm4e6d83' /* Введите данные */,
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
                        '2433wuac' /* Для идентификации необходимо з... */,
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
                                    controller: _model.dillerNumberTextController,
                                    focusNode: _model.dillerNumberFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.dillerNumberTextController',
                                      const Duration(milliseconds: 200),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    textCapitalization: TextCapitalization.none,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        'ckjpp31m' /* Номер дилерской лицензии */,
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
                                      suffixIcon: _model.dillerNumberTextController!.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                _model.dillerNumberTextController?.clear();
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
                                    validator: _model.dillerNumberTextControllerValidator.asValidator(context),
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
                                        '2omgqltf' /* Номер прав */,
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
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    '58k4nuc8' /* Дата выдачи */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).hintColor,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.takeDateTextController,
                                    focusNode: _model.takeDateFocusNode,
                                    // onChanged: (_) => EasyDebounce.debounce(
                                    //   '_model.takeDateTextController',
                                    //   const Duration(milliseconds: 0),
                                    //   () => setState(() {}),
                                    // ),
                                    onTap: () async {
                                      await showModalBottomSheet<bool>(
                                          context: context,
                                          builder: (context) {
                                            final datePickedCupertinoTheme = CupertinoTheme.of(context);
                                            return Container(
                                              height: MediaQuery.of(context).size.height / 3,
                                              width: MediaQuery.of(context).size.width,
                                              color: const Color(0xFFF4F4F4),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 24, bottom: 0, top: 20),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text(
                                                            'Выбрать',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'Inter',
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 16,
                                                                  color: Colors.blue,
                                                                  useGoogleFonts: false,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: CupertinoTheme(
                                                      data: datePickedCupertinoTheme.copyWith(
                                                        textTheme: datePickedCupertinoTheme.textTheme.copyWith(
                                                          dateTimePickerTextStyle:
                                                              FlutterFlowTheme.of(context).headlineMedium.override(
                                                                    fontFamily: 'Inter',
                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                    fontSize: 23.0,
                                                                    letterSpacing: 0.0,
                                                                    useGoogleFonts: false,
                                                                  ),
                                                        ),
                                                      ),
                                                      child: CupertinoDatePicker(
                                                        mode: CupertinoDatePickerMode.date,
                                                        minimumDate: DateTime(1900),
                                                        initialDateTime: getCurrentTimestamp,
                                                        maximumDate: (getCurrentTimestamp),
                                                        backgroundColor: const Color(0xFFF4F4F4),
                                                        use24hFormat: false,
                                                        onDateTimeChanged: (newDateTime) => safeSetState(() {
                                                          _model.datePicked = newDateTime;
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                      setState(() {
                                        _model.takeDateTextController?.text = dateTimeFormat(
                                          'd/M/y',
                                          _model.datePicked,
                                          locale: FFLocalizations.of(context).languageCode,
                                        );
                                      });
                                    },
                                    autofocus: false,
                                    textCapitalization: TextCapitalization.none,
                                    textInputAction: TextInputAction.next,
                                    readOnly: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        'e32actky' /* ДД/ММ/ГГ */,
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
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                          'assets/images/calendar.svg',
                                          color: const Color(0xFF6B7077),
                                        ),
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
                                    keyboardType: TextInputType.datetime,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.takeDateTextControllerValidator.asValidator(context),
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
                                            _model.dillerLicenseFile != null &&
                                                (_model.dillerLicenseFile?.bytes?.isNotEmpty ?? false),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText('365ocsfw2'),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                        if (valueOrDefault<bool>(
                                          _model.dillerLicenseFile != null &&
                                              (_model.dillerLicenseFile?.bytes?.isNotEmpty ?? false),
                                          false,
                                        ))
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context).getText(
                                                  'wc7z7gma' /* Файл загружен */,
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
                                      if (_model.dillerLicenseFile != null &&
                                          (_model.dillerLicenseFile?.bytes?.isNotEmpty ?? false)) {
                                        setState(() {
                                          _model.isDataUploading = false;
                                          _model.uploadedLocalFile = FFUploadedFile(bytes: Uint8List.fromList([]));
                                          _model.uploadedFileUrl = '';
                                        });
                                        _model.dillerLicenseFile = null;
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
                                        _model.dillerLicenseFile = _model.uploadedLocalFile;
                                        setState(() {});
                                        return;
                                      }
                                    },
                                    text: valueOrDefault<bool>(
                                      _model.dillerLicenseFile != null &&
                                          (_model.dillerLicenseFile?.bytes?.isNotEmpty ?? false),
                                      false,
                                    )
                                        ? 'Удалить'
                                        : 'Загрузить',
                                    options: FFButtonOptions(
                                      width: 122.0,
                                      height: 36.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: valueOrDefault<Color>(
                                        valueOrDefault<bool>(
                                          _model.dillerLicenseFile != null &&
                                              (_model.dillerLicenseFile?.bytes?.isNotEmpty ?? false),
                                          false,
                                        )
                                            ? FlutterFlowTheme.of(context).primaryText
                                            : FlutterFlowTheme.of(context).primary,
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'Inter',
                                            color: valueOrDefault<Color>(
                                              valueOrDefault<bool>(
                                                _model.dillerLicenseFile != null &&
                                                    (_model.dillerLicenseFile?.bytes?.isNotEmpty ?? false),
                                                false,
                                              )
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
                FFButtonWidget(
                  onPressed: ((_model.dillerNumberTextController.text == '') ||
                          (_model.driverNumberTextController.text == '') ||
                          (_model.takeDateTextController.text == '') ||
                          (_model.isDataUploading == true))
                      ? null
                      : () async {
                          if (_model.formKey.currentState == null || !_model.formKey.currentState!.validate()) {
                            return;
                          }
                          if (_model.datePicked == null) {
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
                            final userRef = currentUserReference;
                            if (userRef == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Профиль пользователя ещё не готов. Повторите через несколько секунд.')),
                              );
                              return;
                            }
                            try {
                              await userRef.update(createUsersRecordData(
                                dillerLicense: _model.dillerNumberTextController.text,
                                dillerDriverLicense: _model.driverNumberTextController.text,
                                dillerDriverDate: _model.datePicked,
                                file: _model.uploadedFileUrl,
                              ));
                            } on FirebaseException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Не удалось сохранить профиль дилера: ${e.message ?? e.code}')),
                              );
                              return;
                            }
                          }

                          if (!context.mounted) return;
                          context.pushNamed('fill_profile_car_numbers');
                        },
                  text: FFLocalizations.of(context).getText(
                    '3w77w7wy' /* Далее */,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
