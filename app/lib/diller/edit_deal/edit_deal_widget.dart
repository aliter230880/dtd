import 'package:auto_deal_app/diller/create_deal_page/create_deal_page_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';
import '../../flutter_flow/upload_data.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'edit_deal_model.dart';
export 'edit_deal_model.dart';

class EditDealWidget extends StatefulWidget {
  const EditDealWidget({
    super.key,
    required this.deal,
  });

  final DealsRecord? deal;

  @override
  State<EditDealWidget> createState() => _EditDealWidgetState();
}

class _EditDealWidgetState extends State<EditDealWidget> {
  late EditDealModel _model;
  int loadingIndex = -1;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditDealModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'EditDeal'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String formatDate(DateTime? d) {
    if (d == null) return '-';
    final locale = FFLocalizations.of(context).languageCode;
    return DateFormat('dd MMMM', locale).format(d);
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          FFLocalizations.of(context).getText('edit_deal_title'),
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
      body: widget.deal == null
          ? const SizedBox()
          : StreamBuilder<DealsRecord>(
              stream: DealsRecord.getDocument(widget.deal!.reference),
              initialData: widget.deal,
              builder: (context, snapshot) {
                final deal = snapshot.data;
                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText('edit'),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          letterSpacing: 0.0,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        CupertinoIcons.chevron_right,
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('EditDealName', extra: {'deal': deal});
                                },
                                child: _Tile(title: 'k5v6aa9r', subtitle: deal?.carName ?? '-'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('EditDealDesc', extra: {'deal': deal});
                                },
                                child: _Tile(title: 'hvjdr22h', subtitle: deal?.description ?? '-'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('EditDealAddress', extra: {'deal': deal});
                                },
                                child: _Tile(title: '772fktfe', subtitle: deal?.locationAddress ?? '-'),
                              ),
                              if (widget.deal?.auction != null)
                                FutureBuilder<AuctionsRecord>(
                                  future: AuctionsRecord.getDocumentOnce(deal!.auction!),
                                  builder: (context, snapshot) {
                                    final auction = snapshot.data;
                                    return GestureDetector(
                                      onTap: () {
                                        context.pushNamed('EditDealAuction', extra: {'deal': deal});
                                      },
                                      child: _Tile(title: 'xf0jdmda', subtitle: auction?.name ?? '...'),
                                    );
                                  },
                                ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('EditDealDeadline', extra: {'deal': deal});
                                },
                                child: _Tile(title: 'gf191p0n2', subtitle: formatDate(deal?.dealDate)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('EditDealPrice', extra: {'deal': deal});
                                },
                                child: _Tile(
                                    title: 'bzpqc8mq',
                                    subtitle: deal?.price != null
                                        ? currencyFormatter.formatDouble((deal!.price).toDouble())
                                        : '-'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('EditDealPayType', extra: {'deal': deal});
                                },
                                child: _Tile(
                                  title: '5w6uhdnu2',
                                  subtitle: deal?.payType == 'cash'
                                      ? FFLocalizations.of(context).getText('lrpkz4z3')
                                      : FFLocalizations.of(context).getText('hosr19li'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('EditDealFiles', extra: {'deal': deal});
                                },
                                child: _Tile(title: 'files', subtitle: deal?.files.length.toString() ?? '0'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 16.0),
                          child: Text(
                            FFLocalizations.of(context).getText('c7d8b4vr2'),
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 30.0),
                          child: Builder(
                            builder: (context) {
                              // final photos = FFAppState().createDealCarPhotos.map((e) => e).toList();
                              final photos = deal?.carPhotos ?? [];
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.0,
                                ),
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: 9,
                                itemBuilder: (context, photosIndex) {
                                  final photosItem = photos.length > photosIndex ? photos[photosIndex] : null;
                                  return Builder(
                                    builder: (context) {
                                      if (photosItem == null) {
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (loadingIndex != -1) return;
                                            final selectedMedia = await selectMediaWithSourceBottomSheet(
                                              context: context,
                                              imageQuality: 50,
                                              allowPhoto: true,
                                              includeDimensions: true,
                                            );
                                            if (selectedMedia != null && selectedMedia.isNotEmpty) {
                                              setState(() {
                                                loadingIndex = photosIndex;
                                              });
                                              final selected = selectedMedia.first;
                                              final path = getStoragePath(
                                                currentUserUid,
                                                'deal_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
                                                false,
                                              );
                                              final String? url = await uploadData(path, selected.bytes);
                                              if (url != null) {
                                                final data = {
                                                  "car_photos": FieldValue.arrayUnion([url])
                                                };

                                                await deal?.reference.update(data);
                                              }

                                              setState(() {
                                                loadingIndex = -1;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primary,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: loadingIndex == photosIndex
                                                ? const Center(child: CircularProgressIndicator())
                                                : Icon(
                                                    Icons.add_rounded,
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    size: 40.0,
                                                  ),
                                          ),
                                        );
                                      } else {
                                        return Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: CachedNetworkImage(
                                                imageUrl: photosItem,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) {
                                                  return const Center(child: CircularProgressIndicator());
                                                },
                                              ),
                                            ),
                                            Align(
                                              alignment: const AlignmentDirectional(1.0, -1.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () async {
                                                  if (loadingIndex != -1) return;
                                                  final data = {
                                                    "car_photos": FieldValue.arrayRemove([photosItem])
                                                  };

                                                  await deal?.reference.update(data);
                                                },
                                                child: Icon(
                                                  Icons.clear_rounded,
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final String subtitle;
  const _Tile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${FFLocalizations.of(context).getText(title)}:  ',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: const Color(0xFFADADAD),
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          Flexible(
            child: Text(
              subtitle,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
