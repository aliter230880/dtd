import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_room_widget.dart' show ChatRoomWidget;
import 'package:flutter/material.dart';

class ChatRoomModel extends FlutterFlowModel<ChatRoomWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in Icon widget.
  MessageRecord? addedMessage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
