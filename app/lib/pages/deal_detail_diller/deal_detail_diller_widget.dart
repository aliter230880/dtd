// ignore_for_file: deprecated_member_use

import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/backend/push_notifications/push_notifications_util.dart';
import 'package:auto_deal_app/backend/schema/enums/enums.dart';
import 'package:auto_deal_app/components/cancel_deal_alert_widget.dart';
import 'package:auto_deal_app/components/deal_canceled_alert_widget.dart';
import 'package:auto_deal_app/components/deal_complete_success_alert_widget.dart';
import 'package:auto_deal_app/components/end_confirm_disput_aler_widget.dart';
import 'package:auto_deal_app/components/send_review_bottom_widget.dart';
import 'package:auto_deal_app/diller/create_deal_page/create_deal_page_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';

import '/backend/backend.dart';
import '/components/diller_deal_status_comp_widget.dart';
import '/components/end_confirm_deal_alert_widget.dart';
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
import 'deal_detail_diller_model.dart';
export 'deal_detail_diller_model.dart';

class DealDetailDillerWidget extends StatefulWidget {
  const DealDetailDillerWidget({
    super.key,
    required this.dealRef,
  });

  final DocumentReference? dealRef;

  @override
  State<DealDetailDillerWidget> createState() => _DealDetailDillerWidgetState();
}

class _DealDetailDillerWidgetState extends State<DealDetailDillerWidget> {
  late DealDetailDillerModel _model;
  bool loading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DealDetailDillerModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'DealDetailDiller'});
    // On page load action.
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
        NotificationService.onDillerCompleteDeal(_model.deal!.carrier!, _model.deal!.reference);
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
              child: const DealCompleteSuccessAlertWidget(isDiller: true),
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

  void onSendReview() async {
    final carrier = await UsersRecord.getDocumentOnce(_model.deal!.carrier!);
    if (mounted) {
      final DocumentReference? ref = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: SendReviewBottomWidget(user: carrier),
          );
        },
      );

      if (ref != null && mounted) {
        final data = createDealsRecordData(reviewByDiller: ref);
        await widget.dealRef?.update(data);
        _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void onCancelDeal() async {
    bool confirm = await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
              child: const CancelDealAlertWidget(),
            );
          },
        ) ??
        false;

    if (confirm && mounted) {
      final data = {
        'status': DealStatus.Canceled.name,
        'carriers': null,
        'carrier': null,
      };

      await widget.dealRef?.update(data);
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
              child: const DealCanceledAlertWidget(),
            );
          },
        );
      }
    }
  }

  void onRequestLocation() async {
    final data = createDealsRecordData(geoRequestDate: DateTime.now());
    await widget.dealRef?.update(data);
    _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
    if (mounted) {
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    if (_model.deal == null) {
      return Container(
          constraints: const BoxConstraints.expand(),
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
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
            wrapWithModel(
              model: _model.dillerDealStatusCompModel,
              updateCallback: () => setState(() {}),
              child: DillerDealStatusCompWidget(
                status: _model.deal!.status!,
              ),
            ),
          ],
        ),
        actions: [
          if (_model.deal?.status != DealStatus.Completed && _model.deal?.status != DealStatus.Canceled)
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: Icon(
                    Icons.more_vert,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'edit',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText('edit'),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                            SvgPicture.asset('assets/images/edit.svg'),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem<Divider>(
                      enabled: false,
                      child: Divider(color: const Color(0xFF111111).withOpacity(0.25), height: 0, thickness: 1),
                    ),
                    if (_model.deal?.status == DealStatus.InActive)
                      DropdownMenuItem(
                        value: 'disput',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText('cancel_deal'),
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
                    if (_model.deal?.status == DealStatus.InActive)
                      DropdownMenuItem<Divider>(
                        enabled: false,
                        child: Divider(color: const Color(0xFF111111).withOpacity(0.25), height: 0, thickness: 1),
                      ),
                    DropdownMenuItem(
                      value: 'cancel',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText('cancel_deal'),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                            SvgPicture.asset('assets/images/Delete.svg'),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value == 'edit') {
                      context.pushNamed(
                        'EditDeal',
                        queryParameters: {
                          'deal': serializeParam(_model.deal!, ParamType.Document),
                        }.withoutNulls,
                      );
                    } else if (value == 'cancel') {
                      onCancelDeal();
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
                  menuItemStyleData: MenuItemStyleData(
                    customHeights: (_model.deal?.status == DealStatus.InActive) ? [44, 1, 44, 1, 44] : [44, 1, 44],
                    height: 44,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 36),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //slider
              Builder(
                builder: (context) {
                  final imagesVar = _model.deal!.carPhotos;
                  return SizedBox(
                    width: double.infinity,
                    height: 240.0,
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
                          carouselController: _model.carouselController ??= CarouselController(),
                          options: CarouselOptions(
                            height: 240,
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
                                _model.carouselCurrentIndex = index;
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
                                    color: index == _model.carouselCurrentIndex
                                        ? Colors.white
                                        : const Color(0xFFFEFEFE).withOpacity(0.3)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 30.0, 24.0, 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //price
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
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
                                      currencyFormatter.formatString(_model.deal!.price.toString()),
                                      // formatNumber(
                                      //   _model.deal!.price,
                                      //   formatType: FormatType.custom,
                                      //   currency: '\$',
                                      //   format: '',
                                      //   locale: 'ru',
                                      // ),
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
                                      'p761qnat' /* Цена */,
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
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
                                        _model.deal!.dealDate!,
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
                                      'enf40y4g' /* Срок исполнения */,
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
                      ],
                    ),
                    //adress
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              _model.deal?.locationAddress,
                              '-',
                            ),
                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: false,
                                ),
                          ),
                          //car number
                          if (_model.deal!.status == DealStatus.InActive)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
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
                                      FFLocalizations.of(context).getText(
                                        's1rbxyrb' /* 4567АА */,
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
                          //paytype
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
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
                                      _model.deal?.payType == 'cash' ? 'lrpkz4z3' : "ypf67ehe",
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
                    ),
                    //description
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'm5i0oitl' /* Описание заказа */,
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
                              valueOrDefault<String>(
                                _model.deal?.description,
                                '-',
                              ),
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
                    if (_model.deal?.carrier != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'h002oe0y' /* Исполнитель */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                if (_model.deal?.status == DealStatus.InActive && _model.deal?.requestLocation == null)
                                  GestureDetector(
                                    onTap: () {
                                      if (_model.deal?.geoRequestDate == null) {
                                        onRequestLocation();
                                      }
                                    },
                                    child: Text(
                                        FFLocalizations.of(context).getText(
                                          _model.deal?.geoRequestDate == null ? 'qvsmobpy' : 'qvsmobpy2',
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).secondary,
                                          letterSpacing: 0.0,
                                          decoration: _model.deal?.geoRequestDate == null
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          decorationColor: FlutterFlowTheme.of(context).secondary,
                                        )),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                              child: FutureBuilder<UsersRecord>(
                                future: UsersRecord.getDocumentOnce(_model.deal!.carrier!),
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
                                          'deal': serializeParam(_model.deal, ParamType.Document),
                                          'userRef': serializeParam(_model.deal?.carrier, ParamType.DocumentReference),
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
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Inter',
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
                                                        padding:
                                                            const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                                        child: Text(
                                                          rowUsersRecord.rate.toStringAsFixed(1),
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                letterSpacing: 0.0,
                                                                useGoogleFonts: false,
                                                              ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
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
                                          const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Center(child: CircularProgressIndicator()),
                                          )
                                        else
                                          GestureDetector(
                                            onTap: onCreateOpenChat,
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
                            // const Padding(
                            //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                            //   child: FlutterFlowStaticMap(
                            //     location: LatLng(9.341465, -79.891704),
                            //     apiKey: '111',
                            //     style: mapbox.MapBoxStyle.Light,
                            //     width: double.infinity,
                            //     height: 145.0,
                            //     fit: BoxFit.contain,
                            //     borderRadius: BorderRadius.only(
                            //       bottomLeft: Radius.circular(0.0),
                            //       bottomRight: Radius.circular(0.0),
                            //       topLeft: Radius.circular(0.0),
                            //       topRight: Radius.circular(0.0),
                            //     ),
                            //     zoom: 12,
                            //     tilt: 0,
                            //     rotation: 0,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    if (_model.deal?.carrier == null)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: GestureDetector(
                          onTap: () async {
                            if (_model.deal!.responses.isNotEmpty) {
                              await context.pushNamed(
                                'DealResponses',
                                queryParameters: {
                                  'deal': serializeParam(_model.deal, ParamType.Document),
                                }.withoutNulls,
                              );
                              if (mounted) {
                                _model.deal = await DealsRecord.getDocumentOnce(widget.dealRef!);
                                setState(() {});
                              }
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  '${FFLocalizations.of(context).getText(_model.deal!.responses.isEmpty ? 'no_responses' : 'responses')} ${_model.deal!.responses.isEmpty ? "" : "(${_model.deal!.responses.length})"}',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ),
                              if (_model.deal!.responses.isNotEmpty)
                                FaIcon(
                                  FontAwesomeIcons.angleRight,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 16.0,
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (_model.deal?.carrier == null)
                      const Divider(
                        thickness: 1.0,
                        color: Color(0xFFE9E9E9),
                      )
                    else
                      const SizedBox(height: 24),

                    if (_model.deal?.requestLocation != null)
                      Text(
                        '${_model.deal?.requestLocation?.latitude} - ${_model.deal?.requestLocation?.longitude}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                      ),

                    if (_model.deal!.files.isNotEmpty)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.pushNamed(
                            'DealDocuments',
                            queryParameters: {
                              'deal': serializeParam(_model.deal, ParamType.Document),
                            }.withoutNulls,
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                'Документы (${_model.deal?.files.length.toString()})',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                            if (_model.deal!.responses.isNotEmpty)
                              FaIcon(
                                FontAwesomeIcons.angleRight,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 16.0,
                              ),
                          ],
                        ),
                      ),

                    if (_model.deal!.status == DealStatus.InActive)
                      Builder(
                        builder: (context) => Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: onCompleteDeal,
                            text: FFLocalizations.of(context).getText(
                              'd628bnfz' /* Завершить заказ */,
                            ),
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
                      ),

                    if (_model.deal!.status == DealStatus.InConfirmComplete &&
                        _model.deal!.completedBy != currentUserReference)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: onCompleteDeal,
                          text: FFLocalizations.of(context).getText(
                            'd628bnfz' /* Завершить заказ */,
                          ),
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

                    if (_model.deal!.status == DealStatus.Completed && _model.deal!.reviewByDiller == null)
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
                    if (_model.deal!.status == DealStatus.Completed && _model.deal!.reviewByDiller != null)
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
      ),
    );
  }
}
