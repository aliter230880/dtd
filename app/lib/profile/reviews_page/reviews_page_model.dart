import '/flutter_flow/flutter_flow_util.dart';
import 'reviews_page_widget.dart' show ReviewsPageWidget;
import 'package:flutter/material.dart';

class ReviewsPageModel extends FlutterFlowModel<ReviewsPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
