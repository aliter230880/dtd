import 'dart:math';

import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_theme.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DealDocuments extends StatefulWidget {
  final DealsRecord? deal;
  const DealDocuments({super.key, this.deal});

  @override
  State<DealDocuments> createState() => _DealDocumentsState();
}

class _DealDocumentsState extends State<DealDocuments> {
  void onTapFile(String url) async {
    launchURL(url);
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
          FFLocalizations.of(context).getText('documents'),
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
            children: (widget.deal?.files ?? [])
                .map((e) => GestureDetector(onTap: () => onTapFile(e), child: _FileTile(url: e)))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _FileTile extends StatelessWidget {
  final String url;
  const _FileTile({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Center(
              child: SvgPicture.asset('assets/images/file.svg'),
            ),
          ),
          Expanded(
            child: FutureBuilder<FullMetadata>(
                future: getMetadata(url, 0),
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data?.name ?? '...',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Builder(builder: (context) {
                        return Text(
                          getFileSize(snapshot.data),
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Inter',
                                color: const Color(0xFFADADAD),
                                letterSpacing: 0.0,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: false,
                              ),
                        );
                      }),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<FullMetadata> getMetadata(String filepath, int decimals) async {
    final fileRef = FirebaseStorage.instance.refFromURL(filepath);
    final metadate = await fileRef.getMetadata();
    return metadate;
  }

  String getFileSize(FullMetadata? metadate) {
    if (metadate == null) return "...";
    final bytes = metadate.size ?? 0;
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}';
  }
}
