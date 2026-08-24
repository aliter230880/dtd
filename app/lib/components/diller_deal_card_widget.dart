import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/diller_deal_status_comp_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'diller_deal_card_model.dart';
export 'diller_deal_card_model.dart';

class DillerDealCardWidget extends StatefulWidget {
  const DillerDealCardWidget({
    super.key,
    required this.deal,
    this.width = double.infinity,
  });

  final DealsRecord deal;
  final double width;

  @override
  State<DillerDealCardWidget> createState() => _DillerDealCardWidgetState();
}

class _DillerDealCardWidgetState extends State<DillerDealCardWidget> {
  late DillerDealCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DillerDealCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
      child: InkWell(
        onTap: () {
          if (widget.deal.carrier == currentUserReference) {
            context.pushNamed(
              'DealDetailCarrier',
              queryParameters: {
                'dealRef': serializeParam(
                  widget.deal.reference,
                  ParamType.DocumentReference,
                ),
              }.withoutNulls,
            );
          } else {
            context.pushNamed(
              'DealDetailDiller',
              queryParameters: {
                'dealRef': serializeParam(
                  widget.deal.reference,
                  ParamType.DocumentReference,
                ),
              }.withoutNulls,
            );
          }
        },
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //main info
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
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
                          imageUrl: widget.deal.carPhotos.first,
                          width: 68.0,
                          height: 68.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const SizedBox(
                                width: 40,
                                height: 40,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ));
                          },
                          errorWidget: (context, error, stackTrace) => Image.asset(
                            'assets/images/error_image.png',
                            width: 68.0,
                            height: 68.0,
                            fit: BoxFit.cover,
                          ),
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
                                valueOrDefault<String>(widget.deal.carName, '-'),
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
                                    currencyFormat.format(widget.deal.price),
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                  if (widget.deal.insuranceRequired == true)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4CAF50),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '🛡️ Застраховано',
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                fontSize: 11.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ),
                                  FutureBuilder<UsersRecord>(
                                    future: UsersRecord.getDocumentOnce(widget.deal.owner!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData && snapshot.data?.verified == true) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '✓ Проверен',
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    fontFamily: 'Inter',
                                                    color: Colors.white,
                                                    fontSize: 11.0,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
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
                ),
              ),
              //location
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SvgPicture.asset(
                              'assets/images/gps.svg',
                              width: 16.0,
                              height: 16.0,
                              fit: BoxFit.none,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                              child: Text(
                                valueOrDefault<String>(
                                  widget.deal.locationAddress,
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
                                widget.deal.dealDate,
                                locale: FFLocalizations.of(context).languageCode,
                              ),
                              '-',
                            ),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                      child: wrapWithModel(
                        model: _model.dillerDealStatusCompModel,
                        updateCallback: () => setState(() {}),
                        child: DillerDealStatusCompWidget(
                          status: widget.deal.status!,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (widget.deal.status == DealStatus.InSearch) {
                            return Text(
                              '${widget.deal.responses.length} откликов',
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    decoration: TextDecoration.underline,
                                    useGoogleFonts: false,
                                  ),
                            );
                          } else if (widget.deal.status == DealStatus.Canceled ||
                              widget.deal.status == DealStatus.CanceledByAdmin) {
                            return Text(
                              FFLocalizations.of(context).getText(
                                'juonngii' /* Отменён */,
                              ),
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            );
                          } else {
                            if (widget.deal.carrier != null) {
                              return FutureBuilder<UsersRecord>(
                                  future: UsersRecord.getDocumentOnce(widget.deal.carrier!),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    final user = snapshot.data!;
                                    return Row(
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
                                              imageUrl: user.photoUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            user.displayName,
                                            maxLines: 1,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: false,
                                                ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }
                            {
                              return const SizedBox();
                            }
                          }
                        },
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
