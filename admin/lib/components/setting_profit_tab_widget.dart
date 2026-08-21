import 'package:auto_deal_admin/backend/backend.dart';
import 'package:auto_deal_admin/flutter_flow/snackbar_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'setting_profit_tab_model.dart';
export 'setting_profit_tab_model.dart';

enum AccuralPeriodEnum { week, week2, month, month2, month3 }

String getAccuralPeriodNameRus(AccuralPeriodEnum a) {
  switch (a) {
    case AccuralPeriodEnum.week:
      return 'Раз в 7 дней';
    case AccuralPeriodEnum.week2:
      return 'Раз в 14 дней';
    case AccuralPeriodEnum.month:
      return 'Раз в 30 дней';
    case AccuralPeriodEnum.month2:
      return 'Раз в 60 дней';
    case AccuralPeriodEnum.month3:
      return 'Раз в 90 дней';

    default:
      return '-';
  }
}

AccuralPeriodEnum getFromFB(int period) {
  switch (period) {
    case 7:
      return AccuralPeriodEnum.week;
    case 14:
      return AccuralPeriodEnum.week2;
    case 30:
      return AccuralPeriodEnum.month;
    case 60:
      return AccuralPeriodEnum.month2;
    case 90:
      return AccuralPeriodEnum.month3;
    default:
      return AccuralPeriodEnum.week;
  }
}

int getFromEnum(AccuralPeriodEnum e) {
  switch (e) {
    case AccuralPeriodEnum.week:
      return 7;
    case AccuralPeriodEnum.week2:
      return 14;
    case AccuralPeriodEnum.month:
      return 30;
    case AccuralPeriodEnum.month2:
      return 60;
    case AccuralPeriodEnum.month3:
      return 90;
    default:
      return 7;
  }
}

class SettingProfitTabWidget extends StatefulWidget {
  const SettingProfitTabWidget({super.key});

  @override
  State<SettingProfitTabWidget> createState() => _SettingProfitTabWidgetState();
}

class _SettingProfitTabWidgetState extends State<SettingProfitTabWidget> {
  late SettingProfitTabModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingProfitTabModel());

    _model.switchValue = true;
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    initSetting();
    initStream();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void initSetting() async {
    final data = await FirebaseFirestore.instance.collection('config').doc('configs').get();
    final config = data.data();
    if (config == null) return;

    final bool automaticAccruaalValue = config['automatic_accrual'] ?? false;
    final num automaticAccrualValue = config['automatic_accrual_value'] ?? 0;
    final num automaticAccrualPeriod = config['automatic_accrual_period'] ?? 30;

    selectedPeriod = getFromFB(automaticAccrualPeriod.toInt());
    _model.textController.text = automaticAccrualValue.toString();
    automaticAccruaal = automaticAccruaalValue;

    if (mounted) setState(() {});
  }

  void initStream() {
    FirebaseFirestore.instance.collection('config').doc('configs').snapshots().listen((event) {
      final config = event.data();
      if (config == null) return;

      final bool automaticAccruaalValue = config['automatic_accrual'] ?? false;
      final num automaticAccrualPeriod = config['automatic_accrual_period'] ?? 30;
      automaticAccruaal = automaticAccruaalValue;
      selectedPeriod = getFromFB(automaticAccrualPeriod.toInt());
      if (mounted) setState(() {});
    });
  }

  AccuralPeriodEnum? selectedPeriod;
  bool automaticAccruaal = false;

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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 40.0, 0.0),
                    child: Text(
                      'Автоматическое начисление внутренней валюты',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  CupertinoSwitch(
                    value: automaticAccruaal,
                    onChanged: (v) {
                      FirebaseFirestore.instance.collection('config').doc('configs').update(
                        {"automatic_accrual": !automaticAccruaal},
                      );
                      if (mounted) setState(() {});
                    },
                    activeColor: FlutterFlowTheme.of(context).secondary,
                    trackColor: const Color(0xFFEEEEEE),
                    thumbColor: Colors.white,
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                if (automaticAccruaal) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 10.0),
                        child: Text(
                          'Сумма',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 380.0,
                        child: TextFormField(
                          // initialValue: automaticAccrualCalue.toString(),
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: false,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Укажите сумму монет',
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
                          validator: _model.textControllerValidator.asValidator(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 10.0),
                        child: Text(
                          'Периодичность',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 380.0,
                        height: 56.0,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<AccuralPeriodEnum>(
                            value: selectedPeriod,
                            isExpanded: true,
                            dropdownStyleData: const DropdownStyleData(
                              isOverButton: true,
                              maxHeight: 200,
                            ),
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryBackground,
                                borderRadius: BorderRadiusDirectional.circular(12),
                                border: Border.all(color: const Color(0xFFBDBDBD)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            iconStyleData: IconStyleData(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: FaIcon(
                                  FontAwesomeIcons.chevronDown,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                              ),
                            ),
                            hint: Text(
                              'Выберите периодичность',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).hintText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedPeriod = value;
                              });
                            },
                            items: AccuralPeriodEnum.values
                                .map(
                                  (e) => DropdownMenuItem<AccuralPeriodEnum>(
                                    value: e,
                                    child: Text(
                                      getAccuralPeriodNameRus(e),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                        child: AppButtonWidget(
                          onPressed: () async {
                            final text = _model.textController.text.trim();

                            if (text.isEmpty) {
                              showSnackBar(context, 'Заполните сумму');
                              return;
                            }
                            int? sum = int.tryParse(text);
                            if (sum == null || sum == 0) {
                              showSnackBar(context, 'Сумма не валидная');
                              return;
                            }
                            if (selectedPeriod == null) {
                              showSnackBar(context, 'Выберите период');
                              return;
                            }

                            final automaticAccrualPeriod = getFromEnum(selectedPeriod!);

                            await FirebaseFirestore.instance.collection('config').doc('configs').update(
                              {
                                "automatic_accrual_value": sum,
                                "automatic_accrual_period": automaticAccrualPeriod,
                              },
                            );
                            if (mounted) {
                              setState(() {});
                              // ignore: use_build_context_synchronously
                              showSnackBar(context, 'Сохранено!');
                            }
                          },
                          label: 'Сохранить',
                          width: 380,
                          isActive: true,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    decoration: const BoxDecoration(),
                  );
                }
              },
            ),
          ],
        ));
  }
}
