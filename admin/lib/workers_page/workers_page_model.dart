import '/components/app_bar_widget.dart';
import '/components/workers_requests_tab_widget.dart';
import '/components/workers_tab_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'workers_page_widget.dart' show WorkersPageWidget;
import 'package:flutter/material.dart';

class WorkersPageModel extends FlutterFlowModel<WorkersPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppBar component.
  late AppBarModel appBarModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for WorkersTab component.
  late WorkersTabModel workersTabModel;
  // Model for WorkersRequestsTab component.
  late WorkersRequestsTabModel workersRequestsTabModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
    workersTabModel = createModel(context, () => WorkersTabModel());
    workersRequestsTabModel =
        createModel(context, () => WorkersRequestsTabModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    appBarModel.dispose();
    tabBarController?.dispose();
    workersTabModel.dispose();
    workersRequestsTabModel.dispose();
  }
}
