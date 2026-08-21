import '/components/app_bar_widget.dart';
import '/components/complaints_about_orders_widget.dart';
import '/components/complaints_about_users_widget.dart';
import '/components/disputes_about_active_orders_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'support_page_widget.dart' show SupportPageWidget;
import 'package:flutter/material.dart';

class SupportPageModel extends FlutterFlowModel<SupportPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppBar component.
  late AppBarModel appBarModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for ComplaintsAboutOrders component.
  late ComplaintsAboutOrdersModel complaintsAboutOrdersModel;
  // Model for ComplaintsAboutUsers component.
  late ComplaintsAboutUsersModel complaintsAboutUsersModel;
  // Model for DisputesAboutActiveOrders component.
  late DisputesAboutActiveOrdersModel disputesAboutActiveOrdersModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
    complaintsAboutOrdersModel =
        createModel(context, () => ComplaintsAboutOrdersModel());
    complaintsAboutUsersModel =
        createModel(context, () => ComplaintsAboutUsersModel());
    disputesAboutActiveOrdersModel =
        createModel(context, () => DisputesAboutActiveOrdersModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    appBarModel.dispose();
    tabBarController?.dispose();
    complaintsAboutOrdersModel.dispose();
    complaintsAboutUsersModel.dispose();
    disputesAboutActiveOrdersModel.dispose();
  }
}
