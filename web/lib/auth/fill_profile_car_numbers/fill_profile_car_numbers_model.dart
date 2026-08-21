import '/flutter_flow/flutter_flow_util.dart';
import 'fill_profile_car_numbers_widget.dart' show FillProfileCarNumbersWidget;
import 'package:flutter/material.dart';

class FillProfileCarNumbersModel
    extends FlutterFlowModel<FillProfileCarNumbersWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for carNumber widget.
  FocusNode? carNumberFocusNode;
  TextEditingController? carNumberTextController;
  String? Function(BuildContext, String?)? carNumberTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    carNumberFocusNode?.dispose();
    carNumberTextController?.dispose();
  }
}
