import '/flutter_flow/flutter_flow_util.dart';
import 'response_deal_bottom_widget.dart' show ResponseDealBottomWidget;
import 'package:flutter/material.dart';

class ResponseDealBottomModel
    extends FlutterFlowModel<ResponseDealBottomWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    priceFocusNode?.dispose();
    priceTextController?.dispose();
  }
}
