import '/flutter_flow/flutter_flow_util.dart';
import 'user_banned_page_widget.dart' show UserBannedPageWidget;
import 'package:flutter/material.dart';

class UserBannedPageModel extends FlutterFlowModel<UserBannedPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
