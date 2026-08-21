import '/backend/schema/enums/enums.dart';
import '/components/deals_list_mode_widget.dart';
import '/components/deals_map_mode_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'order_tab_widget.dart' show OrderTabWidget;
import 'package:flutter/material.dart';

class OrderTabModel extends FlutterFlowModel<OrderTabWidget> {
  ///  Local state fields for this page.

  DealsViewMode? dealsViewMode = DealsViewMode.List;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for DealsListMode component.
  late DealsListModeModel dealsListModeModel;
  // Model for DealsMapMode component.
  late DealsMapModeModel dealsMapModeModel;

  @override
  void initState(BuildContext context) {
    dealsListModeModel = createModel(context, () => DealsListModeModel());
    dealsMapModeModel = createModel(context, () => DealsMapModeModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    dealsListModeModel.dispose();
    dealsMapModeModel.dispose();
  }
}
