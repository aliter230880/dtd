import '/flutter_flow/flutter_flow_util.dart';
import 'transactions_page_widget.dart' show TransactionsPageWidget;
import 'package:flutter/material.dart';

class TransactionsPageModel extends FlutterFlowModel<TransactionsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
