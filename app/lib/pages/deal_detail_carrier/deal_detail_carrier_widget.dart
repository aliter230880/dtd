// ignore_for_file: deprecated_member_use

import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/backend/push_notifications/push_notifications_util.dart';
import 'package:auto_deal_app/components/carrier_deal_status_comp.dart';
import 'package:auto_deal_app/components/deal_complete_success_alert_widget.dart';
import 'package:auto_deal_app/components/end_confirm_deal_alert_widget.dart';
import 'package:auto_deal_app/components/end_confirm_disput_aler_widget.dart';
import 'package:auto_deal_app/components/open_disput_bottom_widget.dart';
import 'package:auto_deal_app/components/send_complain_bottom_widget.dart';
import 'package:auto_deal_app/components/send_review_bottom_widget.dart';
import 'package:auto_deal_app/profile/wallet_page/wallet_page_widget.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/create_deal_free_deal_alert_widget.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/response_deal_bottom_widget.dart';
import '/components/response_success_alert_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'deal_detail_carrier_model.dart';
export 'deal_detail_carrier_model.dart';

class DealDetailCarrierWidget extends StatefulWidget {
  const DealDetailCarrierWidget({
    super.key,
    required this.dealRef,
  });

  final DocumentReference? dealRef;

  @override
  State<DealDetailCarrierWidget> createState() => _DealDetailCarrierWidgetState();
}

class _DealDetailCarrierWidgetState extends State<DealDetailCarrierWidget> {
  late DealDetailCarrierModel _model;
  bool loading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DealDetailCarrierModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'DealDetailCarrier'});

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _onResponseFunc(Future<void> Function() balanceAction, int tokens) async {
    final int? price = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: ResponseDealBottomWidget(tokens: tokens),
        );
      },
    );
    if (price != null) {
      final response = createResponseStruct(
        dealRef: widget.dealRef,
        responseCost: price == 0 ? _model.deal?.price : price,
        time: DateTime.now(),
        user: currentUserReference,
      );

      final data = {
        'responses': FieldValue.arrayUnion([response.toMap()]),
        'carriers': FieldValue.arrayUnion([currentUserReference]),
      };

      await balanceAction();
      await widget.dealRef?.update(data);

      NotificationService.onCarrierResponse(_model.deal!.owner!, widget.dealRef!);
      _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
      if (mounted) {
        setState(() {});
      }

      if (mounted) {
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
              child: const ResponseSuccessAlertWidget(),
            );
          },
        );
      }
    }
  }

  Future<void> _onBalanceAction() async {
    final configRef = FirebaseFirestore.instance.collection('config').doc('configs');
    final configDoc = await configRef.get();
    final configData = configDoc.data() as Map<String, dynamic>;
    final int responseCost = configData['response_cost'] ?? 0;

    final oldBalance = (currentUserDocument?.balance ?? 0);
    final data = createUsersRecordData(
      balance: oldBalance - responseCost.toDouble(),
    );
    await currentUserReference?.update(data);

    await TransactionHelper.createTransactionOnResponse(responseCost);
  }

  Future<void> _onFreeResponseAction() async {
    final data = {'free_response_count': FieldValue.increment(-1)};
    await currentUserReference?.update(data);
  }

  //для отклика на заявку
  void onResponseToDeal() async {
    final int freeResponseCount = currentUserDocument?.freeResponseCount ?? 0;

    //если нет бесплатных откликов, то проверяем баланс
    if (freeResponseCount == 0) {
      final int balance = (currentUserDocument?.balance ?? 0).toInt();
      //если нет баланса, то переходим на пополнение
      if (balance == 0) {
        final confirm = await showDialog(
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                  backgroundColor: Colors.transparent,
                  alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                  child: const NoBalanceForResponseAlert(),
                );
              },
            ) ??
            false;

        if (confirm && mounted) {
          context.pushNamed('WalletPage');
        }
      } else {
        final configRef = FirebaseFirestore.instance.collection('config').doc('configs');
        final configDoc = await configRef.get();
        final configData = configDoc.data() as Map<String, dynamic>;
        final int responseCost = configData['response_cost'] ?? 0;

        if (balance >= responseCost) {
          _onResponseFunc(_onBalanceAction, responseCost);
        } else {
          final confirm = await showDialog(
                context: context,
                builder: (dialogContext) {
                  return Dialog(
                    elevation: 0,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                    backgroundColor: Colors.transparent,
                    alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                    child: const NoBalanceForResponseAlert(),
                  );
                },
              ) ??
              false;

          if (confirm && mounted) {
            context.pushNamed('WalletPage');
          }
        }
      }
    } else {
      final confirm = await showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                backgroundColor: Colors.transparent,
                alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                child: const FreeResponsesAlert(),
              );
            },
          ) ??
          false;

      if (confirm) {
        _onResponseFunc(_onFreeResponseAction, 0);
      }
    }

    return;
  }

  //для отмены отклика
  void onCancelResponseToDeal() async {
    final myResponse = _model.deal!.responses.firstWhereOrNull((r) => r.user == currentUserReference);
    final data = {
      'carriers': FieldValue.arrayRemove([currentUserReference]),
    };
    if (myResponse != null) {
      data['responses'] = FieldValue.arrayRemove([myResponse.toMap()]);
    }
    await widget.dealRef?.update(data);
    _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
    if (mounted) {
      setState(() {});
    }
  }

  //для подтверждения отклика
  void onConfirmResponseToDeal() async {
    final data = {
      'status': DealStatus.InActive.name,
    };

    await widget.dealRef?.update(data);
    _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
    if (mounted) {
      setState(() {});
    }
    NotificationService.onCarrierAcceptDeal(_model.deal!.owner!, _model.deal!.reference);
  }

  //для отклонения отклика
  void onRejectConfirmResponseToDeal() async {
    final data = {
      'carriers': FieldValue.arrayRemove([currentUserReference]),
      'status': DealStatus.InSearch.name,
      'car_number': null,
      'carrier': null,
    };

    await widget.dealRef?.update(data);
    _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
    if (mounted) {
      setState(() {});
    }
    NotificationService.onCarrierRejectDeal(_model.deal!.owner!, _model.deal!.reference);
  }

  //для завершения сделки
  void onCompleteDeal() async {
    if (_model.deal?.status == DealStatus.InActive) {
      final bool confirm = await showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: Colors.transparent,
                alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                child: const EndConfirmDealAlertWidget(),
              );
            },
          ) ??
          false;

      if (confirm) {
        final data = {
          'status': DealStatus.InConfirmComplete.name,
          'completed_by': currentUserReference,
        };
        await widget.dealRef?.update(data);
        _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
        if (mounted) {
          setState(() {});
        }
        NotificationService.onCarrierCompleteDeal(_model.deal!.owner!, _model.deal!.reference);
      }

      if (mounted) {
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
              child: const DealCompleteSuccessAlertWidget(isDiller: false),
            );
          },
        );
      }
    } else {
      final bool confirm = await showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: Colors.transparent,
                alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                child: const EndConfirmDealAlertWidget(),
              );
            },
          ) ??
          false;

      if (confirm) {
        final data = {'status': DealStatus.Completed.name};

         if (_model.deal?.carrier != null) {
          await _model.deal!.carrier?.update({
            "carrier_total_earning": FieldValue.increment(_model.deal?.price ?? 0),
          });
        }

        await widget.dealRef?.update(data);
        _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  //для построения маршрута
  void onCreateMapRoute() async {
    final geo = _model.deal?.location;
    if (geo == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не удалось построить маршрут')));
      return;
    }
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${geo.latitude},${geo.longitude}';
    await launchUrl(Uri.parse(googleUrl));
  }

  //для завершения спора
  void onCompleteDispute() async {
    final bool confirm = await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
              child: const EndConfirmDisputAlerWidget(),
            );
          },
        ) ??
        false;

    if (confirm) {
      final data = {
        'status': DealStatus.InConfirmComplete.name,
        'completed_by': currentUserReference,
        'disput_created_by': null,
      };
      await widget.dealRef?.update(data);
      _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  //для открытия спора
  void onOpenDispute() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: OpenDisputBottomWidget(deal: _model.deal!),
        );
      },
    );
  }

  //для жалобы
  void onComplainDeal() async {
    final bool result = await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
              child: SendComplainBottomWidget(dealRef: widget.dealRef),
            );
          },
        ) ??
        false;

    if (result && mounted) {
      context.safePop();
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: Colors.transparent,
            alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
            child: const SendComplainSuccessAlertWidget(),
          );
        },
      );
    }
  }

  //для создания чата
  void onCreateOpenChat() async {
    setState(() {
      loading = true;
    });
    late ChatsRecord? chatRecord;
    final users = [_model.deal?.owner, currentUserReference];
    final result = await queryChatsRecordOnce(queryBuilder: (q) {
      q = q
          .where('type', isEqualTo: 'chat')
          .where('users', arrayContains: currentUserReference)
          .where('deal_ref', isEqualTo: widget.dealRef);

      return q;
    });

    if (result.isNotEmpty) {
      chatRecord = result.first;
    } else {
      //create chat
      final Map<String, dynamic> ownerMap = {
        "user_ref": _model.deal?.owner,
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
          dealName: _model.deal?.carName,
          dealRef: widget.dealRef,
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

  //для отправки отзыва
  void onSendReview() async {
    final onwer = await UsersRecord.getDocumentOnce(_model.deal!.owner!);
    if (mounted) {
      final DocumentReference? ref = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: SendReviewBottomWidget(user: onwer),
          );
        },
      );

      if (ref != null && mounted) {
        final data = createDealsRecordData(reviewByCarrier: ref);
        await widget.dealRef?.update(data);
        _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_model.deal == null) {
      return Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    bool isPreview =
        _model.deal?.status == DealStatus.InSearch && !(_model.deal?.carriers.contains(currentUserReference) ?? true);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: !isPreview
          ? AppBar(
              backgroundColor: Colors.white,
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarrierDealStatusCompWidget(
                    status: _model.deal!.status!,
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: Icon(
                        Icons.more_vert,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      items: [
                        if (_model.deal?.status == DealStatus.InActive ||
                            _model.deal?.status == DealStatus.InConfirmComplete)
                          DropdownMenuItem(
                            value: 'disput',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText('0xr421z3'),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                  SvgPicture.asset('assets/images/alert-circle.svg'),
                                ],
                              ),
                            ),
                          )
                        else
                          DropdownMenuItem(
                            value: 'complaint',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText('bnrx8tji'),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                  SvgPicture.asset('assets/images/alert-circle.svg'),
                                ],
                              ),
                            ),
                          ),
                      ],
                      onChanged: (value) async {
                        if (value == 'complaint') {
                          onComplainDeal();
                        } else if (value == 'disput') {
                          onOpenDispute();
                        }
                      },
                      dropdownStyleData: DropdownStyleData(
                        width: 228,
                        isOverButton: false,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFE9E9E9),
                        ),
                        offset: const Offset(-191, 0),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 44,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
              centerTitle: true,
              elevation: 0.0,
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isPreview)
              _InSearchSlider(deal: _model.deal, onComplain: onComplainDeal)
            else
              _MainSlider(deal: _model.deal),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 10.0, 24.0, 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPreview)
                    Text(
                      valueOrDefault<String>(_model.deal?.carName, '-'),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    const SizedBox(height: 8),
                  _MainInfoRow(deal: _model.deal, isPreview: isPreview),
                  if (isPreview) _InSearchLocationWidget(deal: _model.deal) else _LocationWidget(deal: _model.deal),
                  _DillerWidget(deal: _model.deal, onTapChat: onCreateOpenChat, loading: loading),
                  _DocumentsWidget(deal: _model.deal, isPreview: isPreview),
                  if (isPreview)
                    //для отклика
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: onResponseToDeal,
                        text: FFLocalizations.of(context).getText('svl0x6kw'),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  if (_model.deal?.status == DealStatus.InSearch &&
                      _model.deal!.carriers.contains(currentUserReference))
                    //для отмены отклика
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: onCancelResponseToDeal,
                        text: FFLocalizations.of(context).getText('cancel_response'),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  if (_model.deal?.status == DealStatus.InConfirm)
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: onRejectConfirmResponseToDeal,
                              text: FFLocalizations.of(context).getText('reject'),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 56.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: onConfirmResponseToDeal,
                              text: FFLocalizations.of(context).getText('accept'),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 56.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_model.deal?.status == DealStatus.InActive)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Column(
                        children: [
                          FFButtonWidget(
                            onPressed: onCreateMapRoute,
                            text: FFLocalizations.of(context).getText('htvzh1i7'),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 56.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FFButtonWidget(
                            onPressed: onCompleteDeal,
                            text: FFLocalizations.of(context).getText('d628bnfz'),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 56.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_model.deal!.status == DealStatus.InConfirmComplete &&
                      _model.deal!.completedBy != currentUserReference)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: onCompleteDeal,
                        text: FFLocalizations.of(context).getText('d628bnfz'),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  if (_model.deal!.status == DealStatus.Completed && _model.deal!.reviewByCarrier == null)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: onSendReview,
                        text: FFLocalizations.of(context).getText('ur0c4uzh'),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  if (_model.deal!.status == DealStatus.Completed && _model.deal!.reviewByCarrier != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText('ur0c4uzh2'),
                            style: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ],
                      ),
                    ),
                  if (_model.deal!.status == DealStatus.InDispute &&
                      _model.deal!.disputCreatedBy == currentUserReference)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: onCompleteDispute,
                        text: FFLocalizations.of(context).getText('end_dispute'),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                          borderRadius: BorderRadius.circular(30.0),
                        ),
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

class _InSearchSlider extends StatefulWidget {
  final DealsRecord? deal;
  final VoidCallback onComplain;
  const _InSearchSlider({this.deal, required this.onComplain});

  @override
  State<_InSearchSlider> createState() => _InSearchSliderState();
}

class _InSearchSliderState extends State<_InSearchSlider> {
  int carouselCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final imagesVar = widget.deal?.carPhotos ?? [];
        return SizedBox(
          width: double.infinity,
          height: 280.0,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider.builder(
                itemCount: imagesVar.length,
                itemBuilder: (context, imagesVarIndex, _) {
                  final imagesVarItem = imagesVar[imagesVarIndex];
                  return CachedNetworkImage(
                    imageUrl: imagesVarItem,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                },
                carouselController: CarouselController(),
                options: CarouselOptions(
                  height: 280,
                  initialPage: max(0, min(0, imagesVar.length - 1)),
                  viewportFraction: 1.0,
                  disableCenter: true,
                  enlargeCenterPage: false,
                  enlargeFactor: 0.0,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, _) {
                    setState(() {
                      carouselCurrentIndex = index;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imagesVar.map((e) {
                    final index = imagesVar.indexOf(e);
                    return Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 18),
                      child: Icon(Icons.lens,
                          size: 10,
                          color:
                              index == carouselCurrentIndex ? Colors.white : const Color(0xFFFEFEFE).withOpacity(0.3)),
                    );
                  }).toList(),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30.0,
                        borderWidth: 1.0,
                        buttonSize: 60.0,
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 20.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Icon(
                            Icons.more_vert,
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            size: 24.0,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'complaint',
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText('bnrx8tji'),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    SvgPicture.asset('assets/images/alert-circle.svg'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) async {
                            if (value == 'complaint') {
                              widget.onComplain();
                            }
                          },
                          dropdownStyleData: DropdownStyleData(
                            width: 228,
                            isOverButton: false,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFE9E9E9),
                            ),
                            offset: const Offset(-191, 0),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 44,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MainSlider extends StatefulWidget {
  final DealsRecord? deal;
  const _MainSlider({this.deal});

  @override
  State<_MainSlider> createState() => __MainSliderState();
}

class __MainSliderState extends State<_MainSlider> {
  int carouselCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final imagesVar = widget.deal?.carPhotos ?? [];
        return SizedBox(
          width: double.infinity,
          height: 280.0,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider.builder(
                itemCount: imagesVar.length,
                itemBuilder: (context, imagesVarIndex, _) {
                  final imagesVarItem = imagesVar[imagesVarIndex];
                  return CachedNetworkImage(
                    imageUrl: imagesVarItem,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                },
                carouselController: CarouselController(),
                options: CarouselOptions(
                  height: 280,
                  initialPage: max(0, min(0, imagesVar.length - 1)),
                  viewportFraction: 1.0,
                  disableCenter: true,
                  enlargeCenterPage: false,
                  enlargeFactor: 0.0,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, _) {
                    setState(() {
                      carouselCurrentIndex = index;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imagesVar.map((e) {
                    final index = imagesVar.indexOf(e);
                    return Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 18),
                      child: Icon(Icons.lens,
                          size: 10,
                          color:
                              index == carouselCurrentIndex ? Colors.white : const Color(0xFFFEFEFE).withOpacity(0.3)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MainInfoRow extends StatelessWidget {
  final DealsRecord? deal;
  final bool isPreview;
  const _MainInfoRow({this.deal, this.isPreview = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          //price
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: Container(
                width: double.infinity,
                height: 56.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 3.0),
                      child: Text(
                        currencyFormat.format(deal?.price ?? 0),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'nedm0qh9' /* Цена */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondary,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //date
          Expanded(
            child: Container(
              width: double.infinity,
              height: 56.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 3.0),
                    child: Text(
                      dateTimeFormat(
                        'dd.MM.yy',
                        deal!.dealDate!,
                        locale: FFLocalizations.of(context).languageCode,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'am35vsuv' /* Срок исполнения */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondary,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (!isPreview)
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: GeoUtil.getDistance(deal?.location),
                        builder: (context, snapshot) {
                          final dist = snapshot.data;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              dist == null ? '-' : '${snapshot.data} ${FFLocalizations.of(context).getText('km')}',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          );
                        },
                      ),
                      Text(
                        FFLocalizations.of(context).getText(
                          '79f6biyf' /* Расстояние */,
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondary,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InSearchLocationWidget extends StatelessWidget {
  final DealsRecord? deal;
  const _InSearchLocationWidget({this.deal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText(
              'ljobcg24' /* Местоположение */,
            ),
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  useGoogleFonts: false,
                ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                deal?.locationAddress,
                '-',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              maxLines: 6,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await launchMap(
                  location: deal?.location,
                  title: 'Маршрут до цели',
                );
              },
              child: Text(
                FFLocalizations.of(context).getText(
                  'htvzh1i7' /* Построить маршрут */,
                ),
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondary,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.underline,
                  decorationColor: FlutterFlowTheme.of(context).secondary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FFLocalizations.of(context).getText(
                    '5vc1l2lf' /* Описание заказа */,
                  ),
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: false,
                      ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: ReadMoreText(
                    valueOrDefault<String>(deal?.description, '-'),
                    trimMode: TrimMode.Line,
                    trimLines: 4,
                    colorClickableText: FlutterFlowTheme.of(context).primary,
                    trimCollapsedText: FFLocalizations.of(context).getText('show_more'),
                    trimExpandedText: FFLocalizations.of(context).getText('show_less'),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                    moreStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                    lessStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primaryText,
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

class _LocationWidget extends StatelessWidget {
  final DealsRecord? deal;
  const _LocationWidget({this.deal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deal?.locationAddress ?? '-',
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  useGoogleFonts: false,
                ),
          ),
          if (deal?.carNumber != '')
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(
                    'assets/images/deal_tab.svg',
                    width: 18.0,
                    height: 18.0,
                    fit: BoxFit.contain,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      deal?.carNumber ?? '-',
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
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  'assets/images/wallet.svg',
                  width: 16.0,
                  height: 16.0,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      deal?.payType == 'cash' ? 'lrpkz4z3' : "ypf67ehe",
                    ),
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
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FFLocalizations.of(context).getText(
                    '5vc1l2lf' /* Описание заказа */,
                  ),
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: false,
                      ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: ReadMoreText(
                    valueOrDefault<String>(deal?.description, '-'),
                    trimMode: TrimMode.Line,
                    trimLines: 4,
                    colorClickableText: FlutterFlowTheme.of(context).primary,
                    trimCollapsedText: FFLocalizations.of(context).getText('show_more'),
                    trimExpandedText: FFLocalizations.of(context).getText('show_less'),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                    moreStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                    lessStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primaryText,
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

class _DillerWidget extends StatelessWidget {
  final DealsRecord? deal;
  final VoidCallback onTapChat;
  final bool loading;
  const _DillerWidget({this.deal, required this.onTapChat, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FFLocalizations.of(context).getText('w7p1ksui'),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts: false,
                    ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: FutureBuilder<UsersRecord>(
              future: UsersRecord.getDocumentOnce(deal!.owner!),
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
                final rowUsersRecord = snapshot.data!;
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    context.pushNamed(
                      'DealUserProfile',
                      queryParameters: {
                        'deal': serializeParam(rowUsersRecord, ParamType.Document),
                        'userRef': serializeParam(deal?.owner, ParamType.DocumentReference),
                      }.withoutNulls,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeOutDuration: const Duration(milliseconds: 500),
                          imageUrl: rowUsersRecord.photoUrl,
                          placeholder: (context, url) {
                            return const Center(child: CircularProgressIndicator());
                          },
                          width: 68.0,
                          height: 68.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rowUsersRecord.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              Text(
                                rowUsersRecord.dillerLicense,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).secondary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.solidStar,
                                      color: FlutterFlowTheme.of(context).primary,
                                      size: 16.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        rowUsersRecord.rate == 0 ? '0' : rowUsersRecord.rate.toStringAsFixed(1),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          '(${rowUsersRecord.rateCount} ${getReviewCounterText(context, rowUsersRecord.rateCount)})',
                                          maxLines: 1,
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
                            ],
                          ),
                        ),
                      ),
                      if (loading)
                        const SizedBox(width: 24, height: 24, child: Center(child: CircularProgressIndicator()))
                      else
                        GestureDetector(
                          onTap: onTapChat,
                          child: SvgPicture.asset(
                            'assets/images/mail.svg',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentsWidget extends StatelessWidget {
  final DealsRecord? deal;
  final bool isPreview;
  const _DocumentsWidget({this.deal, this.isPreview = true});

  @override
  Widget build(BuildContext context) {
    if (isPreview) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FFLocalizations.of(context).getText(
                'm5momf7w' /* Способ оплаты */,
              ),
              style: FlutterFlowTheme.of(context).labelLarge.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: false,
                  ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(
                    'assets/images/wallet.svg',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        deal?.payType == 'cash' ? 'lrpkz4z3' : "ypf67ehe",
                      ),
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
    if (deal?.status == DealStatus.InActive ||
        deal?.status == DealStatus.InDispute ||
        deal?.status == DealStatus.InConfirmComplete) {
      return Padding(
        padding: const EdgeInsets.only(top: 18),
        child: SizedBox(
          height: 52,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              context.pushNamed(
                'DealDocuments',
                queryParameters: {
                  'deal': serializeParam(deal, ParamType.Document),
                }.withoutNulls,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${FFLocalizations.of(context).getText('documents')} (${deal?.files.length ?? 0})',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: false,
                      ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
