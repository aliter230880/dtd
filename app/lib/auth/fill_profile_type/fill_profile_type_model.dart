import '/backend/schema/enums/enums.dart';
import '/components/profile_type_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'fill_profile_type_widget.dart' show FillProfileTypeWidget;
import 'package:flutter/material.dart';

class FillProfileTypeModel extends FlutterFlowModel<FillProfileTypeWidget> {
  ///  Local state fields for this page.

  UserType? type;

  /// Путь верификации перевозчика: company | individual.
  /// Роль остаётся в [type] — физлицо-перегонщик это тот же Carrier.
  String? carrierKind;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for profile_type_comp component.
  late ProfileTypeCompModel profileTypeCompModel1;
  // Model for profile_type_comp component.
  late ProfileTypeCompModel profileTypeCompModel2;

  @override
  void initState(BuildContext context) {
    profileTypeCompModel1 = createModel(context, () => ProfileTypeCompModel());
    profileTypeCompModel2 = createModel(context, () => ProfileTypeCompModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    profileTypeCompModel1.dispose();
    profileTypeCompModel2.dispose();
  }
}
