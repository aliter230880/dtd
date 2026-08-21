import '/components/diller_deal_status_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'diller_deal_card_widget.dart' show DillerDealCardWidget;
import 'package:flutter/material.dart';

class DillerDealCardModel extends FlutterFlowModel<DillerDealCardWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for DillerDealStatusComp component.
  late DillerDealStatusCompModel dillerDealStatusCompModel;

  @override
  void initState(BuildContext context) {
    dillerDealStatusCompModel =
        createModel(context, () => DillerDealStatusCompModel());
  }

  @override
  void dispose() {
    dillerDealStatusCompModel.dispose();
  }
}
