import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/chat_empty_comp_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat_tab_model.dart';
export 'chat_tab_model.dart';

class ChatTabWidget extends StatefulWidget {
  const ChatTabWidget({super.key});

  @override
  State<ChatTabWidget> createState() => _ChatTabWidgetState();
}

class _ChatTabWidgetState extends State<ChatTabWidget> {
  late ChatTabModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatTabModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'ChatTab'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          FFLocalizations.of(context).getText(
            'p4xzs9g2' /* Чат */,
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
        child: StreamBuilder<List<ChatsRecord>>(
          stream: queryChatsRecord(
            queryBuilder: (chatsRecord) => chatsRecord
                .where('users', arrayContains: currentUserReference)
                .orderBy('last_edit_time', descending: true),
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
            List<ChatsRecord> listViewChatsRecordList = snapshot.data!;

            if (listViewChatsRecordList.isEmpty) {
              return const SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ChatEmptyCompWidget(),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              scrollDirection: Axis.vertical,
              itemCount: listViewChatsRecordList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14.0),
              itemBuilder: (context, listViewIndex) {
                final listViewChatsRecord = listViewChatsRecordList[listViewIndex];
                return FutureBuilder<UsersRecord>(
                  future: UsersRecord.getDocumentOnce(
                      listViewChatsRecord.users.where((e) => e.id != currentUserReference?.id).toList().isEmpty
                          ? currentUserReference!
                          : listViewChatsRecord.users.where((e) => e.id != currentUserReference?.id).toList().first),
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

                    final containerUsersRecord = snapshot.data!;

                    return GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          'ChatRoomPage',
                          queryParameters:
                              {'chat': serializeParam(listViewChatsRecord, ParamType.Document)}.withoutNulls,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 74.0,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (context) {
                                if (listViewChatsRecord.type == 'chat') {
                                  return Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14.0),
                                      child: CachedNetworkImage(
                                        fadeInDuration: const Duration(milliseconds: 300),
                                        fadeOutDuration: const Duration(milliseconds: 300),
                                        imageUrl: containerUsersRecord.photoUrl,
                                        width: 68.0,
                                        height: 68.0,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, error, stackTrace) => Image.asset(
                                          'assets/images/error_image.png',
                                          width: 68.0,
                                          height: 68.0,
                                          fit: BoxFit.cover,
                                        ),
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14.0),
                                      child: Container(
                                        width: 68,
                                        height: 68,
                                        padding: const EdgeInsets.all(4),
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        child: SvgPicture.asset(
                                          'assets/images/support.svg',
                                          width: 68.0,
                                          height: 68.0,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 14.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  (listViewChatsRecord.type == 'chat')
                                                      ? containerUsersRecord.displayName
                                                      : FFLocalizations.of(context).getText('p4xzs9g3'),
                                                  maxLines: 1,
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Inter',
                                                        color: FlutterFlowTheme.of(context).border,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  dateTimeFormat(
                                                    'relative',
                                                    listViewChatsRecord.lastEditTime,
                                                    locale: FFLocalizations.of(context).languageCode,
                                                  ),
                                                  maxLines: 1,
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Inter',
                                                        color: FlutterFlowTheme.of(context).border,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            listViewChatsRecord.dealName,
                                            maxLines: 1,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts: false,
                                                lineHeight: 1.05),
                                          ),
                                          if (listViewChatsRecord.lastMessage != null)
                                            FutureBuilder<MessageRecord>(
                                              future: MessageRecord.getDocumentOnce(listViewChatsRecord.lastMessage!),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: Text(
                                                      '...',
                                                      maxLines: 1,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Inter',
                                                            color: FlutterFlowTheme.of(context).hintColor,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts: false,
                                                          ),
                                                    ),
                                                  );
                                                }

                                                final rowMessageRecord = snapshot.data!;

                                                return Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                      child: Icon(
                                                        Icons.lens,
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        size: 8.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      (rowMessageRecord.type == 'text')
                                                          ? rowMessageRecord.message
                                                          : (rowMessageRecord.type == 'file')
                                                              ? FFLocalizations.of(context).getText('gknitk6o2')
                                                              : FFLocalizations.of(context).getText('gknitk6o3'),
                                                      maxLines: 1,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Inter',
                                                            color: FlutterFlowTheme.of(context).hintColor,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts: false,
                                                          ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          else
                                            const SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 0.0,
                                    thickness: 1.0,
                                    color: FlutterFlowTheme.of(context).buttonDisabel,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
