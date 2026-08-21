import '/flutter_flow/flutter_flow_util.dart';
import 'create_deal6_comp_widget.dart' show CreateDeal6CompWidget;
import 'package:flutter/material.dart';

class CreateDeal6CompModel extends FlutterFlowModel<CreateDeal6CompWidget> {
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
