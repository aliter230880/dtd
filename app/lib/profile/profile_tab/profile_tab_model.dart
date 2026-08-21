import '/components/carrier_profile_history_widget.dart';
import '/components/diller_profile_history_widget.dart';
import '/components/user_profile_raitings_widget.dart';
import '/components/user_profile_transactions_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'profile_tab_widget.dart' show ProfileTabWidget;
import 'package:flutter/material.dart';

class ProfileTabModel extends FlutterFlowModel<ProfileTabWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for UserProfileRaitings component.
  late UserProfileRaitingsModel userProfileRaitingsModel;
  // Model for DillerProfileHistory component.
  late DillerProfileHistoryModel dillerProfileHistoryModel;
  // Model for CarrierProfileHistory component.
  late CarrierProfileHistoryModel carrierProfileHistoryModel;
  // Model for UserProfileTransactions component.
  late UserProfileTransactionsModel userProfileTransactionsModel;

  @override
  void initState(BuildContext context) {
    userProfileRaitingsModel =
        createModel(context, () => UserProfileRaitingsModel());
    dillerProfileHistoryModel =
        createModel(context, () => DillerProfileHistoryModel());
    carrierProfileHistoryModel =
        createModel(context, () => CarrierProfileHistoryModel());
    userProfileTransactionsModel =
        createModel(context, () => UserProfileTransactionsModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    userProfileRaitingsModel.dispose();
    dillerProfileHistoryModel.dispose();
    carrierProfileHistoryModel.dispose();
    userProfileTransactionsModel.dispose();
  }
}
