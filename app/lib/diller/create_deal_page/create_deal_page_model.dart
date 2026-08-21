import '/components/create_deal1_comp_widget.dart';
import '/components/create_deal2_comp_widget.dart';
import '/components/create_deal3_comp_widget.dart';
import '/components/create_deal4_comp_widget.dart';
import '/components/create_deal5_comp_widget.dart';
import '/components/create_deal6_comp_widget.dart';
import '/components/create_deal7_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_deal_page_widget.dart' show CreateDealPageWidget;
import 'package:flutter/material.dart';

class CreateDealPageModel extends FlutterFlowModel<CreateDealPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for create_deal_1_comp component.
  late CreateDeal1CompModel createDeal1CompModel;
  // Model for create_deal_2_comp component.
  late CreateDeal2CompModel createDeal2CompModel;
  // Model for create_deal_3_comp component.
  late CreateDeal3CompModel createDeal3CompModel;
  // Model for create_deal_4_comp component.
  late CreateDeal4CompModel createDeal4CompModel;
  // Model for create_deal_5_comp component.
  late CreateDeal5CompModel createDeal5CompModel;
  // Model for create_deal_6_comp component.
  late CreateDeal6CompModel createDeal6CompModel;
  // Model for create_deal_7_comp component.
  late CreateDeal7CompModel createDeal7CompModel;

  @override
  void initState(BuildContext context) {
    createDeal1CompModel = createModel(context, () => CreateDeal1CompModel());
    createDeal2CompModel = createModel(context, () => CreateDeal2CompModel());
    createDeal3CompModel = createModel(context, () => CreateDeal3CompModel());
    createDeal4CompModel = createModel(context, () => CreateDeal4CompModel());
    createDeal5CompModel = createModel(context, () => CreateDeal5CompModel());
    createDeal6CompModel = createModel(context, () => CreateDeal6CompModel());
    createDeal7CompModel = createModel(context, () => CreateDeal7CompModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    createDeal1CompModel.dispose();
    createDeal2CompModel.dispose();
    createDeal3CompModel.dispose();
    createDeal4CompModel.dispose();
    createDeal5CompModel.dispose();
    createDeal6CompModel.dispose();
    createDeal7CompModel.dispose();
  }
}
