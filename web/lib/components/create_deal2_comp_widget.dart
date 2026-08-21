import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'create_deal2_comp_model.dart';
export 'create_deal2_comp_model.dart';

class CreateDeal2CompWidget extends StatefulWidget {
  const CreateDeal2CompWidget({
    super.key,
    required this.onTap,
  });

  final Future Function()? onTap;

  @override
  State<CreateDeal2CompWidget> createState() => _CreateDeal2CompWidgetState();
}

class _CreateDeal2CompWidgetState extends State<CreateDeal2CompWidget> {
  late CreateDeal2CompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDeal2CompModel());

    _model.descriptionTextController ??= TextEditingController(text: FFAppState().createDealDescription);
    _model.descriptionFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 384),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    'hvjdr22h' /* Описание заказа */,
                  ),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _model.descriptionTextController,
                  focusNode: _model.descriptionFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.descriptionTextController',
                    const Duration(milliseconds: 200),
                    () async {
                      FFAppState().createDealDescription = _model.descriptionTextController.text;
                      setState(() {});
                    },
                  ),
                  autofocus: false,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: FFLocalizations.of(context).getText(
                      'cix8cr0r' /* Добавить описание */,
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
                    counterStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: const Color(0xFF424245),
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
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 18.0),
                    suffixIcon: _model.descriptionTextController!.text.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              _model.descriptionTextController?.clear();
                              FFAppState().createDealDescription = '';
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
                  maxLines: 10,
                  minLines: 1,
                  maxLength: 4000,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.name,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  validator: _model.descriptionTextControllerValidator.asValidator(context),
                ),
              ),
              const SizedBox(height: 32),
              FFButtonWidget(
                onPressed: _model.descriptionTextController.text.trim().isEmpty ? null : () async {
                  await widget.onTap?.call();
                },
                text: FFLocalizations.of(context).getText('64hmfy70'),
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
                  hoverColor:  FlutterFlowTheme.of(context).warning,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
