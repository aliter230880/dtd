import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'filter_page_widget.dart' show FilterPageWidget;
import 'package:flutter/material.dart';

class FilterPageModel extends FlutterFlowModel<FilterPageWidget> {
  ///  Local state fields for this page.

  FilterRate? filterByRate = FilterRate.any;

  int? filterByCostMin;

  int? filterByCostMax;

  DocumentReference? filterByAuction;

  LatLng? filterByGeo;

  int? filterByGeoRadius;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for min widget.
  FocusNode? minFocusNode;
  TextEditingController? minTextController;
  String? Function(BuildContext, String?)? minTextControllerValidator;
  // State field(s) for max widget.
  FocusNode? maxFocusNode;
  TextEditingController? maxTextController;
  String? Function(BuildContext, String?)? maxTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
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
    minFocusNode?.dispose();
    minTextController?.dispose();

    maxFocusNode?.dispose();
    maxTextController?.dispose();

    locationFocusNode?.dispose();
    locationTextController?.dispose();
  }
}
