import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'remove_order_from_publication_widget.dart'
    show RemoveOrderFromPublicationWidget;
import 'package:flutter/material.dart';

class RemoveOrderFromPublicationModel
    extends FlutterFlowModel<RemoveOrderFromPublicationWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for DropDown widget.
  List<String>? dropDownValue;
  FormFieldController<List<String>>? dropDownValueController;
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
