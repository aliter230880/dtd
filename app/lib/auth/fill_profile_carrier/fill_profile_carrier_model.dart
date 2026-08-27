import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/document_validators.dart';
import 'fill_profile_carrier_widget.dart' show FillProfileCarrierWidget;
import 'package:flutter/material.dart';

class FillProfileCarrierModel
    extends FlutterFlowModel<FillProfileCarrierWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? driverLicenceFile;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for companyName widget.
  FocusNode? companyNameFocusNode;
  TextEditingController? companyNameTextController;
  String? Function(BuildContext, String?)? companyNameTextControllerValidator;
  String? _companyNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return FFLocalizations.of(context).getText(
        'c782yqr5' /* Введите название компании */,
      );
    }

    return DocumentValidators.companyName(val);
  }

  // State field(s) for carrierNumber widget.
  FocusNode? carrierNumberFocusNode;
  TextEditingController? carrierNumberTextController;
  String? Function(BuildContext, String?)? carrierNumberTextControllerValidator;
  String? _carrierNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return FFLocalizations.of(context).getText(
        'u2zbq5gt' /* Введите номер перевозчика */,
      );
    }

    // Проверка формата USDOT / MC вместо прежнего `length < 3`,
    // при котором строка «abc» проходила как номер перевозчика.
    return DocumentValidators.carrierNumber(val);
  }

  // State field(s) for driverNumber widget.
  FocusNode? driverNumberFocusNode;
  TextEditingController? driverNumberTextController;
  String? Function(BuildContext, String?)? driverNumberTextControllerValidator;
  String? _driverNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return FFLocalizations.of(context).getText(
        'l60f1e35' /* Введите номер водительских пра... */,
      );
    }

    return DocumentValidators.driverLicense(val);
  }

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  @override
  void initState(BuildContext context) {
    companyNameTextControllerValidator = _companyNameTextControllerValidator;
    carrierNumberTextControllerValidator =
        _carrierNumberTextControllerValidator;
    driverNumberTextControllerValidator = _driverNumberTextControllerValidator;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    companyNameFocusNode?.dispose();
    companyNameTextController?.dispose();

    carrierNumberFocusNode?.dispose();
    carrierNumberTextController?.dispose();

    driverNumberFocusNode?.dispose();
    driverNumberTextController?.dispose();
  }
}
