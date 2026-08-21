import '/flutter_flow/flutter_flow_util.dart';
import 'open_disput_bottom_widget.dart' show OpenDisputBottomWidget;
import 'package:flutter/material.dart';

class OpenDisputBottomModel extends FlutterFlowModel<OpenDisputBottomWidget> {
  ///  Local state fields for this component.
  List<FFUploadedFile> selectedFiles = [];
  void addToSelectedFiles(FFUploadedFile item) => selectedFiles.add(item);
  void removeFromSelectedFiles(FFUploadedFile item) =>
      selectedFiles.remove(item);
  void removeAtIndexFromSelectedFiles(int index) =>
      selectedFiles.removeAt(index);
  void insertAtIndexInSelectedFiles(int index, FFUploadedFile item) =>
      selectedFiles.insert(index, item);
  void updateSelectedFilesAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      selectedFiles[index] = updateFn(selectedFiles[index]);

  ///  State fields for stateful widgets in this component.
  // State field(s) for price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;
  bool isDataUploading = false;
  List<FFUploadedFile> uploadedLocalFiles = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    priceFocusNode?.dispose();
    priceTextController?.dispose();
  }
}