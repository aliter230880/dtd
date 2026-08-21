import '/flutter_flow/flutter_flow_util.dart';
import 'create_deal2_comp_widget.dart' show CreateDeal2CompWidget;
import 'package:flutter/material.dart';

class CreateDeal2CompModel extends FlutterFlowModel<CreateDeal2CompWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
  }
}
