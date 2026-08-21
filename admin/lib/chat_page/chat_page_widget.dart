import 'dart:developer';

import 'package:auto_deal_admin/app_state.dart';
import 'package:auto_deal_admin/backend/backend.dart';
import 'package:auto_deal_admin/flutter_flow/flutter_flow_theme.dart';
import 'package:auto_deal_admin/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../auth/firebase_auth/apple_auth.dart';
import '../backend/schema/enums/enums.dart';
import '../components/app_bar_widget.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'chat_room_widget.dart';

@RoutePage()
class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({super.key});

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  ChatsRecord? chatRecord;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatsRecord> chats = [];
  late StreamSubscription chatsubscription;

  void init() {
    chatsubscription =
        queryChatsRecord(queryBuilder: (q) => q.where('type', whereIn: ['support', 'disput'])).listen((event) {
      if (mounted) {
        final DocumentReference? selectedChat = FFAppState().currentChatRef;
        if (selectedChat != null) {
          log('chat init has selected chat $selectedChat');
          chatRecord = event.firstWhereOrNull((c) => c.reference == selectedChat);
          FFAppState().currentChatRef = null;
        }
        setState(() {
          chats = event;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    chatsubscription.cancel();
    dispese();

    super.dispose();
  }

  void setRoomStatusOnline(ChatsRecord chat) async {
    setRoomStatusOffline(chat);
    final me = chat.members.firstWhereOrNull((m) => m['user_ref'] == 'support');

    if (me != null) {
      me['badge'] = 0;
      me['in_room'] = true;
      await chat.reference.update({"members": chat.members});
    }
  }

  void setRoomStatusOffline(ChatsRecord newChat) async {
    if (chatRecord != null && newChat.reference != chatRecord?.reference) {
      final me = chatRecord?.members.firstWhereOrNull((m) => m['user_ref'] == 'support');

      if (me != null) {
        me['in_room'] = false;
        await chatRecord?.reference.update({"members": chatRecord?.members});
      }
    }
  }

  Future<void> onDispose() async {
    if (chatRecord != null) {
      final me = chatRecord?.members.firstWhereOrNull((m) => m['user_ref'] == 'support');

      if (me != null) {
        me['in_room'] = false;

        await chatRecord?.reference.update({"members": chatRecord?.members});
      }
    }
  }

  Future<void> dispese() async {
    await onDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const AppBarWidget(pageName: 'Чат'),
            if (chats.isEmpty)
              const _EmptyChatWidget()
            else
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 16.0, 0.0),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          // borderRadius: BorderRadius.circular(16.0),
                          // border: Border.all(
                          //   color: FlutterFlowTheme.of(context).secondaryBackground,
                          //   width: 1.0,
                          // ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (chats.isNotEmpty)
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: chats.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewChatsRecord = chats[listViewIndex];
                                  return FutureBuilder<UsersRecord>(
                                    future: UsersRecord.getDocumentOnce(listViewChatsRecord.users.first),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: loadingWidget(context, size: 32),
                                        );
                                      }
                                      final chatTileUsersRecord = snapshot.data!;
                                      final member = listViewChatsRecord.members
                                          .firstWhereOrNull((m) => m['user_ref'] != 'support');
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          bool hasAccessBool = hasAccess(AdminAccess.support);

                                          if (!hasAccessBool) {
                                            await showAccessDeniedDialog(context);
                                            return;
                                          }
                                          setRoomStatusOnline(listViewChatsRecord);
                                          setState(() {
                                            chatRecord = listViewChatsRecord;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: chatRecord?.reference == listViewChatsRecord.reference
                                                ? const Color(0xFFFAE28C)
                                                : null,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: chatRecord?.reference == listViewChatsRecord.reference
                                                ? [
                                                    BoxShadow(
                                                      offset: const Offset(4, 12),
                                                      blurRadius: 32,
                                                      color: const Color(0xFF353636).withOpacity(0.20),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible: (member?['in_room'] ?? false),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child: Icon(Icons.lens,
                                                        size: 8, color: FlutterFlowTheme.of(context).primary),
                                                  ),
                                                ),
                                                UserAvatar(avatar: chatTileUsersRecord.photoUrl, size: 50),
                                                if (listViewChatsRecord.lastMessage != null)
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: FutureBuilder<MessageRecord>(
                                                        future: MessageRecord.getDocumentOnce(
                                                            listViewChatsRecord.lastMessage!),
                                                        builder: (context, snapshot2) {
                                                          if (!snapshot2.hasData) {
                                                            return loadingWidget(context, size: 32);
                                                          }
                                                          final columnMessageRecord = snapshot2.data!;

                                                          return Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 2),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        chatTileUsersRecord.displayName,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Inter',
                                                                              letterSpacing: 0.0,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      dateTimeFormat(
                                                                        'Hm',
                                                                        columnMessageRecord.time!,
                                                                        locale: 'ru',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily: 'Inter',
                                                                            fontSize: 14.0,
                                                                            letterSpacing: 0.0,
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      columnMessageRecord.type == 'text'
                                                                          ? columnMessageRecord.message
                                                                          : columnMessageRecord.type == 'file'
                                                                              ? 'Файл'
                                                                              : 'Фото',
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: FlutterFlowTheme.of(context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily: 'Inter',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  // Visibility(
                                                                  //   visible: (member?['badge'] ?? 0) != 0,
                                                                  //   child: Container(
                                                                  //     margin: const EdgeInsets.only(left: 8),
                                                                  //     width: 30.0,
                                                                  //     height: 20.0,
                                                                  //     decoration: BoxDecoration(
                                                                  //       color: FlutterFlowTheme.of(context).primary,
                                                                  //       borderRadius: BorderRadius.circular(16.0),
                                                                  //     ),
                                                                  //     child: Center(
                                                                  //       child: Text(
                                                                  //         (member?['badge'] ?? 0).toString(),
                                                                  //         style: FlutterFlowTheme.of(context)
                                                                  //             .bodyMedium
                                                                  //             .override(
                                                                  //               fontFamily: 'Inter',
                                                                  //               color: Colors.white,
                                                                  //               fontSize: 12.0,
                                                                  //               letterSpacing: 0.0,
                                                                  //               fontWeight: FontWeight.w500,
                                                                  //             ),
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                if (listViewChatsRecord.lastMessage == null)
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            chatTileUsersRecord.displayName,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'Inter',
                                                                  letterSpacing: 0.0,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                          ),
                                                          Text(
                                                            'Начините чат',
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'Inter',
                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                  letterSpacing: 0.0,
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
                                      );
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ChatRoomWidget(
                        chatRecord: chatRecord,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChatWidget extends StatelessWidget {
  const _EmptyChatWidget();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/message.png',
            width: 142,
            height: 142,
            fit: BoxFit.contain,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Сообщений нет',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Начните диалог',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: const Color(0xFFBDBDBD),
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String? avatar;
  final double size;
  const UserAvatar({super.key, this.avatar, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 500),
        fadeOutDuration: const Duration(milliseconds: 500),
        imageUrl: avatar ??
            'https://firebasestorage.googleapis.com/v0/b/dealertodealer-84957.appspot.com/o/config%2Favatar.png?alt=media&token=83b57cc6-2b25-4c79-a195-04c51c6785a4',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (context, error, stackTrace) {
          print('error: $error');
          return Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(5),
            color: Colors.grey.shade100,
            child: const Center(
              child: Icon(Icons.error_outline_outlined),
            ),
          );
        },
        placeholder: (context, url) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(5),
            child: Center(
              child: CircularProgressIndicator(color: FlutterFlowTheme.of(context).primary),
            ),
          );
        },
      ),
    );
  }
}
