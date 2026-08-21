import '/components/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'order_complaints_page_widget.dart' show OrderComplaintsPageWidget;
import 'package:flutter/material.dart';

class OrderComplaintsPageModel
    extends FlutterFlowModel<OrderComplaintsPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AppBar component.
  late AppBarModel appBarModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
  }

  @override
  void dispose() {
    appBarModel.dispose();
  }
}
