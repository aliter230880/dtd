
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/order_deal_card_widget.dart';
import '/components/take_login_alert_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'deals_list_mode_model.dart';
export 'deals_list_mode_model.dart';

class DealsListModeWidget extends StatefulWidget {
  const DealsListModeWidget({
    super.key,
    required this.deals,
    required this.onTapMapMode,
    required this.onRefresh,
  });

  final List<DealsRecord>? deals;
  final Future Function()? onTapMapMode;
  final Future Function() onRefresh;

  @override
  State<DealsListModeWidget> createState() => _DealsListModeWidgetState();
}

class _DealsListModeWidgetState extends State<DealsListModeWidget> {
  late DealsListModeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DealsListModeModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          height: 68.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await widget.onTapMapMode?.call();
                    },
                    child: SvgPicture.asset(
                      'assets/images/map.svg',
                      width: 24.0,
                      height: 24.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    FFLocalizations.of(context).getText(
                      't8gwz8md' 
                    ),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await context.pushNamed('FilterPage');
                    widget.onRefresh.call();
                  },
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.0, 1.0),
                          child: SvgPicture.asset(
                            'assets/images/Filter.svg',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (valueOrDefault<bool>(
                          (FFAppState().filterByRate != FilterRate.any) ||
                              (FFAppState().filterByCostMin != 0) ||
                              (FFAppState().filterByCostMax != 0) ||
                              (FFAppState().filterByAuction != null) ||
                              (FFAppState().filterByGeo != null),
                          false,
                        ))
                          Align(
                            alignment: const AlignmentDirectional(1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 2.0, 0.0),
                              child: Container(
                                width: 14.0,
                                height: 14.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Builder(builder: (context) {
                                    int counter = 0;
                                    if (FFAppState().filterByRate != FilterRate.any) {
                                      counter++;
                                    }
                                    if (FFAppState().filterByCostMin != 0 || FFAppState().filterByCostMax != 0) {
                                      counter++;
                                    }
                                    if (FFAppState().filterByAuction != null) {
                                      counter++;
                                    }
                                    if (FFAppState().filterByGeo != null) {
                                      counter++;
                                    }
                                    return Text(
                                      counter.toString(),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            fontSize: 6.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              if (widget.deals!.isEmpty) {
                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_deals.png',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'hy2hyda0' 
                                  ,
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () {
                          widget.onRefresh.call();
                        },
                        text: FFLocalizations.of(context).getText(
                          'ac4bd5ty' /* Обновить */,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: false,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 0.0),
                  child: Builder(
                    builder: (context) {
                      final dealsVar = widget.deals!.map((e) => e).toList();
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        scrollDirection: Axis.vertical,
                        itemCount: dealsVar.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                        itemBuilder: (context, dealsVarIndex) {
                          final dealsVarItem = dealsVar[dealsVarIndex];
                          return Builder(
                            builder: (context) => InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (loggedIn) {
                                  if (currentUserDocument?.type == UserType.Diller) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Чтобы видеть заказы, войдите как перевозчик',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context).primaryText,
                                          ),
                                        ),
                                        duration: const Duration(milliseconds: 4000),
                                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                      ),
                                    );
                                    return;
                                  } else {
                                    context.pushNamed(
                                      'DealDetailCarrier',
                                      queryParameters: {
                                        'dealRef': serializeParam(
                                          dealsVarItem.reference,
                                          ParamType.DocumentReference,
                                        ),
                                      }.withoutNulls,
                                    );

                                    return;
                                  }
                                } else {
                                  String? confirm = await showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                        child: const TakeLoginAlertWidget(),
                                      );
                                    },
                                  );

                                  if (confirm != null && mounted) {
                                    if (confirm == 'login') {
                                      context.pushNamed('login_page');
                                    } else {
                                      context.pushNamed('registration_page');
                                    }
                                  }

                                  return;
                                }
                              },
                              child: wrapWithModel(
                                model: _model.orderDealCardModels.getModel(
                                  dealsVarItem.reference.id,
                                  dealsVarIndex,
                                ),
                                updateCallback: () => setState(() {}),
                                child: OrderDealCardWidget(
                                  key: Key(
                                    'Keykmk_${dealsVarItem.reference.id}',
                                  ),
                                  deal: dealsVarItem,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
