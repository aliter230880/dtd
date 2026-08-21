import 'package:auto_deal_admin/flutter_flow/snackbar_service.dart';
import 'package:flutter/services.dart';

import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'setting_publications_tab_model.dart';
export 'setting_publications_tab_model.dart';

class SettingPublicationsTabWidget extends StatefulWidget {
  const SettingPublicationsTabWidget({super.key});

  @override
  State<SettingPublicationsTabWidget> createState() => _SettingPublicationsTabWidgetState();
}

class _SettingPublicationsTabWidgetState extends State<SettingPublicationsTabWidget> {
  late SettingPublicationsTabModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingPublicationsTabModel());

    initSetting();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  TextEditingController initialFreePublicationsController = TextEditingController();
  TextEditingController initialFreeResponsesController = TextEditingController();
  TextEditingController publicationCostController = TextEditingController();
  TextEditingController responseCostController = TextEditingController();

  void initSetting() async {
    final data = await FirebaseFirestore.instance.collection('config').doc('configs').get();
    final config = data.data();
    if (config == null) return;

    final num initialFreePublications = config['initial_free_publications'] ?? 0;
    final num initialFreeResponses = config['initial_free_responses'] ?? 0;
    final num publicationCost = config['publication_cost'] ?? 0;
    final num responseCost = config['response_cost'] ?? 0;

    initialFreePublicationsController.text = initialFreePublications.toString();
    initialFreeResponsesController.text = initialFreeResponses.toString();
    publicationCostController.text = publicationCost.toString();
    responseCostController.text = responseCost.toString();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFE9E9E9),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 10.0),
                    child: Text(
                      'Количество бесплатных публикаций',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: initialFreePublicationsController,
                      focusNode: _model.textFieldFocusNode1,
                      autofocus: false,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Укажите количество',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                      validator: _model.textController1Validator.asValidator(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 10.0),
                    child: Text(
                      'Количество бесплатных откликов',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: initialFreeResponsesController,
                      focusNode: _model.textFieldFocusNode1,
                      autofocus: false,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Укажите количество',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                      validator: _model.textController1Validator.asValidator(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 10.0),
                    child: Text(
                      'Стоимость публикации',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: publicationCostController,
                      focusNode: _model.textFieldFocusNode2,
                      autofocus: false,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Укажите стоимость в монетах',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                      validator: _model.textController2Validator.asValidator(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 10.0),
                    child: Text(
                      'Стоимость отклика',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: responseCostController,
                      focusNode: _model.textFieldFocusNode2,
                      autofocus: false,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Укажите стоимость в монетах',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                      validator: _model.textController2Validator.asValidator(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: AppButtonWidget(
                onPressed: () async {
                  final initialFreePublicationsText = initialFreePublicationsController.text.trim();
                  final initialFreeResponsesText = initialFreeResponsesController.text.trim();
                  final publicationCostText = publicationCostController.text.trim();
                  final responseCostText = responseCostController.text.trim();

                  if (initialFreePublicationsText.isEmpty || initialFreeResponsesText.isEmpty) {
                    showSnackBar(context, 'Заполните поле');
                    return;
                  }
                  int? initialFreePublicationsSum = int.tryParse(initialFreePublicationsText);
                  int? initialFreeResponsesSum = int.tryParse(initialFreeResponsesText);
                  int? publicationCostSum = int.tryParse(publicationCostText);
                  int? responseCostSum = int.tryParse(responseCostText);

                  if (publicationCostSum == null ||
                      publicationCostSum == 0 ||
                      responseCostSum == null ||
                      responseCostSum == 0) {
                    showSnackBar(context, 'Стоимость не валидная');
                    return;
                  }

                  await FirebaseFirestore.instance.collection('config').doc('configs').update(
                    {
                      "initial_free_publications": initialFreePublicationsSum ?? 0,
                      "initial_free_responses": initialFreeResponsesSum ?? 0,
                      "publication_cost": publicationCostSum,
                      "response_cost": responseCostSum,
                    },
                  );
                  if (mounted) {
                    setState(() {});
                    // ignore: use_build_context_synchronously
                    showSnackBar(context, 'Сохранено!');
                  }
                },
                label: 'Сохранить',
                width: 300,
                isActive: true,
              )),
        ],
      ),
    );
  }
}
