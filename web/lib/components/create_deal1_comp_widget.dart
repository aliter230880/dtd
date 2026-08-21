
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'create_deal1_comp_model.dart';
export 'create_deal1_comp_model.dart';

class CreateDeal1CompWidget extends StatefulWidget {
  const CreateDeal1CompWidget({
    super.key,
    required this.onTap,
  });

  final Future Function()? onTap;

  @override
  State<CreateDeal1CompWidget> createState() => _CreateDeal1CompWidgetState();
}

class _CreateDeal1CompWidgetState extends State<CreateDeal1CompWidget> {
  late CreateDeal1CompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDeal1CompModel());

    _model.carNameTextController ??= TextEditingController(text: FFAppState().createDealCarName);
    _model.carNameFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
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
                  'k5v6aa9r' /* Название машины */,
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
                controller: _model.carNameTextController,
                focusNode: _model.carNameFocusNode,
                onChanged: (_) => EasyDebounce.debounce(
                  '_model.carNameTextController',
                  const Duration(milliseconds: 200),
                  () async {
                    FFAppState().createDealCarName = _model.carNameTextController.text;
                    setState(() {});
                  },
                ),
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: FFLocalizations.of(context).getText(
                    'zpjizta7' /* Например, Ауди А5 */,
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
                  suffixIcon: _model.carNameTextController!.text.isNotEmpty
                      ? InkWell(
                          onTap: () async {
                            _model.carNameTextController?.clear();
                            FFAppState().createDealCarName = '';
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
                keyboardType: TextInputType.name,
                cursorColor: FlutterFlowTheme.of(context).primary,
                validator: _model.carNameTextControllerValidator.asValidator(context),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  'c7d8b4vr' /* Фото транпорта */,
                ),
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
            Builder(
              builder: (context) {
                final photos = FFAppState().createDealCarPhotos.map((e) => e).toList();
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: photos.length,
                  itemBuilder: (context, photosIndex) {
                    final photosItem = photos[photosIndex];
                    return Builder(
                      builder: (context) {
                        if (photosItem == '') {
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final selectedMedia = await selectMediaWithSourceBottomSheet(
                                context: context,
                                imageQuality: 50,
                                allowPhoto: true,
                                includeDimensions: true,
                              );
                              if (selectedMedia != null) {
                                FFAppState().updateCreateDealCarPhotosAtIndex(
                                    photosIndex, (_) => selectedMedia.first.filePath!);
                                setState(() {});
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                size: 40.0,
                              ),
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  photosItem,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(1.0, -1.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    FFAppState().updateCreateDealCarPhotosAtIndex(photosIndex, (_) => '');
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.clear_rounded,
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
            if (valueOrDefault<bool>(
              (_model.carNameTextController.text != '') && (FFAppState().hasCarPhotoItem),
              false,
            ))
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: FFButtonWidget(
                  onPressed: () async {
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
                    hoverColor: FlutterFlowTheme.of(context).warning,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
