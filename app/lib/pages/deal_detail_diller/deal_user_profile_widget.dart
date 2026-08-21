import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/components/send_complain_bottom_widget.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_theme.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DealUserProfileWidget extends StatefulWidget {
  final DealsRecord? deal;
  final DocumentReference? userRef;
  const DealUserProfileWidget({super.key, required this.deal, required this.userRef});

  @override
  State<DealUserProfileWidget> createState() => _DealUserProfileWidgetState();
}

class _DealUserProfileWidgetState extends State<DealUserProfileWidget> {
  //для жалобы
  void onComplainDeal(UsersRecord user) async {
    final bool result = await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: SendComplainBottomWidget(dealRef: null, user: user),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsersRecord>(
        future: UsersRecord.getDocumentOnce(widget.userRef!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Material(
                color: FlutterFlowTheme.of(context).primaryBackground,
                child: const Center(child: CircularProgressIndicator()));
          }

          final user = snapshot.data!;
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
                FFLocalizations.of(context).getText('d1dmyum3'),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
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
                          onComplainDeal(user);
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
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120.0,
                            height: 120.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFAE28C).withOpacity(0.2),
                            ),
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration: const Duration(milliseconds: 300),
                              imageUrl: user.photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Container(
                                  width: 120.0,
                                  height: 120.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFAE28C).withOpacity(0.2),
                                  ),
                                  child: const CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      user.displayName,
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        user.email,
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
                            ),
                          ],
                        ),
                      ),
                      _UserRaiting(deal: widget.deal, user: user),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _UserRaiting extends StatelessWidget {
  final DealsRecord? deal;
  final UsersRecord user;
  const _UserRaiting({required this.deal, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReviewsRecord>>(
      future: queryReviewsRecordOnce(
        queryBuilder: (reviewsRecord) =>
            reviewsRecord.where('receiver', isEqualTo: user.reference).orderBy('created_time'),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<ReviewsRecord> containerReviewsRecordList = snapshot.data!;
        return Container(
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'hj9lsbje' /* Отзывы */,
                        ),
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
                          child: FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 18.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 8.0, 0.0),
                          child: Text(
                            valueOrDefault<String>(
                              valueOrDefault(user.rate, 0.0).toString(),
                              '0',
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Text(
                          containerReviewsRecordList.isEmpty
                              ? '(нет отзывов)'
                              : '${valueOrDefault<String>(
                                  containerReviewsRecordList.length.toString(),
                                  '0',
                                )} ${getReviewCounterText(context, containerReviewsRecordList.length)}',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Builder(
                  builder: (context) {
                    if (containerReviewsRecordList.isEmpty) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'jt3ud1l1' /* Отзывов пока нет */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).secondary,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 14.0),
                            child: Builder(
                              builder: (context) {
                                final reviewsvar = containerReviewsRecordList.map((e) => e).toList().take(2).toList();
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: reviewsvar.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                                  itemBuilder: (context, reviewsvarIndex) {
                                    final reviewsvarItem = reviewsvar[reviewsvarIndex];
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: FutureBuilder<UsersRecord>(
                                          future: UsersRecord.getDocumentOnce(reviewsvarItem.sender!),
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
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100.0),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration: const Duration(milliseconds: 300),
                                                      fadeOutDuration: const Duration(milliseconds: 300),
                                                      imageUrl: rowUsersRecord.photoUrl,
                                                      width: 30.0,
                                                      height: 30.0,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context, error, stackTrace) => Image.asset(
                                                        'assets/images/error_image.png',
                                                        width: 30.0,
                                                        height: 30.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(
                                                                  0.0, 0.0, 12.0, 0.0),
                                                              child: Text(
                                                                rowUsersRecord.displayName,
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Inter',
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w600,
                                                                      useGoogleFonts: false,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        dateTimeFormat(
                                                          'relative',
                                                          reviewsvarItem.createdTime!,
                                                          locale: FFLocalizations.of(context).languageCode,
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                              fontFamily: 'Inter',
                                                              color: FlutterFlowTheme.of(context).hintColor,
                                                              fontSize: 10.0,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts: false,
                                                            ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                                        child: Text(
                                                          reviewsvarItem.text,
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                fontSize: 12.0,
                                                                letterSpacing: 0.0,
                                                                useGoogleFonts: false,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
