import '/components/diller_deal_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'history_page_widget.dart' show HistoryPageWidget;
import 'package:flutter/material.dart';

class HistoryPageModel extends FlutterFlowModel<HistoryPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Models for DillerDealCard dynamic component.
  late FlutterFlowDynamicModels<DillerDealCardModel> dillerDealCardModels;

  @override
  void initState(BuildContext context) {
    dillerDealCardModels =
        FlutterFlowDynamicModels(() => DillerDealCardModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    dillerDealCardModels.dispose();
  }
}
