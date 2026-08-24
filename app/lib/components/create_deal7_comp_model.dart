import '/flutter_flow/flutter_flow_util.dart';
import 'create_deal7_comp_widget.dart' show CreateDeal7CompWidget;
import 'package:flutter/material.dart';

class CreateDeal7CompModel extends FlutterFlowModel<CreateDeal7CompWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  
  /// Insurance quote cost in cents
  int? insuranceQuoteCost;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
