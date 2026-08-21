import '/components/diller_deal_card_widget.dart';
import '/components/diller_empty_active_deals_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'diller_active_deals_widget.dart' show DillerActiveDealsWidget;
import 'package:flutter/material.dart';

class DillerActiveDealsModel extends FlutterFlowModel<DillerActiveDealsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Models for DillerDealCard dynamic component.
  late FlutterFlowDynamicModels<DillerDealCardModel> dillerDealCardModels;
  // Model for diller_empty_active_deals_comp component.
  late DillerEmptyActiveDealsCompModel dillerEmptyActiveDealsCompModel;

  @override
  void initState(BuildContext context) {
    dillerDealCardModels =
        FlutterFlowDynamicModels(() => DillerDealCardModel());
    dillerEmptyActiveDealsCompModel =
        createModel(context, () => DillerEmptyActiveDealsCompModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    dillerDealCardModels.dispose();
    dillerEmptyActiveDealsCompModel.dispose();
  }
}
