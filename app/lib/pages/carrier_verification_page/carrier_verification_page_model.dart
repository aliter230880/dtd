import '/flutter_flow/flutter_flow_util.dart';
import 'carrier_verification_page_widget.dart' show CarrierVerificationPageWidget;
import 'package:flutter/material.dart';

class CarrierVerificationPageModel extends FlutterFlowModel<CarrierVerificationPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  // State field(s) for DOT number widget.
  FocusNode? dotNumberFocusNode;
  TextEditingController? dotNumberTextController;
  String? Function(BuildContext, String?)? dotNumberTextControllerValidator;

  // State field(s) for MC number widget.
  FocusNode? mcNumberFocusNode;
  TextEditingController? mcNumberTextController;
  String? Function(BuildContext, String?)? mcNumberTextControllerValidator;

  // Loading state
  bool isLoading = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    dotNumberFocusNode?.dispose();
    dotNumberTextController?.dispose();
    mcNumberFocusNode?.dispose();
    mcNumberTextController?.dispose();
  }

  /// Validator to ensure at least one field is filled
  String? validateAtLeastOneField(BuildContext context) {
    final dotValue = dotNumberTextController?.text ?? '';
    final mcValue = mcNumberTextController?.text ?? '';
    
    if (dotValue.isEmpty && mcValue.isEmpty) {
      return FFLocalizations.of(context).getText(
        'validation_error' /* Необходимо заполнить хотя бы одно поле */,
      );
    }
    return null;
  }
}
