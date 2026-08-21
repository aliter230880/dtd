import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'registration_status_page_widget.dart' show RegistrationStatusPageWidget;
import 'package:flutter/material.dart';

class RegistrationStatusPageModel
    extends FlutterFlowModel<RegistrationStatusPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppButton component.
  late AppButtonModel appButtonModel1;
  // Model for AppButton component.
  late AppButtonModel appButtonModel2;

  @override
  void initState(BuildContext context) {
    appButtonModel1 = createModel(context, () => AppButtonModel());
    appButtonModel2 = createModel(context, () => AppButtonModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    appButtonModel1.dispose();
    appButtonModel2.dispose();
  }
}
