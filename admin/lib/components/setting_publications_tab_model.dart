import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'setting_publications_tab_widget.dart' show SettingPublicationsTabWidget;
import 'package:flutter/material.dart';

class SettingPublicationsTabModel
    extends FlutterFlowModel<SettingPublicationsTabWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Model for AppButton component.
  late AppButtonModel appButtonModel;

  @override
  void initState(BuildContext context) {
    appButtonModel = createModel(context, () => AppButtonModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    appButtonModel.dispose();
  }
}
