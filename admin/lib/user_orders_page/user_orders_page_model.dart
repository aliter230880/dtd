import '/components/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_orders_page_widget.dart' show UserOrdersPageWidget;
import 'package:flutter/material.dart';

class UserOrdersPageModel extends FlutterFlowModel<UserOrdersPageWidget> {
  ///  Local state fields for this page.

  bool isCompleted = false;

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
