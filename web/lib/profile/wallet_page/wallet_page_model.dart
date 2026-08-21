import '/flutter_flow/flutter_flow_util.dart';
import 'wallet_page_widget.dart' show WalletPageWidget;
import 'package:flutter/material.dart';

class WalletPageModel extends FlutterFlowModel<WalletPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

   // Stores action output result for [RevenueCat - Purchase] action in Button widget.
  bool? purchaseOut;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
