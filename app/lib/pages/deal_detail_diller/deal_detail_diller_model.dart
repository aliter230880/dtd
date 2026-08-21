import '/backend/backend.dart';
import '/components/diller_deal_status_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'deal_detail_diller_widget.dart' show DealDetailDillerWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DealDetailDillerModel extends FlutterFlowModel<DealDetailDillerWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - Read Document] action in DealDetailDiller widget.
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
