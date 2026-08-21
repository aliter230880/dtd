import '/flutter_flow/flutter_flow_util.dart';
import 'edit_diller_profile2_widget.dart' show EditDillerProfile2Widget;
import 'package:flutter/material.dart';

class EditDillerProfile2Model
    extends FlutterFlowModel<EditDillerProfile2Widget> {
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
