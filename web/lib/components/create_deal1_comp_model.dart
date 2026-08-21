import '/flutter_flow/flutter_flow_util.dart';
import 'create_deal1_comp_widget.dart' show CreateDeal1CompWidget;
import 'package:flutter/material.dart';

class CreateDeal1CompModel extends FlutterFlowModel<CreateDeal1CompWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for carName widget.
  FocusNode? carNameFocusNode;
  TextEditingController? carNameTextController;
  String? Function(BuildContext, String?)? carNameTextControllerValidator;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    carNameFocusNode?.dispose();
    carNameTextController?.dispose();
  }
}
