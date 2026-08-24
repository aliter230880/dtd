import 'package:auto_deal_app/backend/backend.dart';

import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/backend/firebase_storage/storage.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_deal_app/flutter_flow/upload_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditDealFilesPage extends StatefulWidget {
  const EditDealFilesPage({super.key, required this.deal});

  final DealsRecord? deal;
  @override
  State<EditDealFilesPage> createState() => _EditDealFilesPageState();
}

class _EditDealFilesPageState extends State<EditDealFilesPage> {
  int loadingIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 0.0),
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
            StreamBuilder<DealsRecord>(
                stream: DealsRecord.getDocument(widget.deal!.reference),
                initialData: widget.deal,
                builder: (context, snapshot) {
                  final deal = snapshot.data;
                  return Expanded(
                    child: Builder(
                      builder: (context) {
                        final dealFiles = deal?.files ?? [];
                        int length = dealFiles.length == 5 ? dealFiles.length : (dealFiles.length + 1);
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: length,
                          itemBuilder: (context, filesIndex) {
                            final filesItem = dealFiles.length > filesIndex ? dealFiles[filesIndex] : null;
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
                                        filesItem == null ? "assets/images/upload.svg" : 'assets/images/attach.svg',
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
                                            filesItem == null ? 'gknitk6o2' : 'ftny370e' /* Файл добавлен */,
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
                                                filesItem == null
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
                                      if (filesItem == null) {
                                        final selectedFiles = await selectFiles(multiFile: false);

                                        if (selectedFiles != null && selectedFiles.isNotEmpty) {
                                          setState(() {
                                            loadingIndex = filesIndex;
                                          });
                                          final selected = selectedFiles.first;
                                          final path = getStoragePath(
                                            currentUserUid,
                                            'deal_file_${DateTime.now().millisecondsSinceEpoch}.pdf',
                                            false,
                                          );
                                          final String? url = await uploadData(path, selected.bytes);
                                          if (url != null) {
                                            final data = {
                                              "files": FieldValue.arrayUnion([url])
                                            };

                                            await widget.deal?.reference.update(data);
                                          }

                                          setState(() {
                                            loadingIndex = -1;
                                          });
                                        }
                                      } else {
                                        if (loadingIndex != -1) return;
                                        final data = {
                                          "files": FieldValue.arrayRemove([filesItem])
                                        };

                                        await widget.deal?.reference.update(data);
                                      }
                                    },
                                    text: loadingIndex == filesIndex ? 'Загрузка...' : (filesItem != null) ? 'Удалить' : 'Загрузить',
                                    options: FFButtonOptions(
                                      width: 111.0,
                                      height: 36.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: filesItem != null
                                          ? FlutterFlowTheme.of(context).primaryText
                                          : FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'Inter',
                                            color: filesItem != null
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
                  );
                }),
          ],
        ),
      ),
    );
  }
}
