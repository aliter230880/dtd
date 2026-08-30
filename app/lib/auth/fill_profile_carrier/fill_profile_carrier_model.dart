import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/verification/models/verification.dart';
import '/verification/services/validators.dart';
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
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'c782yqr5' /* Введите название компании */,
      );
    }

    if (val.length < 3) {
      return FFLocalizations.of(context).getText(
        '893c4qb6' /* Минимум 3 символа */,
      );
    }

    return null;
  }

  // State field(s) for carrierNumber widget.
  FocusNode? carrierNumberFocusNode;
  TextEditingController? carrierNumberTextController;
  String? Function(BuildContext, String?)? carrierNumberTextControllerValidator;
  String? _carrierNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'u2zbq5gt' /* Введите номер перевозчика */,
      );
    }

    // Физлицу USDOT не выдаётся — там путь верификации через личность,
    // поэтому форматную маску реестра к нему не применяем.
    if ((currentUserDocument?.carrierKind ?? 'company') == 'individual') {
      return val.length < 3
          ? FFLocalizations.of(context).getText('xjrxm5vo' /* Минимум 3 символа */)
          : null;
    }

    // Форматная проверка USDOT/MC до обращения к реестру FMCSA:
    // ловим опечатки локально, мгновенно и без сетевых запросов.
    final dot = Validators.validateDot(val);
    if (dot.status == VerificationStatus.checking) return null;

    final mc = Validators.validateMc(val);
    if (mc.status == VerificationStatus.checking ||
        mc.status == VerificationStatus.needsReview) {
      return null;
    }

    return dot.message ?? 'Укажите USDOT (1–8 цифр) или MC-номер';
  }

  // State field(s) for driverNumber widget.
  FocusNode? driverNumberFocusNode;
  TextEditingController? driverNumberTextController;
  String? Function(BuildContext, String?)? driverNumberTextControllerValidator;
  String? _driverNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'l60f1e35' /* Введите номер водительских пра... */,
      );
    }

    if (val.length < 3) {
      return FFLocalizations.of(context).getText(
        'zqr7knos' /* Минимум 3 символа */,
      );
    }

    return null;
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
