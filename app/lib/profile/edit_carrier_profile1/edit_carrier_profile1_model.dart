import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/document_validators.dart';
import 'edit_carrier_profile1_widget.dart' show EditCarrierProfile1Widget;
import 'package:flutter/material.dart';

class EditCarrierProfile1Model
    extends FlutterFlowModel<EditCarrierProfile1Widget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for companyName widget.
  FocusNode? companyNameFocusNode;
  TextEditingController? companyNameTextController;
  String? Function(BuildContext, String?)? companyNameTextControllerValidator;
  String? _companyNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'padtz505' /* Введите название компании */,
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
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'kzn0dss5' /* Введите номер перевозчика */,
      );
    }

    return DocumentValidators.carrierNumber(val);
  }

  // State field(s) for driverNumber widget.
  FocusNode? driverNumberFocusNode;
  TextEditingController? driverNumberTextController;
  String? Function(BuildContext, String?)? driverNumberTextControllerValidator;
  String? _driverNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'qvpxvw24' /* Введите номер водительских пра... */,
      );
    }

    return DocumentValidators.driverLicense(val);
  }

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
