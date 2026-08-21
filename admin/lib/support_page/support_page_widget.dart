import 'package:auto_route/auto_route.dart';

import '/components/app_bar_widget.dart';
import '/components/complaints_about_orders_widget.dart';
import '/components/complaints_about_users_widget.dart';
import '/components/disputes_about_active_orders_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'support_page_model.dart';
export 'support_page_model.dart';

@RoutePage()
class SupportPageWidget extends StatefulWidget {
  const SupportPageWidget({super.key});

  @override
  State<SupportPageWidget> createState() => _SupportPageWidgetState();
}

class _SupportPageWidgetState extends State<SupportPageWidget>
    with TickerProviderStateMixin {
  late SupportPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportPageModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
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
                pageName: 'МОДЕРАЦИЯ ЖАЛОБ',
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
                                  letterSpacing: 0.0,
                                ),
                        unselectedLabelStyle: const TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        tabs: const [
                          Tab(
                            text: 'Жалобы на заказы',
                          ),
                          Tab(
                            text: 'Жалобы на пользователей',
                          ),
                          Tab(
                            text: 'Споры по активным заказам',
                          ),
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
                            model: _model.complaintsAboutOrdersModel,
                            updateCallback: () => setState(() {}),
                            child: const ComplaintsAboutOrdersWidget(),
                          ),
                          wrapWithModel(
                            model: _model.complaintsAboutUsersModel,
                            updateCallback: () => setState(() {}),
                            child: const ComplaintsAboutUsersWidget(),
                          ),
                          wrapWithModel(
                            model: _model.disputesAboutActiveOrdersModel,
                            updateCallback: () => setState(() {}),
                            child: const DisputesAboutActiveOrdersWidget(),
                          ),
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
