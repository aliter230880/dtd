import 'dart:math';

import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/backend/firebase_storage/storage.dart';
import 'package:auto_deal_app/backend/schema/enums/enums.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'open_disput_bottom_model.dart';
export 'open_disput_bottom_model.dart';

class OpenDisputBottomWidget extends StatefulWidget {
  final DealsRecord deal;
  const OpenDisputBottomWidget({super.key, required this.deal});

  @override
  State<OpenDisputBottomWidget> createState() => _OpenDisputBottomWidgetState();
}

class _OpenDisputBottomWidgetState extends State<OpenDisputBottomWidget> {
  late OpenDisputBottomModel _model;
  final formKey = GlobalKey<FormState>();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OpenDisputBottomModel());

    _model.priceTextController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  onOpenDisput() async {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) return;

    late ChatsRecord? chatRecord;
    final users = [ currentUserReference];

    //create chat
    final Map<String, dynamic> support = {
      "user_ref": 'support',
      "badge": 1,
      "notification": true,
      "in_room": false,
    };
    final Map<String, dynamic> carrierMap = {
      "user_ref": currentUserReference,
      "badge": 0,
      "notification": true,
      "in_room": false,
    };

    var chatsRecordReference = ChatsRecord.collection.doc();

    final messagesRef = <DocumentReference>[];

    final messageRef = MessageRecord.createDoc(chatsRecordReference);

    await messageRef.set({
      ...createMessageRecordData(
        message: _model.priceTextController.text.trim(),
        sender: currentUserReference,
        type: 'text',
      ),
      ...mapToFirestore(
        {
          'time': FieldValue.serverTimestamp(),
        },
      ),
    });

    messagesRef.add(messageRef);

    for (var file in _model.uploadedLocalFiles) {
      bool isPhoto = _isPhoto((file.name ?? '.file').split('.').last);
      final path = getStoragePath(chatsRecordReference.id, file.name ?? 'file.file', false);
      final String? url = await uploadData(path, file.bytes!);

      if (url != null) {
        final fileMessageRef = MessageRecord.createDoc(chatsRecordReference);

        await fileMessageRef.set({
          ...createMessageRecordData(
            message: url,
            sender: currentUserReference,
            type: isPhoto ? 'photo' : 'file',
          ),
          ...mapToFirestore(
            {
              'time': FieldValue.serverTimestamp(),
            },
          ),
        });

        messagesRef.add(fileMessageRef);
      }
    }

    final newChatData = {
      'members': FieldValue.arrayUnion([support, carrierMap]),
      'last_edit_time': FieldValue.serverTimestamp(),
      'created_time': FieldValue.serverTimestamp(),
      'last_message': messagesRef.last,
      'users': FieldValue.arrayUnion(users),
      ...createChatsRecordData(
        dealName: widget.deal.carName,
        dealRef: widget.deal.reference,
        type: 'disput',
      )
    };

    await chatsRecordReference.set(newChatData);

    chatRecord = await ChatsRecord.getDocumentOnce(chatsRecordReference);

    await widget.deal.reference.update({
      'status': DealStatus.InDispute.name,
      'disput_created_by': currentUserReference,
      'disput_created_time': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      context.pop();
      context.pushNamed(
        'ChatRoomPage',
        queryParameters: {'chat': serializeParam(chatRecord, ParamType.Document)}.withoutNulls,
      );
    }
  }

  bool _isPhoto(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 442,
      child: Material(
        color: Colors.transparent,
        elevation: 5.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.only(
               bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: Container(
                          width: 42.0,
                          height: 3.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryText,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            '0xr421z3' /* Открыть спор */,
                          ),
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.0,
                    thickness: 1.0,
                    color: FlutterFlowTheme.of(context).buttonDisabel,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 40.0, 24.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'uagnpwy5' /* Опишите свою проблему */,
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                controller: _model.priceTextController,
                                focusNode: _model.priceFocusNode,
                                autofocus: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'q2yraz3s' /* Описание */,
                                  ),
                                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).secondary,
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
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFFAFAFA),
                                  contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                                textAlign: TextAlign.start,
                                maxLines: 6,
                                minLines: 1,
                                maxLength: 500,
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                keyboardType: TextInputType.multiline,
                                cursorColor: FlutterFlowTheme.of(context).primary,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  final text = FFLocalizations.of(context).getText('fill_field');
                                  if (value == null) return text;
                                  if (value.trim().isEmpty) return text;
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final files = _model.uploadedLocalFiles.map((e) => e).toList();
      
                              if (files.isEmpty) return const SizedBox();
      
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(files.length, (filesIndex) {
                                    final filesItem = files[filesIndex];
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.5, 20.0, 2.5),
                                          child: Container(
                                            width: 36.0,
                                            height: 36.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/images/file.svg',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                filesItem.name ?? 'File',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w500,
                                                      useGoogleFonts: false,
                                                    ),
                                              ),
                                              Text(
                                                getFileSize(filesItem.bytes?.lengthInBytes),
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      color: FlutterFlowTheme.of(context).secondary,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: false,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _model.uploadedLocalFiles.removeAt(filesIndex);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.close_outlined,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 22.0,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).divide(const SizedBox(height: 20.0)),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              height: 54.0,
                              decoration: const BoxDecoration(),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final selectedFiles = await selectFiles(
                                    multiFile: true,
                                  );
                                  if (selectedFiles != null) {
                                    setState(() => _model.isDataUploading = true);
                                    var selectedUploadedFiles = <FFUploadedFile>[];
      
                                    try {
                                      selectedUploadedFiles = selectedFiles
                                          .map((m) => FFUploadedFile(
                                                name: m.storagePath.split('/').last,
                                                bytes: m.bytes,
                                              ))
                                          .toList();
                                    } finally {
                                      _model.isDataUploading = false;
                                    }
                                    if (selectedUploadedFiles.length == selectedFiles.length) {
                                      setState(() {
                                        _model.uploadedLocalFiles.addAll(selectedUploadedFiles);
                                      });
                                    } else {
                                      setState(() {});
                                      return;
                                    }
                                  }
      
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                      child: SvgPicture.asset(
                                        'assets/images/new-file.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'opjpvczo' /* Прикрепить файл */,
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            decoration: TextDecoration.underline,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 20.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'rzn3ot99' /* Вы сможете завершить заказ тол... */,
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).secondary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        context.safePop();
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'ovxh81yc' /* Отменить */,
                                      ),
                                      options: FFButtonOptions(
                                        height: 56.0,
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts: false,
                                            ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      showLoadingIndicator: false,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: onOpenDisput,
                                      text: FFLocalizations.of(context).getText(
                                        'l9qyvf77' /* Отправить */,
                                      ),
                                      options: FFButtonOptions(
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
                                        borderSide: BorderSide(
                                          width: 0.0,
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      showLoadingIndicator: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getFileSize(int? bytes) {
    if (bytes == null) return '';
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}';
  }
}
