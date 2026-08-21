import 'dart:async';

import 'package:auto_deal_app/backend/backend.dart';

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_deal4_comp_model.dart';
export 'create_deal4_comp_model.dart';

class CreateDeal4CompWidget extends StatefulWidget {
  const CreateDeal4CompWidget({
    super.key,
    required this.onTap,
  });

  final Future Function()? onTap;

  @override
  State<CreateDeal4CompWidget> createState() => _CreateDeal4CompWidgetState();
}

class _CreateDeal4CompWidgetState extends State<CreateDeal4CompWidget> {
  late CreateDeal4CompModel _model;
  List<AuctionsRecord> auctons = [];
  AuctionsRecord? selectedAuction;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDeal4CompModel());
    init();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void init() async {
    final result = await queryAuctionsRecordOnce();
    auctons = result;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
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
              controller: _model.dropDownValueController ??= FormFieldController<AuctionsRecord>(null),
              options: auctons,
              onChanged: (val) => setState(() {
                selectedAuction = val;
                FFAppState().createDealAuction = val!.reference;
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
          const Spacer(),
          if (FFAppState().createDealAuction != null)
            FFButtonWidget(
              onPressed: () async {
                if (selectedAuction != null) {
                  FFAppState().createDealAuction = selectedAuction!.reference;
                }

                await widget.onTap?.call();
              },
              text: FFLocalizations.of(context).getText(
                'xgd4lv6v' /* Далее */,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 56.0,
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
        ],
      ),
    );
  }
}
