import '/components/order_deal_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'deals_list_mode_widget.dart' show DealsListModeWidget;
import 'package:flutter/material.dart';

class DealsListModeModel extends FlutterFlowModel<DealsListModeWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for OrderDealCard dynamic component.
  late FlutterFlowDynamicModels<OrderDealCardModel> orderDealCardModels;

  @override
  void initState(BuildContext context) {
    orderDealCardModels = FlutterFlowDynamicModels(() => OrderDealCardModel());
  }

  @override
  void dispose() {
    orderDealCardModels.dispose();
  }
}
