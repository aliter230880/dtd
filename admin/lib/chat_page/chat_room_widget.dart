import 'dart:math';

import 'package:auto_deal_admin/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_admin/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_deal_admin/flutter_flow/snackbar_service.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:file_picker/file_picker.dart' as fp;

import '../backend/push_notification/push_notification_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat_page_widget.dart';
import 'chat_room_model.dart';

class ChatRoomWidget extends StatefulWidget {
  const ChatRoomWidget({
    super.key,
    required this.chatRecord,
  });

  final ChatsRecord? chatRecord;

  @override
  State<ChatRoomWidget> createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  late ChatRoomModel _model;
  bool loading = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => ChatRoomModel());
    // setRoomStatusOnline();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void onSendMessage() async {
    if (loading) return;
    final text = _model.textController.text.trim();

    if (text.isEmpty) return;

    var messageRecordReference = MessageRecord.createDoc(widget.chatRecord!.reference);

    await messageRecordReference.set({
      ...createMessageRecordData(
        message: text,
        type: 'text',
        sender: currentUserReference,
      ),
      ...mapToFirestore(
        {
          'time': FieldValue.serverTimestamp(),
        },
      ),
    });

    await setChatRecord(messageRecordReference);

    if (mounted) {
      setState(() {
        _model.textController?.clear();
      });
    }

    supportNotification(widget.chatRecord!.users.first, text, widget.chatRecord!.reference);
  }

  Future<void> setChatRecord(DocumentReference messageRef) async {
    Map<Object, Object?> data = {
      "last_message": messageRef,
      "last_edit_time": FieldValue.serverTimestamp(),
    };

    final first = widget.chatRecord!.members.firstWhereOrNull((m) => m['user_ref'] != 'support');

    if (first != null) {
      bool inRoom = first['in_room'] ?? false;

      if (!inRoom) {
        int badge = first['badge'] ?? 0;
        first['badge'] = badge + 1;
        data['members'] = widget.chatRecord!.members;
      }
    }

    await widget.chatRecord!.reference.update(data);
  }

  void onPickFile(String? type) async {
    if (loading) return;

    try {
      fp.PlatformFile? file = await _getPickedFile(type);

      if (file == null) return;

      print('File: ${file.identifier}\n${file.extension}\n${file.name}');

      if (file.size > 10000000) {
        if (mounted) {
          showSnackBar(context, 'Макс размер файла 10мб');
        }
        return;
      }

      bool isPhoto = _isPhoto(file.extension ?? '');

      setState(() {
        loading = true;
      });

      final String? url = await _uploadFile(file.name, file.bytes!);

      if (url != null) {
        var messageRecordReference = MessageRecord.createDoc(widget.chatRecord!.reference);

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

        await setChatRecord(messageRecordReference);

        supportNotification(widget.chatRecord!.users.first, isPhoto ? 'Фото' : 'Файл', widget.chatRecord!.reference);
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print('send file error: $e');
      if (mounted) {
        showSnackBar(context, 'Произошла ошибка при загрузке файла');

        setState(() {
          loading = false;
        });
      }
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

  Future<fp.PlatformFile?> _getPickedFile(String? type) async {
    fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: type == 'photo' ? fp.FileType.image : fp.FileType.any,
    );

    return result?.files.single;
  }

  Future<String?> _uploadFile(String name, Uint8List data) async {
    String? url = await ImagePickerHelper.uploadFileToChat(name, data, widget.chatRecord!.reference.id);
    return url;
  }

  Widget customBusston() {
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 18,top: 4,bottom: 4),
      child: SizedBox(
        width: 26.0,
        height: 26.0,
        child: loading
            ? SizedBox(
                width: 20.0,
                height: 20.0,
                child: Center(child: CircularProgressIndicator(color: FlutterFlowTheme.of(context).primary)),
              )
            : Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: FaIcon(
                  FontAwesomeIcons.paperclip,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 18.0,
                ),
              ),
      ),
    );
  }

  void supportNotification(DocumentReference userRef, String text, DocumentReference chatRef) async {
    triggerPushNotification(
      notificationText: 'Новое сообщение',
      notificationTitle: text,
      initialPageName: 'ChatRoomPage',
      userRefs: [userRef],
      notificationSound: 'default',
      parameterData: {"chatRef": chatRef},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chatRecord == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset('assets/images/chat_empty.svg'),
              Text(
                'Выберите, кому хотели бы написать',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: const Color(0xFFBDBDBD),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );
    }
    return Container(
      height: double.infinity,
      margin: const EdgeInsets.only(top: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 12.0),
              child: FutureBuilder<UsersRecord>(
                future: UsersRecord.getDocumentOnce(widget.chatRecord!.users.first),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return loadingWidget(context);
                  }
                  final rowUsersRecord = snapshot.data!;
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      UserAvatar(avatar: rowUsersRecord.photoUrl, size: 60),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rowUsersRecord.displayName,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              FutureBuilder<DealsRecord>(
                                future: DealsRecord.getDocumentOnce(widget.chatRecord!.dealRef!),
                                builder: (context, snapshot2) {
                                  // Customize what your widget looks like when it's loading.
                                  final deal = snapshot2.data;

                                  return Text(
                                    deal == null ? 'Загрузка...' : 'Заказ: ${deal.locationAddress}',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: StreamBuilder<List<MessageRecord>>(
                  stream: queryMessageRecord(
                    parent: widget.chatRecord?.reference,
                    queryBuilder: (messageRecord) => messageRecord.orderBy('time', descending: true),
                  ),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return loadingWidget(context);
                    }

                    if (snapshot.data == null) return const SizedBox();
                    List<MessageRecord> messages = snapshot.data!;

                    Map<String, List<MessageRecord>> groupedMessages = {};

                    for (var message in messages) {
                      String dateKey = DateFormat('yyyy-MM-dd').format(message.time ?? DateTime.now());
                      if (groupedMessages.containsKey(dateKey)) {
                        groupedMessages[dateKey]?.add(message);
                      } else {
                        groupedMessages[dateKey] = [message];
                      }
                    }

                    List<String> sortedDates = groupedMessages.keys.toList()..sort((a, b) => b.compareTo(a));

                    return ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      itemCount: groupedMessages.length,
                      itemBuilder: (context, index) {
                        String date = sortedDates[index];
                        List<MessageRecord> dayMessages = groupedMessages[date]!
                          ..sort((a, b) => a.time == null || b.time == null ? 0 : (a.time!).compareTo(b.time!));
                        // final message = messages[index];

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
                        // return Column(
                        //   crossAxisAlignment: isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(bottom: 12),
                        //           child: Text(
                        //             dateTimeFormatChat(message.time, locale: 'ru'),
                        //             style: FlutterFlowTheme.of(context).bodyMedium.override(
                        //                   fontFamily: 'Inter',
                        //                   fontSize: 13.0,
                        //                   fontWeight: FontWeight.normal,
                        //                   color: const Color(0xFF94969E),
                        //                 ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: isMine ? MainAxisAlignment.start : MainAxisAlignment.end,
                        //       mainAxisSize: MainAxisSize.min,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         (message.type != 'text')
                        //             ? fileOrImageMessage(message, isMine)
                        //             : Flexible(
                        //                 child: Container(
                        //                   margin: EdgeInsets.only(
                        //                       bottom: 16, left: !isMine ? 110 : 0, right: !isMine ? 0 : 110),
                        //                   decoration: BoxDecoration(
                        //                     color: isMine ? Colors.black : FlutterFlowTheme.of(context).primary,
                        //                     borderRadius: BorderRadius.circular(18),
                        //                   ),
                        //                   padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        //                   child: Text(
                        //                     message.message,
                        //                     style: FlutterFlowTheme.of(context).bodyMedium.override(
                        //                           fontFamily: 'Inter',
                        //                           fontSize: 16.0,
                        //                           fontWeight: FontWeight.normal,
                        //                           color: FlutterFlowTheme.of(context).primaryBackground,
                        //                         ),
                        //                   ),
                        //                 ),
                        //               ),
                        //       ],
                        //     ),
                        //   ],
                        // );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _model.textController,
              focusNode: _model.textFieldFocusNode,
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                hintText: 'Написать сообщение...',
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintText,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.4)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryText),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryText),
                ),
                prefixIcon: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'photo',
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.image,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Загрузить фото',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'file',
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                FontAwesomeIcons.paperclip,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Загрузить файл',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    value: null,
                    onChanged: onPickFile,
                    customButton: customBusston(),
                    dropdownStyleData: DropdownStyleData(
                      offset: const Offset(-10, 110),
                      isOverButton: true,
                      elevation: 2,
                      width: 262,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 44,
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 18.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onSendMessage,
                    child: FaIcon(
                      FontAwesomeIcons.solidPaperPlane,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    lineHeight: 1.0,
                  ),
              maxLines: 5,
              minLines: 1,
              cursorColor: FlutterFlowTheme.of(context).primary,
              validator: _model.textControllerValidator.asValidator(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget groupDivider(String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(height: 0, thickness: 1, color: Color(0xFFDEDEDE)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            date,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                  color: const Color(0xFF979797),
                ),
          ),
        ),
        const Expanded(
          child: Divider(height: 0, thickness: 1, color: Color(0xFFDEDEDE)),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Сегодня';
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return 'Вчера';
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }

  Widget messageWrapper(MessageRecord message) {
    bool isMine = message.sender != widget.chatRecord!.users.first;
    return (!isMine) ? otherMessage(message) : mineMessage(message);
  }

  Widget mineMessage(MessageRecord message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (message.type != 'text')
            ? fileOrImageMessage(message, true)
            : Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 0, left: 110, right: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6D7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Text(
                        message.message,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 25),
                      child: Text(
                        DateFormat('HH:mm').format(message.time ?? DateTime.now()),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF979797),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget otherMessage(MessageRecord message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (message.type != 'text')
            ? fileOrImageMessage(message, false)
            : Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 110),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Text(
                        message.message,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 25),
                      child: Text(
                        DateFormat('HH:mm').format(message.time ?? DateTime.now()),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF979797),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget fileOrImageMessage(MessageRecord message, bool isMine) {
    if (message.type == 'photo') {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: message.message,
                  height: 204,
                  width: 204,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loadingWidget(context),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const Center(child: Icon(Icons.error, color: Colors.white30));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat('HH:mm').format(message.time ?? DateTime.now()),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF979797),
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Flexible(
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isMine ? const Color(0xFFFFF6D7) : const Color(0xFFF5F5F5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(child: Icon(CupertinoIcons.doc, size: 20)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'File',
                        // message.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      const SizedBox(height: 2),
                      FutureBuilder<String>(
                          future: getFileSize(message.message, 1),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? '...',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 25),
              child: Text(
                DateFormat('HH:mm').format(message.time ?? DateTime.now()),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF979797),
                    ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<String> getFileSize(String filepath, int decimals) async {
    final fileRef = FirebaseStorage.instance.refFromURL(filepath);
    final metadate = await fileRef.getMetadata();
    final bytes = metadate.size ?? 0;
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}

String dateTimeFormatChat(DateTime? dateTime, {String? locale}) {
  final now = DateTime.now();
  if (dateTime == null) {
    return '';
  }
  if (DateTime(dateTime.year, dateTime.month, dateTime.day) == DateTime(now.year, now.month, now.day)) {
    return 'Сегодня ${DateFormat('HH:mm', locale).format(dateTime)}';
  } else {
    return DateFormat('EEE, LLLL dd, HH:mm', locale).format(dateTime);
  }
}
