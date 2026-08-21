import '/components/diller_deals_comp_widget.dart';
import '/components/diller_empty_active_deals_comp_widget.dart';
import '/components/no_deals_diller_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for diller_empty_active_deals_comp component.
  late DillerEmptyActiveDealsCompModel dillerEmptyActiveDealsCompModel;
  // Model for no_deals_diller_comp component.
  late NoDealsDillerCompModel noDealsDillerCompModel;
  // Model for diller_deals_comp component.
  late DillerDealsCompModel dillerDealsCompModel;

  @override
  void initState(BuildContext context) {
    dillerEmptyActiveDealsCompModel =
        createModel(context, () => DillerEmptyActiveDealsCompModel());
    noDealsDillerCompModel =
        createModel(context, () => NoDealsDillerCompModel());
    dillerDealsCompModel = createModel(context, () => DillerDealsCompModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    dillerEmptyActiveDealsCompModel.dispose();
    noDealsDillerCompModel.dispose();
    dillerDealsCompModel.dispose();
  }
}
