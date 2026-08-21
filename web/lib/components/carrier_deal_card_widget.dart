import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/backend/schema/enums/enums.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/backend/backend.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'carrier_deal_card_model.dart';
import 'carrier_deal_status_comp.dart';
export 'carrier_deal_card_model.dart';

class CarrierDealCardWidget extends StatefulWidget {
  const CarrierDealCardWidget({
    super.key,
    required this.deal,
    this.width = double.infinity,
  });

  final DealsRecord? deal;
  final double width;

  @override
  State<CarrierDealCardWidget> createState() => _CarrierDealCardWidgetState();
}

class _CarrierDealCardWidgetState extends State<CarrierDealCardWidget> {
  late CarrierDealCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarrierDealCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 18),
     width: widget.width,
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
      child: (widget.deal?.status == DealStatus.InConfirm)
          ? _NeedConfirmCard(deal: widget.deal)
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //main info
                _MainInfo(deal: widget.deal),
                //location and time
                _LocationAndTime(deal: widget.deal),
                //status
                _Status(deal: widget.deal),
              ],
            ),
    );
  }
}

class _MainInfo extends StatelessWidget {
  final DealsRecord? deal;
  const _MainInfo({this.deal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 18.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 300),
              imageUrl: deal?.carPhotos.first ?? '',
              width: 68.0,
              height: 68.0,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) => Image.asset(
                'assets/images/error_image.png',
                width: 68.0,
                height: 68.0,
                fit: BoxFit.cover,
              ),
              placeholder: (context, url) {
                return const Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()));
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    valueOrDefault<String>(
                      deal?.carName,
                      '-',
                    ),
                    maxLines: 2,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(deal?.price ?? 0),
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                      FutureBuilder(
                        future: GeoUtil.getDistance(deal?.location),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '${snapshot.data} ${FFLocalizations.of(context).getText('km')}',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationAndTime extends StatelessWidget {
  final DealsRecord? deal;
  const _LocationAndTime({this.deal});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/images/gps.svg',
                width: 16.0,
                height: 16.0,
                fit: BoxFit.none,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Text(
                    valueOrDefault<String>(
                      deal?.locationAddress,
                      '-',
                    ),
                    maxLines: 2,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.access_time_sharp,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 16.0,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  dateTimeFormat(
                    'MMMMd',
                    deal?.dealDate,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                  '-',
                ),
                maxLines: 2,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Status extends StatelessWidget {
  final DealsRecord? deal;
  const _Status({this.deal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CarrierDealStatusCompWidget(
            status: deal!.status!,
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                  child: Container(
                    width: 28.0,
                    height: 28.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 300),
                      imageUrl: currentUserPhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    currentUserDisplayName,
                    maxLines: 1,
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
        ],
      ),
    );
  }
}

class _NeedConfirmCard extends StatelessWidget {
  final DealsRecord? deal;
  const _NeedConfirmCard({this.deal});

  //для подтверждения отклика
  void onCreateChat(BuildContext context) async {
    late ChatsRecord? chatRecord;
    final users = [deal?.owner, currentUserReference];
    final result = await queryChatsRecordOnce(queryBuilder: (q) {
      q = q
          .where('type', isEqualTo: 'chat')
          .where('users', arrayContains: currentUserReference)
          .where('deal_ref', isEqualTo: deal?.reference);

      return q;
    });

    if (result.isNotEmpty) {
      chatRecord = result.first;
    } else {
      //create chat
      final Map<String, dynamic> ownerMap = {
        "user_ref": deal?.owner,
        "badge": 0,
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

      final newChatData = {
        'members': FieldValue.arrayUnion([ownerMap, carrierMap]),
        'last_edit_time': FieldValue.serverTimestamp(),
        'created_time': FieldValue.serverTimestamp(),
        'last_message': null,
        'users': FieldValue.arrayUnion(users),
        ...createChatsRecordData(
          dealName: deal?.carName,
          dealRef: deal?.reference,
          type: 'chat',
        )
      };

      await chatsRecordReference.set(newChatData);

      chatRecord = await ChatsRecord.getDocumentOnce(chatsRecordReference);
    }

    if (context.mounted) {
      context.pushNamed(
        'ChatRoomPage',
        queryParameters: {'chat': serializeParam(chatRecord, ParamType.Document)}.withoutNulls,
      );
    }
  }

  //для подтверждения отклика
  void onConfirmResponseToDeal(BuildContext context) async {
    final data = {
      'status': DealStatus.InActive.name,
    };

    await deal?.reference.update(data);

    if (context.mounted) {
      context.pop();
    }
  }

  //для отклонения отклика
  void onRejectConfirmResponseToDeal(BuildContext context) async {
    final data = {
      'carriers': FieldValue.arrayRemove([currentUserReference]),
      'status': DealStatus.InSearch.name,
      'car_number': null,
      'carrier': null,
    };

    await deal?.reference.update(data);

    if (context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<UsersRecord>(
            future: UsersRecord.getDocumentOnce(deal!.owner!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final owner = snapshot.data!;
              return Padding(
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
                          imageUrl: owner.photoUrl,
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
                                  owner.displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                Text(
                                  '2 мин назад',
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        fontSize: 10,
                                        color: const Color(0xFFADADAD),
                                        useGoogleFonts: false,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  FFLocalizations.of(context).getText('asdasd3g'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                Text(
                                  deal?.carName ?? '-',
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
                                padding: const EdgeInsets.only(top: 5, bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.solidStar,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 16.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        owner.rate.toString(),
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
                                  currencyFormat.format(deal?.price ?? 0),
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
              );
            }),
        const SizedBox(height: 10),
        const Divider(height: 0, thickness: 0, color: Color(0xFFE9E9E9)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onRejectConfirmResponseToDeal(context),
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
                onTap: () => onCreateChat(context),
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
                onTap: () => onConfirmResponseToDeal(context),
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
    );
  }
}
