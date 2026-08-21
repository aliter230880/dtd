import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'app_text_field_model.dart';
export 'app_text_field_model.dart';

class AppTextFieldWidget extends StatefulWidget {
  const AppTextFieldWidget({
    super.key,
    this.hintText,
    Color? fillColor,
    bool? isPassword,
    double? fontSize,
    this.initial,
    bool? readOnly,
  })  : fillColor = fillColor ?? const Color(0xFFFEFEFE),
        isPassword = isPassword ?? false,
        fontSize = fontSize ?? 14.0,
        readOnly = readOnly ?? false;

  final String? hintText;
  final Color fillColor;
  final bool isPassword;
  final double fontSize;
  final String? initial;
  final bool readOnly;

  @override
  State<AppTextFieldWidget> createState() => _AppTextFieldWidgetState();
}

class _AppTextFieldWidgetState extends State<AppTextFieldWidget> {
  late AppTextFieldModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppTextFieldModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: _model.textController,
        focusNode: _model.textFieldFocusNode,
        autofocus: false,
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
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFBDBDBD),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).primaryBackground,
          contentPadding:
              const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Inter',
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
        validator: _model.textControllerValidator.asValidator(context),
      ),
    );
  }
}
