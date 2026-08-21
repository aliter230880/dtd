import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'banned_widget.dart' show BannedWidget;
import 'package:flutter/material.dart';

class BannedModel extends FlutterFlowModel<BannedWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for AppButton component.
  late AppButtonModel appButtonModel;

  @override
  void initState(BuildContext context) {
    appButtonModel = createModel(context, () => AppButtonModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    appButtonModel.dispose();
  }
}
