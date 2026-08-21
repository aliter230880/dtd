import '/backend/backend.dart';
import '/components/diller_deal_status_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'deal_detail_carrier_widget.dart' show DealDetailCarrierWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DealDetailCarrierModel extends FlutterFlowModel<DealDetailCarrierWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - Read Document] action in DealDetailCarrier widget.
  DealsRecord? deal;
  // Model for DillerDealStatusComp component.
  late DillerDealStatusCompModel dillerDealStatusCompModel;
  // State field(s) for Carousel widget.
  CarouselController? carouselController;

  int carouselCurrentIndex = 0;

  @override
  void initState(BuildContext context) {
    dillerDealStatusCompModel =
        createModel(context, () => DillerDealStatusCompModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    dillerDealStatusCompModel.dispose();
  }
}
