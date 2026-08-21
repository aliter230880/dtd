import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_worker_widget.dart' show EditWorkerWidget;
import 'package:flutter/material.dart';

class EditWorkerModel extends FlutterFlowModel<EditWorkerWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for AppButton component.
  late AppButtonModel appButtonModel;

  @override
  void initState(BuildContext context) {
    appButtonModel = createModel(context, () => AppButtonModel());
  }

  @override
  void dispose() {
    appButtonModel.dispose();
  }
}
