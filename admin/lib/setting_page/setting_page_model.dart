import '/components/app_bar_widget.dart';
import '/components/setting_offers_tab_widget.dart';
import '/components/setting_profit_tab_widget.dart';
import '/components/setting_publications_tab_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'setting_page_widget.dart' show SettingPageWidget;
import 'package:flutter/material.dart';

class SettingPageModel extends FlutterFlowModel<SettingPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppBar component.
  late AppBarModel appBarModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for SettingProfitTab component.
  late SettingProfitTabModel settingProfitTabModel;
  // Model for SettingPublicationsTab component.
  late SettingPublicationsTabModel settingPublicationsTabModel;
  // Model for SettingOffersTab component.
  late SettingOffersTabModel settingOffersTabModel;

  @override
  void initState(BuildContext context) {
    appBarModel = createModel(context, () => AppBarModel());
    settingProfitTabModel = createModel(context, () => SettingProfitTabModel());
    settingPublicationsTabModel =
        createModel(context, () => SettingPublicationsTabModel());
    settingOffersTabModel = createModel(context, () => SettingOffersTabModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    appBarModel.dispose();
    tabBarController?.dispose();
    settingProfitTabModel.dispose();
    settingPublicationsTabModel.dispose();
    settingOffersTabModel.dispose();
  }
}
