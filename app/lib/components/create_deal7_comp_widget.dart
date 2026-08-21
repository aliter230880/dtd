import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'create_deal7_comp_model.dart';
export 'create_deal7_comp_model.dart';

class CreateDeal7CompWidget extends StatefulWidget {
  const CreateDeal7CompWidget({
    super.key,
    required this.onTap,
  });

  final Future Function()? onTap;

  @override
  State<CreateDeal7CompWidget> createState() => _CreateDeal7CompWidgetState();
}

class _CreateDeal7CompWidgetState extends State<CreateDeal7CompWidget> {
  late CreateDeal7CompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDeal7CompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
            child: Text(
              FFLocalizations.of(context).getText(
                'gknitk6o' /* Прикрепить файл */,
              ),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: Text(
              FFLocalizations.of(context).getText(
                '4wr8zluz' /* Например, оплаченный счет на а... */,
              ),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).hintColor,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final files = FFAppState().creatDealFiles;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemCount: files.length,
                  itemBuilder: (context, filesIndex) {
                    final filesItem = files[filesIndex];
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: SvgPicture.asset(
                                filesItem == '' ? "assets/images/upload.svg" : 'assets/images/attach.svg',
                                width: 18.0,
                                height: 18.0,
                                fit: BoxFit.none,
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
                                    filesItem == '' ? 'gknitk6o2' : 'ftny370e' /* Файл добавлен */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        filesItem == ''
                                            ? 'Нет файла'
                                            : FFLocalizations.of(context).getText(
                                                'fk34a0zo' /* Файл загружен */,
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
                                ),
                              ],
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              if (filesItem == '') {
                                final selectedFiles = await selectFiles(multiFile: false);

                                final String? path = selectedFiles?.first.filePath;

                                if (path != null) {
                                  setState(() {
                                    FFAppState().updateCreatDealFilesAtIndex(filesIndex, (_) => path);
                                  });
                                }
                              } else {
                                setState(() {
                                  FFAppState().updateCreatDealFilesAtIndex(filesIndex, (_) => '');
                                });
                              }
                            },
                            text: (filesItem != '') ? 'Удалить' : 'Загрузить',
                            options: FFButtonOptions(
                              width: 111.0,
                              height: 36.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: filesItem != ''
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: filesItem != ''
                                        ? FlutterFlowTheme.of(context).secondaryBackground
                                        : FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 13.0,
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
                    );
                  },
                );
              },
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              await widget.onTap?.call();
            },
            text: FFLocalizations.of(context).getText(
              '1hellx4h' /* Опубликовать заказ */,
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
            ),
          ),
        ],
      ),
    );
  }
}
