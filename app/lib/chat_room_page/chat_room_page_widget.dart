// ignore_for_file: avoid_print

import 'dart:math';

import 'package:auto_deal_app/backend/firebase_storage/storage.dart';
import 'package:auto_deal_app/backend/push_notifications/push_notifications_util.dart';
import 'package:collection/collection.dart';

import 'package:file_picker/file_picker.dart' as fp;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat_room_page_model.dart';
export 'chat_room_page_model.dart';

class ChatRoomPageWidget extends StatefulWidget {
  const ChatRoomPageWidget({
    super.key,
    required this.chat,
  });

  final ChatsRecord? chat;

  @override
  State<ChatRoomPageWidget> createState() => _ChatRoomPageWidgetState();
}

class _ChatRoomPageWidgetState extends State<ChatRoomPageWidget> {
  late ChatRoomPageModel _model;
  bool loading = false;
  bool fileloading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatRoomPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'ChatRoomPage'});
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textController?.addListener(() {
      setState(() {});
    });
    setRoomStatusOnline();
  }

  void setRoomStatusOnline() async {
    await Future.delayed(const Duration(seconds: 1));
    final me = widget.chat?.members.firstWhereOrNull((m) => m['user_ref'] == currentUserReference);

    if (me != null) {
      me['badge'] = 0;
      me['in_room'] = true;
      await widget.chat?.reference.update({"members": widget.chat?.members});
    }

    FFAppState().currentChatRef = widget.chat?.reference;
    if (mounted) setState(() {});
  }

  void setRoomStatusOffline() async {
    final me = widget.chat?.members.firstWhereOrNull((m) => m['user_ref'] == currentUserReference);

    if (me != null) {
      me['in_room'] = false;
      await widget.chat?.reference.update({"members": widget.chat?.members});
    }
    FFAppState().currentChatRef = null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    setRoomStatusOffline();
    super.dispose();
  }

  void onSend(String text) async {
    if (loading || fileloading) return;

    var messageRecordReference = MessageRecord.createDoc(widget.chat!.reference);
    await messageRecordReference.set({
      ...createMessageRecordData(
        message: text,
        sender: currentUserReference,
        type: 'text',
      ),
      ...mapToFirestore(
        {
          'time': FieldValue.serverTimestamp(),
        },
      ),
    });

    await setChatRecord(messageRecordReference, text);

    // final secondUser = widget.chat.users.firstWhereOrNull((u) => u != currentUserReference);
    // if (secondUser != null) {
    //   NotificationService.one2oneChatNotification(secondUser, text, widget.chat.reference);
    // }

    setState(() {
      _model.textController?.clear();
    });
  }

  Future<void> setChatRecord(DocumentReference messageRef, String text) async {
    Map<Object, Object?> data = {
      "last_message": messageRef,
      "last_edit_time": FieldValue.serverTimestamp(),
    };

    final first = widget.chat?.members.firstWhereOrNull((m) => m['user_ref'] != currentUserReference);

    if (first != null) {
      bool inRoom = first['in_room'] ?? false;

      if (!inRoom) {
        int badge = first['badge'] ?? 0;
        first['badge'] = badge + 1;
        data['members'] = widget.chat?.members;
      }
    }

    await widget.chat?.reference.update(data);

    NotificationService.onMessage(first!['user_ref'], widget.chat!.reference, text);
  }

  void onSelectFile() async {
    if (loading || fileloading) return;

    try {
      fp.PlatformFile? file = await _getPickedFile();

      if (file == null || file.path == null) return;

      print('File: ${file.identifier}\n${file.extension}\n${file.name}\n${file.size}');

      if (file.size > 10000000) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Макс размер файла 10мб')),
          );
        }
        return;
      }

      bool isPhoto = _isPhoto(file.extension ?? '');

      setState(() {
        fileloading = true;
      });

      final String? url = await _uploadFile(file.path!);

      if (url != null) {
        var messageRecordReference = MessageRecord.createDoc(widget.chat!.reference);

        await messageRecordReference.set({
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

        await setChatRecord(messageRecordReference, 'File');

        // final secondUser = widget.chat.users.firstWhereOrNull((u) => u != currentUserReference);
        // if (secondUser != null) {
        //   NotificationService.one2oneChatNotification(secondUser, isPhoto ? 'Фото' : 'Файл', widget.chat.reference);
        // }
      }

      setState(() {
        fileloading = false;
      });
    } catch (e) {
      print('send file error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(FFLocalizations.of(context).getText('error'))),
        );
      }
      setState(() {
        fileloading = false;
      });
    }
  }

  Future<fp.PlatformFile?> _getPickedFile() async {
    fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: fp.FileType.any,
    );

    return result?.files.single;
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

  Future<String?> _uploadFile(String path) async {
    String? url = await uploadFileToChat(path, widget.chat!.reference.id);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
              // CupertinoIcons.arrow_left,
              CupertinoIcons.arrow_left,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 20.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Builder(builder: (context) {
            if (widget.chat?.type == 'disput' || widget.chat?.type == 'support') {
              return Text(
                'Поддержка',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: false,
                    ),
              );
            }
            final user = widget.chat?.users.firstWhere((e) => e != currentUserReference);
            if (user == null) return const SizedBox();
            return FutureBuilder<UsersRecord>(
              future: UsersRecord.getDocumentOnce(user),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }

                final rowUsersRecord = snapshot.data!;

                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 1),
                    Expanded(
                      child: Text(
                        rowUsersRecord.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          'DealUserProfile',
                          queryParameters: {
                            // 'deal': serializeParam(_model.deal, ParamType.Document),
                            'userRef': serializeParam(user, ParamType.DocumentReference),
                          },
                        );
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 300),
                          imageUrl: rowUsersRecord.photoUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) => Image.asset(
                            'assets/images/error_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 50.0, 24.0, 0.0),
                      child: StreamBuilder<List<MessageRecord>>(
                        stream: queryMessageRecord(
                          parent: widget.chat?.reference,
                          queryBuilder: (messageRecord) => messageRecord.orderBy('time', descending: true),
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.data == null) return const SizedBox();
                          List<MessageRecord> listViewMessageRecordList = snapshot.data!;

                          Map<String, List<MessageRecord>> groupedMessages = {};

                          for (var message in listViewMessageRecordList) {
                            String dateKey = DateFormat('yyyy-MM-dd').format(message.time ?? DateTime.now());
                            if (groupedMessages.containsKey(dateKey)) {
                              groupedMessages[dateKey]?.add(message);
                            } else {
                              groupedMessages[dateKey] = [message];
                            }
                          }

                          List<String> sortedDates = groupedMessages.keys.toList()..sort((a, b) => b.compareTo(a));

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            itemCount: groupedMessages.length,
                            itemBuilder: (context, listViewIndex) {
                              String date = sortedDates[listViewIndex];
                              List<MessageRecord> dayMessages = groupedMessages[date]!
                                ..sort((a, b) => a.time == null || b.time == null ? 0 : (a.time!).compareTo(b.time!));
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  groupDivider(_formatDate(DateTime.parse(date))),
                                  const SizedBox(height: 20),
                                  ...dayMessages.map(
                                    (message) => messageWrapper(message),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    dealBannder(),
                  ],
                ),
              ),
              // input(),
              _Field(
                textEditingController: _model.textController,
                onSend: onSend,
                onPickFile: onSelectFile,
                loading: fileloading,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget groupDivider(String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(height: 0, thickness: 1, color: Color(0xFFE0E0E0)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            date,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
        ),
        const Expanded(
          child: Divider(height: 0, thickness: 1, color: Color(0xFFE0E0E0)),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return FFLocalizations.of(context).getText('today');
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return FFLocalizations.of(context).getText('yesterday');
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }

  Widget messageWrapper(MessageRecord message) {
    bool isMine = message.sender == currentUserReference;
    return (!isMine) ? otherMessage(message) : mineMessage(message);
  }

  Widget otherMessage(MessageRecord message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        (message.type != 'text')
            ? fileOrImageMessage(message, false)
            : Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, left: 0, right: 100),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                              color: const Color(0xFF424245),
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateTimeFormat(
                          'HH:mm',
                          message.time ?? DateTime.now(),
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: const Color(0xFF6B7077),
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget mineMessage(MessageRecord message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        (message.type != 'text')
            ? fileOrImageMessage(message, true)
            : Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, left: 100, right: 0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.message,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateTimeFormat(
                          'HH:mm',
                          message.time ?? DateTime.now(),
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).border,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget messageWidget(MessageRecord message) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(80.0, 0.0, 0.0, 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.message,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
              Text(
                dateTimeFormat(
                  'Hm',
                  message.time!,
                  locale: FFLocalizations.of(context).languageCode,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).border,
                      fontSize: 10.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fileOrImageMessage(MessageRecord message, bool isMine) {
    if (message.type == 'photo') {
      return Flexible(
        child: Container(
          margin: EdgeInsets.only(bottom: 16, left: isMine ? 70 : 0, right: isMine ? 0 : 70),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isMine ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: message.message,
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                  placeholder: (context, url) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const Center(child: Icon(Icons.error, color: Colors.white30));
                  },
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateTimeFormat('HH:mm', message.time),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).border,
                      fontSize: 10.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Flexible(
        child: Container(
          margin: EdgeInsets.only(bottom: 16, left: isMine ? 100 : 0, right: isMine ? 0 : 100),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isMine ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async{
                  String url = message.message;
                  launchUrl(Uri.parse(url));
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Center(child: SvgPicture.asset('assets/images/file.svg')),
                    ),
                    FutureBuilder<FullMetadata>(
                        future: getMetadata(message.message, 0),
                        builder: (context, snapshot) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?.name ?? 'File',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).border,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  getFileSize(snapshot.data),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).border,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateTimeFormat('HH:mm', message.time),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).border,
                      fontSize: 10.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<FullMetadata> getMetadata(String filepath, int decimals) async {
    final fileRef = FirebaseStorage.instance.refFromURL(filepath);
    final metadate = await fileRef.getMetadata();
    return metadate;
  }

  String getFileSize(FullMetadata? metadate) {
    if (metadate == null) return "...";
    final bytes = metadate.size ?? 0;
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}';
  }

  Widget dealBannder() {
    return Align(
      alignment: const AlignmentDirectional(0.0, -1.0),
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          child: Builder(builder: (context) {
            final ref = widget.chat?.dealRef;
            if (ref == null) return const SizedBox();
            return FutureBuilder<DealsRecord>(
              future: DealsRecord.getDocumentOnce(ref),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }

                final rowDealsRecord = snapshot.data!;

                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        fadeInDuration: const Duration(milliseconds: 400),
                        fadeOutDuration: const Duration(milliseconds: 400),
                        imageUrl: rowDealsRecord.carPhotos.first,
                        width: 36.0,
                        height: 36.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rowDealsRecord.carName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                    Text(
                      currencyFormat.format(rowDealsRecord.price),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _Field extends StatefulWidget {
  final TextEditingController? textEditingController;
  final VoidCallback onPickFile;
  final Function(String) onSend;
  final bool loading;
  const _Field({
    required this.textEditingController,
    required this.onSend,
    required this.onPickFile,
    required this.loading,
  });

  @override
  State<_Field> createState() => __FieldState();
}

class __FieldState extends State<_Field> {
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    widget.textEditingController?.addListener(() {
      final text = widget.textEditingController.text;
      if (text.trim().isNotEmpty) {
        setState(() {
          hasText = true;
        });
      } else {
        setState(() {
          hasText = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.textEditingController,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: FFLocalizations.of(context).getText('g08fv5o2'),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFF9E9E9E),
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFE7E7E7),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFE7E7E7),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFE7E7E7),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFE7E7E7),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
                  prefixIcon: GestureDetector(
                    onTap: widget.onPickFile,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 14, left: 16),
                      child: FaIcon(
                        FontAwesomeIcons.paperclip,
                      ),
                    ),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                maxLines: 4,
                minLines: 1,
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                cursorColor: FlutterFlowTheme.of(context).primary,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if (hasText) {
                    widget.onSend(widget.textEditingController.text);
                  }
                },
                child: Opacity(
                  opacity: !hasText ? 0.5 : 1,
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      shape: BoxShape.circle,
                    ),
                    child: widget.loading
                        ? const Center(child: CircularProgressIndicator())
                        : Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: SvgPicture.asset(
                              'assets/images/paper.svg',
                              width: 20.0,
                              height: 20.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
