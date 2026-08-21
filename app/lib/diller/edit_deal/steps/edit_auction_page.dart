import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_drop_down.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:auto_deal_app/flutter_flow/form_field_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditDealAuctionPage extends StatefulWidget {
  const EditDealAuctionPage({super.key, required this.deal});

  final DealsRecord? deal;
  @override
  State<EditDealAuctionPage> createState() => _EditDealAuctionPageState();
}

class _EditDealAuctionPageState extends State<EditDealAuctionPage> {
  List<AuctionsRecord> auctons = [];
  AuctionsRecord? selectedAuction;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final result = await queryAuctionsRecordOnce();
    auctons = result;
    selectedAuction = auctons.firstWhereOrNull((element) => element.reference == widget.deal?.auction);
    setState(() {});
  }

  void save() async {
    await widget.deal?.reference.update(createDealsRecordData(auction: selectedAuction?.reference));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = selectedAuction != null;
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
        actions: [
          if (isActive)
            GestureDetector(
              onTap: save,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  FFLocalizations.of(context).getText('i4orpypq'),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        useGoogleFonts: false,
                      ),
                ),
              ),
            ),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  '6cir7a9p' /* Выбор аукциона */,
                ),
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
            if (auctons.isNotEmpty)
              FlutterFlowDropDown<AuctionsRecord>(
                controller: FormFieldController<AuctionsRecord>(selectedAuction),
                options: auctons,
                onChanged: (val) => setState(() {
                  selectedAuction = val;
                }),
                width: double.infinity,
                height: 50.0,
                optionLabels: auctons.map((e) => e.name).toList(),
                searchHintTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintColor,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                searchTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                hintText: FFLocalizations.of(context).getText(
                  'mrtxxggk' /* Выберите аукцион */,
                ),
                searchHintText: FFLocalizations.of(context).getText(
                  'lv6rf6y3' /* Введите название аукциона */,
                ),
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: FlutterFlowTheme.of(context).hintColor,
                  size: 20.0,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 1.0,
                borderColor: Colors.transparent,
                borderWidth: 0.0,
                borderRadius: 12.0,
                margin: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                hidesUnderline: true,
                isOverButton: true,
                isSearchable: false,
                isMultiSelect: false,
              ),
            if (auctons.isEmpty)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
