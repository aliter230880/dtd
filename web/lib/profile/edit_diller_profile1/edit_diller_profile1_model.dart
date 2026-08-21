import '/flutter_flow/flutter_flow_util.dart';
import 'edit_diller_profile1_widget.dart' show EditDillerProfile1Widget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditDillerProfile1Model
    extends FlutterFlowModel<EditDillerProfile1Widget> {
  ///  Local state fields for this page.

  DateTime? selectedDate;

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
        'q0fdkyjd' /* Введите номер дилерской лиценз... */,
      );
    }

    return null;
  }

  // State field(s) for driverNumber widget.
  FocusNode? driverNumberFocusNode;
  TextEditingController? driverNumberTextController;
  String? Function(BuildContext, String?)? driverNumberTextControllerValidator;
  String? _driverNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'mo8mbnho' /* Введите номер прав */,
      );
    }

    return null;
  }

  // State field(s) for takeDate widget.
  FocusNode? takeDateFocusNode;
  TextEditingController? takeDateTextController;
  String? Function(BuildContext, String?)? takeDateTextControllerValidator;
  String? _takeDateTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '6x1mb5w0' /* Выберите дату выдачи */,
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
