import 'package:auto_route/auto_route.dart';

import '/components/app_bar_widget.dart';

import '/components/setting_profit_tab_widget.dart';
import '/components/setting_publications_tab_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'setting_page_model.dart';
export 'setting_page_model.dart';

@RoutePage()
class SettingPageWidget extends StatefulWidget {
  const SettingPageWidget({super.key});

  @override
  State<SettingPageWidget> createState() => _SettingPageWidgetState();
}

class _SettingPageWidgetState extends State<SettingPageWidget>
    with TickerProviderStateMixin {
  late SettingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingPageModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            wrapWithModel(
              model: _model.appBarModel,
              updateCallback: () => setState(() {}),
              child: const AppBarWidget(
                pageName: 'НАСТРОЙКИ',
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(50.0, 60.0, 50.0, 20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: const Alignment(-1.0, 0),
                      child: TabBar(
                        isScrollable: true,
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).primaryText,
                        labelPadding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                ),
                        unselectedLabelStyle: const TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        tabs: const [
                          Tab(
                            text: 'Начисления',
                          ),
                          Tab(
                            text: 'Публикации',
                          ),
                          // Tab(
                          //   text: 'Предложения',
                          // ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}, () async {}][i]();
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          wrapWithModel(
                            model: _model.settingProfitTabModel,
                            updateCallback: () => setState(() {}),
                            child: const SettingProfitTabWidget(),
                          ),
                          wrapWithModel(
                            model: _model.settingPublicationsTabModel,
                            updateCallback: () => setState(() {}),
                            child: const SettingPublicationsTabWidget(),
                          ),
                          // wrapWithModel(
                          //   model: _model.settingOffersTabModel,
                          //   updateCallback: () => setState(() {}),
                          //   child: const SettingOffersTabWidget(),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
