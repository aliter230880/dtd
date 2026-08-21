import '/components/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_complaints_page_widget.dart' show UserComplaintsPageWidget;
import 'package:flutter/material.dart';

class UserComplaintsPageModel
    extends FlutterFlowModel<UserComplaintsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppBar component.
  late AppBarModel appBarModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    appBarModel.dispose();
  }
}
