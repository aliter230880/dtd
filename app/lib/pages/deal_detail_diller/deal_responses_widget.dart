import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/backend/push_notifications/push_notifications_util.dart';
import 'package:auto_deal_app/backend/schema/enums/enums.dart';
import 'package:auto_deal_app/components/select_carrier_modol_bottom.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_theme.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DealResponsesWidget extends StatefulWidget {
  final DealsRecord? deal;
  const DealResponsesWidget({super.key, required this.deal});

  @override
  State<DealResponsesWidget> createState() => _DealResponsesWidgetState();
}

class _DealResponsesWidgetState extends State<DealResponsesWidget> {
  bool loading = false;
  void onReject(ResponseStruct? myResponse) async {
    final data = {
      'carriers': FieldValue.arrayRemove([myResponse?.user]),
    };
    if (myResponse != null) {
      data['responses'] = FieldValue.arrayRemove([myResponse.toMap()]);
    }

    await widget.deal?.reference.update(data);

    setState(() {
      widget.deal?.responses.remove(myResponse);
    });

    NotificationService.onDillerRejectResponse(myResponse!.user!, widget.deal!.reference);
  }

  void onAccept(ResponseStruct? myResponse) async {
    final Map<String, dynamic>? confirmData = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: SelectCarrierBottomWidget(price: myResponse?.responseCost ?? widget.deal?.price ?? 0),
        );
      },
    );
    if (confirmData == null) return;

    final Map<String, dynamic> data = {
      'status': DealStatus.InConfirm.name,
      'carrier': myResponse?.user,
      'price': confirmData['price'],
      'car_number': confirmData['car_number'],
    };
    if (myResponse != null) {
      data['responses'] = FieldValue.arrayRemove([myResponse.toMap()]);
    }

    await widget.deal?.reference.update(data);

    if (mounted) {
      context.pop();
    }

    NotificationService.onDillerAcceptResponse(myResponse!.user!, widget.deal!.reference);
  }

  //для создания чата
  void onOpenChat(ResponseStruct? myResponse) async {
    setState(() {
      loading = true;
    });
    final carrierRef = myResponse?.user;
    late ChatsRecord? chatRecord;
    final users = [carrierRef, currentUserReference];
    final result = await queryChatsRecordOnce(queryBuilder: (q) {
      q = q
          .where('type', isEqualTo: 'chat')
          .where('users', arrayContains: currentUserReference)
          .where('deal_ref', isEqualTo: widget.deal!.reference);

      return q;
    });

    if (result.isNotEmpty) {
      chatRecord = result.first;
    } else {
      //create chat
      final Map<String, dynamic> carrierMap = {
        "user_ref": carrierRef,
        "badge": 0,
        "notification": true,
        "in_room": false,
      };
      final Map<String, dynamic> ownerMap = {
        "user_ref": currentUserReference,
        "badge": 0,
        "notification": true,
        "in_room": false,
      };

      var chatsRecordReference = ChatsRecord.collection.doc();

      final newChatData = {
        'members': FieldValue.arrayUnion([ownerMap, carrierMap]),
        'last_edit_time': FieldValue.serverTimestamp(),
        'created_time': FieldValue.serverTimestamp(),
        'last_message': null,
        'users': FieldValue.arrayUnion(users),
        ...createChatsRecordData(
          dealName: widget.deal?.carName,
          dealRef: widget.deal?.reference,
          type: 'chat',
        )
      };

      await chatsRecordReference.set(newChatData);

      chatRecord = await ChatsRecord.getDocumentOnce(chatsRecordReference);
    }

    if (mounted) {
      setState(() {
        loading = false;
      });

      context.pushNamed(
        'ChatRoomPage',
        queryParameters: {'chat': serializeParam(chatRecord, ParamType.Document)}.withoutNulls,
      );
    }
  }

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
        title: Text(
          FFLocalizations.of(context).getText('responses'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${FFLocalizations.of(context).getText('all')} ${widget.deal?.responses.length ?? 0}',
                      style: FlutterFlowTheme.of(context).bodyMedium),
                ],
              ),
              const SizedBox(height: 14),
              Column(
                children: (widget.deal?.responses ?? []).map((e) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 18),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        FutureBuilder<UsersRecord>(
                            future: UsersRecord.getDocumentOnce(e.user!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final carrier = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    'DealUserProfile',
                                    queryParameters: {
                                      'deal': serializeParam(widget.deal, ParamType.Document),
                                      'userRef': serializeParam(carrier.reference, ParamType.DocumentReference),
                                    }.withoutNulls,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                        child: Container(
                                          width: 60.0,
                                          height: 60.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CachedNetworkImage(
                                            fadeInDuration: const Duration(milliseconds: 300),
                                            fadeOutDuration: const Duration(milliseconds: 300),
                                            imageUrl: carrier.photoUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return const Center(child: CircularProgressIndicator());
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    carrier.displayName,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    FFLocalizations.of(context).getText('61c2q34345fof'),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                  Text(
                                                    widget.deal?.carName ?? '-',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.w600,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 0, bottom: 12),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      FaIcon(
                                                        FontAwesomeIcons.solidStar,
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        size: 16.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                                        child: Text(
                                                          carrier.rate.toString(),
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                letterSpacing: 0.0,
                                                                useGoogleFonts: false,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: const Color(0xFFADADAD)),
                                                  ),
                                                  child: Text(
                                                    currencyFormat.format(e.responseCost),
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: const Color(0xFFADADAD),
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(height: 10),
                        const Divider(height: 0, thickness: 0, color: Color(0xFFE9E9E9)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => onReject(e),
                                child: Text(
                                  FFLocalizations.of(context).getText('reject'),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 26,
                              color: const Color(0xFFE9E9E9),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: ()=> onOpenChat(e),
                                child: Text(
                                  FFLocalizations.of(context).getText('go_to_chat'),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 26,
                              color: const Color(0xFFE9E9E9),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => onAccept(e),
                                child: Text(
                                  FFLocalizations.of(context).getText('accept'),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
