import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/document_validators.dart';
import 'fill_profile_diller_widget.dart' show FillProfileDillerWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FillProfileDillerModel extends FlutterFlowModel<FillProfileDillerWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? dillerLicenseFile;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for dillerNumber widget.
  FocusNode? dillerNumberFocusNode;
  TextEditingController? dillerNumberTextController;
  String? Function(BuildContext, String?)? dillerNumberTextControllerValidator;
  String? _dillerNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'qjkt0ibr' /* Введите номер дилерской лиценз... */,
      );
    }

    return DocumentValidators.dealerLicense(val);
  }

  // State field(s) for driverNumber widget.
  FocusNode? driverNumberFocusNode;
  TextEditingController? driverNumberTextController;
  String? Function(BuildContext, String?)? driverNumberTextControllerValidator;
  String? _driverNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '17byxfqr' /* Введите номер прав */,
      );
    }

    return DocumentValidators.driverLicense(val);
  }

  // State field(s) for takeDate widget.
  FocusNode? takeDateFocusNode;
  TextEditingController? takeDateTextController;
  String? Function(BuildContext, String?)? takeDateTextControllerValidator;
  String? _takeDateTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '47hirxlq' /* Выберите дату выдачи */,
      );
    }

    return null;
  }

  DateTime? datePicked;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  @override
  void initState(BuildContext context) {
    dillerNumberTextControllerValidator = _dillerNumberTextControllerValidator;
    driverNumberTextControllerValidator = _driverNumberTextControllerValidator;
    takeDateTextControllerValidator = _takeDateTextControllerValidator;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    dillerNumberFocusNode?.dispose();
    dillerNumberTextController?.dispose();

    driverNumberFocusNode?.dispose();
    driverNumberTextController?.dispose();

    takeDateFocusNode?.dispose();
    takeDateTextController?.dispose();
  }
}
