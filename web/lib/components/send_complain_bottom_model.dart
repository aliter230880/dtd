import '/flutter_flow/flutter_flow_util.dart';
import 'send_complain_bottom_widget.dart' show SendComplainBottomWidget;
import 'package:flutter/material.dart';

class SendComplainBottomModel
    extends FlutterFlowModel<SendComplainBottomWidget> {
  ///  State fields for stateful widgets in this component.
  // State field(s) for comment widget.
  FocusNode? commentFocusNode;
  TextEditingController? commentTextController;
  String? Function(BuildContext, String?)? commentTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    commentFocusNode?.dispose();
    commentTextController?.dispose();
  }
}