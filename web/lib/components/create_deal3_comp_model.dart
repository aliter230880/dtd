import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_deal3_comp_widget.dart' show CreateDeal3CompWidget;
import 'package:flutter/material.dart';

class CreateDeal3CompModel extends FlutterFlowModel<CreateDeal3CompWidget> {
  ///  Local state fields for this component.

  bool mapVisible = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? addressTextController;
  String? Function(BuildContext, String?)? addressTextControllerValidator;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descriptionFocusNode?.dispose();
    addressTextController?.dispose();
  }
}
