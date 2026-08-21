import '/components/about_complaint_widget.dart';
import '/components/about_dispute_widget.dart';
import '/components/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'complaint_order_page_widget.dart' show ComplaintOrderPageWidget;
import 'package:flutter/material.dart';

class ComplaintOrderPageModel
    extends FlutterFlowModel<ComplaintOrderPageWidget> {
  ///  Local state fields for this page.

  bool isComplaint = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppBar component.
  late AppBarModel appBarModel;
  // Model for AboutComplaint component.
  late AboutComplaintModel aboutComplaintModel;
  // Model for aboutDispute component.
  late AboutDisputeModel aboutDisputeModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
    aboutComplaintModel = createModel(context, () => AboutComplaintModel());
    aboutDisputeModel = createModel(context, () => AboutDisputeModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    appBarModel.dispose();
    aboutComplaintModel.dispose();
    aboutDisputeModel.dispose();
  }
}
