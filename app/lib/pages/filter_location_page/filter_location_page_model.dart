import '/flutter_flow/flutter_flow_util.dart';
import 'filter_location_page_widget.dart' show FilterLocationPageWidget;
import 'package:flutter/material.dart';

class FilterLocationPageModel
    extends FlutterFlowModel<FilterLocationPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for location widget.
  FocusNode? locationFocusNode;
  TextEditingController? locationTextController;
  String? Function(BuildContext, String?)? locationTextControllerValidator;
  // State field(s) for Slider widget.
  double? sliderValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    locationFocusNode?.dispose();
    locationTextController?.dispose();
  }
}
