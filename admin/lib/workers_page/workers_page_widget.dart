// ignore_for_file: constant_identifier_names

import 'package:auto_deal_admin/flutter_flow/form_field_controller.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../flutter_flow/flutter_flow_drop_down.dart';
import '/components/app_bar_widget.dart';
import '/components/workers_requests_tab_widget.dart';
import '/components/workers_tab_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'workers_page_model.dart';
export 'workers_page_model.dart';

@RoutePage()
class WorkersPageWidget extends StatefulWidget {
  const WorkersPageWidget({super.key});

  @override
  State<WorkersPageWidget> createState() => _WorkersPageWidgetState();
}

enum StaffFilter { All, Blocked, Active }

class _WorkersPageWidgetState extends State<WorkersPageWidget> with TickerProviderStateMixin {
  late WorkersPageModel _model;
  StaffFilter selectedFilter = StaffFilter.All;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String getFilterName(StaffFilter f) {
    switch (f) {
      case StaffFilter.Active:
        return 'Активен';
      case StaffFilter.Blocked:
        return 'Заблокирован';
      default:
        return 'Все';
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkersPageModel());

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
                pageName: 'СОТРУДНИКИ',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50.0, 60.0, 50.0, 20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: const Alignment(-1.0, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              isScrollable: true,
                              labelColor: FlutterFlowTheme.of(context).primaryText,
                              unselectedLabelColor: FlutterFlowTheme.of(context).primaryText,
                              labelPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                              labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                              unselectedLabelStyle: const TextStyle(),
                              indicatorColor: FlutterFlowTheme.of(context).primary,
                              tabs: const [
                                Tab(
                                  text: 'Сотрудники',
                                ),
                                Tab(
                                  text: 'Заявки',
                                ),
                              ],
                              controller: _model.tabBarController,
                              onTap: (i) async {
                                [() async {}, () async {}][i]();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Отражать статус',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                  child: FlutterFlowDropDown<StaffFilter>(
                                    controller: FormFieldController<StaffFilter>(selectedFilter),
                                    options: StaffFilter.values,
                                    onChanged: (val) => setState(() => selectedFilter = val!),
                                    optionLabels: StaffFilter.values.map((e) => getFilterName(e)).toList(),
                                    width: 100.0,
                                    height: 28.0,
                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                          letterSpacing: 0.0,
                                        ),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.chevronDown,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context).primaryText,
                                    elevation: 0.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 10.0,
                                    margin: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: false,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          WorkersTabWidget(filter: selectedFilter),
                          const WorkersRequestsTabWidget(),
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
