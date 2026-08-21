import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'setting_offers_tab_model.dart';
export 'setting_offers_tab_model.dart';

class SettingOffersTabWidget extends StatefulWidget {
  const SettingOffersTabWidget({super.key});

  @override
  State<SettingOffersTabWidget> createState() => _SettingOffersTabWidgetState();
}

class _SettingOffersTabWidgetState extends State<SettingOffersTabWidget> {
  late SettingOffersTabModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingOffersTabModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFE0E0E0),
          ),
          Builder(
            builder: (context) => Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  // await showDialog(
                  //   context: context,
                  //   builder: (dialogContext) {
                  //     return Dialog(
                  //       elevation: 0,
                  //       insetPadding: EdgeInsets.zero,
                  //       backgroundColor: Colors.transparent,
                  //       alignment: const AlignmentDirectional(0.0, 0.0)
                  //           .resolve(Directionality.of(context)),
                  //       child: const EditPackWidget(),
                  //     );
                  //   },
                  // ).then((value) => setState(() {}));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(32.0),
                    border: Border.all(
                      color: const Color(0xFFBDBDBD),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 6.0, 12.0, 6.0),
                        child: Icon(
                          Icons.add,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                        child: Text(
                          'Добавить предложение',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
          //   child: Container(
          //     height: 44.0,
          //     decoration: BoxDecoration(
          //       color: FlutterFlowTheme.of(context).primaryBackground,
          //       borderRadius: const BorderRadius.only(
          //         bottomLeft: Radius.circular(0.0),
          //         bottomRight: Radius.circular(0.0),
          //         topLeft: Radius.circular(10.0),
          //         topRight: Radius.circular(10.0),
          //       ),
          //       border: Border.all(
          //         color: const Color(0xFFE9E9E9),
          //         width: 1.0,
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.max,
          //       children: [
          //         Padding(
          //           padding:
          //               const EdgeInsetsDirectional.fromSTEB(19.0, 15.0, 19.0, 15.0),
          //           child: Text(
          //             '№',
          //             style: FlutterFlowTheme.of(context).bodyMedium.override(
          //                   fontFamily: 'Inter',
          //                   color: FlutterFlowTheme.of(context).hintText,
          //                   fontSize: 12.0,
          //                   letterSpacing: 0.0,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //           ),
          //         ),
          //         Padding(
          //           padding:
          //               const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 100.0, 0.0),
          //           child: Text(
          //             'Наименование предложения',
          //             style: FlutterFlowTheme.of(context).bodyMedium.override(
          //                   fontFamily: 'Inter',
          //                   color: FlutterFlowTheme.of(context).hintText,
          //                   fontSize: 12.0,
          //                   letterSpacing: 0.0,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //           ),
          //         ),
          //         Container(
          //           width: 120.0,
          //           decoration: const BoxDecoration(),
          //           child: Align(
          //             alignment: const AlignmentDirectional(0.0, 0.0),
          //             child: Text(
          //               'Внутренняя \nвалюта',
          //               style: FlutterFlowTheme.of(context).bodyMedium.override(
          //                     fontFamily: 'Inter',
          //                     color: FlutterFlowTheme.of(context).hintText,
          //                     fontSize: 12.0,
          //                     letterSpacing: 0.0,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Align(
          //             alignment: const AlignmentDirectional(-1.0, 0.0),
          //             child: Padding(
          //               padding:
          //                   const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
          //               child: Text(
          //                 'Описание',
          //                 textAlign: TextAlign.start,
          //                 style: FlutterFlowTheme.of(context)
          //                     .bodyMedium
          //                     .override(
          //                       fontFamily: 'Inter',
          //                       color: FlutterFlowTheme.of(context).hintText,
          //                       fontSize: 12.0,
          //                       letterSpacing: 0.0,
          //                       fontWeight: FontWeight.w600,
          //                     ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding:
          //               const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 56.0, 0.0),
          //           child: Text(
          //             'Цена',
          //             style: FlutterFlowTheme.of(context).bodyMedium.override(
          //                   fontFamily: 'Inter',
          //                   color: FlutterFlowTheme.of(context).hintText,
          //                   fontSize: 12.0,
          //                   letterSpacing: 0.0,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //           ),
          //         ),
          //         Container(
          //           width: 172.0,
          //           decoration: const BoxDecoration(),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // ListView(
          //   padding: EdgeInsets.zero,
          //   shrinkWrap: true,
          //   scrollDirection: Axis.vertical,
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //         border: Border.all(
          //           color: const Color(0xFFE9E9E9),
          //           width: 1.0,
          //         ),
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.max,
          //         children: [
          //           Container(
          //             width: 48.0,
          //             height: 64.0,
          //             decoration: const BoxDecoration(),
          //             child:
          //                 // add +1
          //                 Align(
          //               alignment: const AlignmentDirectional(0.0, 0.0),
          //               child: Text(
          //                 '1',
          //                 style:
          //                     FlutterFlowTheme.of(context).bodyMedium.override(
          //                           fontFamily: 'Inter',
          //                           fontSize: 16.0,
          //                           letterSpacing: 0.0,
          //                         ),
          //               ),
          //             ),
          //           ),
          //           Container(
          //             width: 300.0,
          //             decoration: const BoxDecoration(),
          //             child: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsetsDirectional.fromSTEB(
          //                       24.0, 18.0, 12.0, 18.0),
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(100.0),
          //                     child: CachedNetworkImage(
          //                       fadeInDuration: const Duration(milliseconds: 500),
          //                       fadeOutDuration: const Duration(milliseconds: 500),
          //                       imageUrl: 'https://picsum.photos/seed/902/600',
          //                       width: 36.0,
          //                       height: 36.0,
          //                       fit: BoxFit.cover,
          //                       errorWidget: (context, error, stackTrace) =>
          //                           Image.asset(
          //                         'assets/images/error_image.svg',
          //                         width: 36.0,
          //                         height: 36.0,
          //                         fit: BoxFit.cover,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Text(
          //                   'Лина Иванова',
          //                   maxLines: 1,
          //                   style: FlutterFlowTheme.of(context)
          //                       .bodyMedium
          //                       .override(
          //                         fontFamily: 'Inter',
          //                         fontSize: 16.0,
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.normal,
          //                       ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Container(
          //             width: 120.0,
          //             decoration: const BoxDecoration(),
          //             child: Padding(
          //               padding:
          //                   const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
          //               child: Text(
          //                 '',
          //                 maxLines: 3,
          //                 style:
          //                     FlutterFlowTheme.of(context).bodyMedium.override(
          //                           fontFamily: 'Inter',
          //                           fontSize: 16.0,
          //                           letterSpacing: 0.0,
          //                         ),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               decoration: const BoxDecoration(),
          //               child: Padding(
          //                 padding: const EdgeInsetsDirectional.fromSTEB(
          //                     24.0, 0.0, 0.0, 0.0),
          //                 child: Text(
          //                   '',
          //                   maxLines: 2,
          //                   style: FlutterFlowTheme.of(context)
          //                       .bodyMedium
          //                       .override(
          //                         fontFamily: 'Inter',
          //                         fontSize: 16.0,
          //                         letterSpacing: 0.0,
          //                       ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Container(
          //             width: 111.0,
          //             decoration: const BoxDecoration(
          //               borderRadius: BorderRadius.only(
          //                 bottomLeft: Radius.circular(0.0),
          //                 bottomRight: Radius.circular(0.0),
          //                 topLeft: Radius.circular(0.0),
          //                 topRight: Radius.circular(0.0),
          //               ),
          //             ),
          //             child: Padding(
          //               padding:
          //                   const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
          //               child: Text(
          //                 '',
          //                 style: FlutterFlowTheme.of(context)
          //                     .bodyMedium
          //                     .override(
          //                       fontFamily: 'Inter',
          //                       color: FlutterFlowTheme.of(context).primaryText,
          //                       fontSize: 16.0,
          //                       letterSpacing: 0.0,
          //                     ),
          //               ),
          //             ),
          //           ),
          //           Container(
          //             width: 172.0,
          //             decoration: const BoxDecoration(),
          //             child: Align(
          //               alignment: const AlignmentDirectional(0.0, 0.0),
          //               child: FlutterFlowDropDown<String>(
          //                 controller: _model.dropDownValueController ??=
          //                     FormFieldController<String>(null),
          //                 options: const <String>[],
          //                 onChanged: (val) =>
          //                     setState(() => _model.dropDownValue = val),
          //                 width: 24.0,
          //                 height: 24.0,
          //                 textStyle:
          //                     FlutterFlowTheme.of(context).bodyMedium.override(
          //                           fontFamily: 'Inter',
          //                           letterSpacing: 0.0,
          //                         ),
          //                 icon: Icon(
          //                   Icons.keyboard_control_rounded,
          //                   color: FlutterFlowTheme.of(context).primaryText,
          //                   size: 24.0,
          //                 ),
          //                 elevation: 2.0,
          //                 borderColor: Colors.transparent,
          //                 borderWidth: 2.0,
          //                 borderRadius: 8.0,
          //                 margin: const EdgeInsetsDirectional.fromSTEB(
          //                     0.0, 0.0, 0.0, 0.0),
          //                 hidesUnderline: true,
          //                 isOverButton: true,
          //                 isSearchable: false,
          //                 isMultiSelect: false,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
