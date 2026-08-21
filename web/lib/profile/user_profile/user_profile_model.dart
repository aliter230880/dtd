import '/components/user_profile_raitings_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_profile_widget.dart' show UserProfileWidget;
import 'package:flutter/material.dart';

class UserProfileModel extends FlutterFlowModel<UserProfileWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for UserProfileRaitings component.
  late UserProfileRaitingsModel userProfileRaitingsModel;

  @override
  void initState(BuildContext context) {
    userProfileRaitingsModel =
        createModel(context, () => UserProfileRaitingsModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    userProfileRaitingsModel.dispose();
  }
}
