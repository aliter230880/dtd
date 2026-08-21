import '/components/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'complaint_user_page_widget.dart' show ComplaintUserPageWidget;
import 'package:flutter/material.dart';

class ComplaintUserPageModel extends FlutterFlowModel<ComplaintUserPageWidget> {
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
