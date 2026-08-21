import '/flutter_flow/flutter_flow_util.dart';
import 'chat_tab_widget.dart' show ChatTabWidget;
import 'package:flutter/material.dart';

class ChatTabModel extends FlutterFlowModel<ChatTabWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
