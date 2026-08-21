// ignore_for_file: deprecated_member_use

import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'response_deal_bottom_model.dart';
export 'response_deal_bottom_model.dart';

class SelectCarrierBottomWidget extends StatefulWidget {
  final int price;
  const SelectCarrierBottomWidget({super.key, required this.price});

  @override
  State<SelectCarrierBottomWidget> createState() => _SelectCarrierBottomWidgetState();
}

class _SelectCarrierBottomWidgetState extends State<SelectCarrierBottomWidget> {
  late ResponseDealBottomModel _model;
  String? selectedCar;
  String? priceError;
  String? carNumberError;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResponseDealBottomModel());

    _model.priceTextController ??= TextEditingController(text: widget.price.toString());
    _model.priceFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 6.0, 24.0, 36.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Container(
                        width: 42.0,
                        height: 3.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryText,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 30.0),
                  child: Text(
                    FFLocalizations.of(context).getText('select_carrier'),
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                  child: Text(
                    FFLocalizations.of(context).getText('select_carrier_price'),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontSize: 18,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.priceTextController,
                      focusNode: _model.priceFocusNode,
                      autofocus: false,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: FFLocalizations.of(context).getText(
                          's3yj9p3u' /* 500 */,
                        ),
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintColor,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                        errorStyle: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).error,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).border,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(top: 12, left: 10),
                          child: Text(
                            '\$',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                  fontSize: 18,
                                  color: _model.priceTextController!.text.isNotEmpty
                                      ? null
                                      : FlutterFlowTheme.of(context).hintColor,
                                ),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFAFAFA),
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                      textAlign: TextAlign.start,
                      minLines: 1,
                      maxLength: 50,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                      keyboardType: TextInputType.number,
                      cursorColor: FlutterFlowTheme.of(context).primary,
                      validator: _model.priceTextControllerValidator.asValidator(context),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                    ),
                  ),
                ),
                if (priceError != null)
                  Text(
                    priceError!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).error,
                          useGoogleFonts: false,
                        ),
                  ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 8.0),
                  child: Text(
                    FFLocalizations.of(context).getText('select_carrier_car_number'),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontSize: 18,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    onChanged: (value) {
                      setState(() {
                        selectedCar = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFFAFAFA),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    value: selectedCar,
                    hint: Text(
                      FFLocalizations.of(context).getText('select_carrier_car_number_hint'),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                            fontSize: 14,
                            useGoogleFonts: false,
                          ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: SvgPicture.asset(
                        'assets/images/ArrowDown.svg',
                        color: FlutterFlowTheme.of(context).border,
                      ),
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 150,
                      isOverButton: true,
                    ),
                    items: currentUserDocument!.dillerCars
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                                  child: Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0E0E0),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/license.svg',
                                        width: 300.0,
                                        height: 200.0,
                                        fit: BoxFit.none,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  e,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                  const SizedBox(height: 10),
                if (carNumberError != null)
                  Text(
                    carNumberError!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).error,
                          useGoogleFonts: false,
                        ),
                  ),
                const SizedBox(height: 10),
                FFButtonWidget(
                  onPressed: () async {
                    setState(() {
                      priceError = null;
                      carNumberError = null;
                    });

                    int? price = int.tryParse(_model.priceTextController.text);

                    if (price == null || price == 0) {
                      setState(() {
                        priceError = FFLocalizations.of(context).getText('dsg45g3g');
                      });
                    }
                    if (selectedCar == null) {
                      setState(() {
                        carNumberError = FFLocalizations.of(context).getText('dsg45g3g2');
                      });
                    }
                    if (priceError != null || carNumberError != null) {
                      return;
                    }
                    context.pop({
                      'price': price,
                      'car_number': selectedCar,
                    });
                  },
                  text: FFLocalizations.of(context).getText('accept'),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                    borderSide: BorderSide(
                      width: 0.0,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
