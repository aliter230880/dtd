// ignore_for_file: deprecated_member_use

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'filter_page_model.dart';
export 'filter_page_model.dart';

class FilterPageWidget extends StatefulWidget {
  const FilterPageWidget({super.key});

  @override
  State<FilterPageWidget> createState() => _FilterPageWidgetState();
}

class _FilterPageWidgetState extends State<FilterPageWidget> {
  late FilterPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FilterPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'FilterPage'});

    _model.filterByRate = FFAppState().filterByRate;
    _model.filterByCostMin = FFAppState().filterByCostMin;
    _model.filterByCostMax = FFAppState().filterByCostMax;
    _model.filterByAuction = FFAppState().filterByAuction;
    _model.filterByGeo = FFAppState().filterByGeo;
    _model.filterByGeoRadius = FFAppState().filterByGeoRadius;

    // getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: true)
    //     .then((loc) => setState(() => currentUserLocationValue = loc));
    _model.minTextController ??=
        TextEditingController(text: _model.filterByCostMin == 0 ? null : _model.filterByCostMin.toString());
    _model.minFocusNode ??= FocusNode();

    _model.maxTextController ??=
        TextEditingController(text: _model.filterByCostMax == 0 ? null : _model.filterByCostMax.toString());
    _model.maxFocusNode ??= FocusNode();

    _model.locationTextController ??= TextEditingController();
    _model.locationFocusNode ??= FocusNode();

    getLocationAddress();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void getLocationAddress() async {
    if (_model.filterByGeo != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(_model.filterByGeo!.latitude, _model.filterByGeo!.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        _model.locationTextController!.text = getAddressFormattedName(place);
      }

      setState(() {});
    }
  }

  String getAddressFormattedName(Placemark? placemark) {
    if (placemark == null) return '';
    String name = '';
    if (placemark.country != null) name += '${placemark.country}, ';
    if (placemark.administrativeArea != null) name += '${placemark.administrativeArea}, ';
    if (placemark.locality != null) name += '${placemark.locality}, ';
    if (placemark.street != null) name += '${placemark.street}, ';
    if (placemark.name != null) name += '${placemark.name}';
    return name;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    // if (currentUserLocationValue == null) {
    //   return Container(
    //     color: FlutterFlowTheme.of(context).primaryBackground,
    //     child: Center(
    //       child: SizedBox(
    //         width: 50.0,
    //         height: 50.0,
    //         child: CircularProgressIndicator(
    //           valueColor: AlwaysStoppedAnimation<Color>(
    //             FlutterFlowTheme.of(context).primary,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 20.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  FFLocalizations.of(context).getText(
                    'wny8w3hs' /* Фильтры */,
                  ),
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  _model.filterByRate = FilterRate.any;
                  _model.filterByCostMin = null;
                  _model.filterByCostMax = null;
                  _model.filterByAuction = null;
                  _model.filterByGeo = null;
                  _model.filterByGeoRadius = null;

                  FFAppState().filterByRate = FilterRate.any;
                  FFAppState().filterByCostMin = 0;
                  FFAppState().filterByCostMax = 0;
                  FFAppState().filterByAuction = null;
                  FFAppState().filterByGeo = null;
                  FFAppState().filterByGeoRadius = 0;
                  setState(() {});
                  context.pop();
                },
                child: Text(
                  FFLocalizations.of(context).getText(
                    'cr7bvjc2' /* Сбросить */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: (_model.filterByRate != FilterRate.any) ||
                                (_model.filterByCostMin != null) ||
                                (_model.filterByCostMax != null) ||
                                (_model.filterByAuction != null) ||
                                (_model.filterByGeo != null)
                            ? FlutterFlowTheme.of(context).primaryText
                            : FlutterFlowTheme.of(context).secondary,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                ),
              ),
            ],
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 24.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'af8giade' /* Рейтинг создателя */,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _model.filterByRate = FilterRate.five;
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (_model.filterByRate == FilterRate.five) {
                                          return FaIcon(
                                            FontAwesomeIcons.solidCheckSquare,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 24.0,
                                          );
                                        } else {
                                          return FaIcon(
                                            FontAwesomeIcons.square,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 24.0,
                                          );
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'yjf2jb9e' /* 5.0 */,
                                        ),
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
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _model.filterByRate = FilterRate.fourAndOver;
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (_model.filterByRate == FilterRate.fourAndOver) {
                                          return FaIcon(
                                            FontAwesomeIcons.solidCheckSquare,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 24.0,
                                          );
                                        } else {
                                          return FaIcon(
                                            FontAwesomeIcons.square,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 24.0,
                                          );
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'qpkvx59m' /* 4.0 и выше */,
                                        ),
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
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _model.filterByRate = FilterRate.threeAndOver;
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (_model.filterByRate == FilterRate.threeAndOver) {
                                          return FaIcon(
                                            FontAwesomeIcons.solidCheckSquare,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 24.0,
                                          );
                                        } else {
                                          return FaIcon(
                                            FontAwesomeIcons.square,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 24.0,
                                          );
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          '4cl1g9ev' /* 3.0 и выше */,
                                        ),
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
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _model.filterByRate = FilterRate.any;
                                setState(() {});
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Builder(
                                    builder: (context) {
                                      if (_model.filterByRate == FilterRate.any) {
                                        return FaIcon(
                                          FontAwesomeIcons.solidCheckSquare,
                                          color: FlutterFlowTheme.of(context).primary,
                                          size: 24.0,
                                        );
                                      } else {
                                        return FaIcon(
                                          FontAwesomeIcons.square,
                                          color: FlutterFlowTheme.of(context).primary,
                                          size: 24.0,
                                        );
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        '0iwl5wpw' /* любой */,
                                      ),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  //Price
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 30.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'yhgpvkg3' /* Стоимость */,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.minTextController,
                                    focusNode: _model.minFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.minTextController',
                                      const Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    textCapitalization: TextCapitalization.none,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        'bi8z1fri' /* Мин */,
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
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                      contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 14.0, 15.0, 14.0),
                                      suffix: Text(
                                        '\$',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                              fontSize: 18,
                                              color: FlutterFlowTheme.of(context).hintColor,
                                            ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                    textAlign: TextAlign.start,
                                    minLines: 1,
                                    maxLength: 10,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.number,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.minTextControllerValidator.asValidator(context),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.maxTextController,
                                    focusNode: _model.maxFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.maxTextController',
                                      const Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    textCapitalization: TextCapitalization.none,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: FFLocalizations.of(context).getText(
                                        'zqzhahnh' /* Макс */,
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
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                      contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 14.0, 15.0, 14.0),
                                      suffix: Text(
                                        '\$',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                              fontSize: 18,
                                              color: FlutterFlowTheme.of(context).hintColor,
                                            ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                    textAlign: TextAlign.start,
                                    minLines: 1,
                                    maxLength: 10,
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                        null,
                                    keyboardType: TextInputType.number,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.maxTextControllerValidator.asValidator(context),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //Auction
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'xf0jdmda' /* Аукцион */,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        FutureBuilder<List<AuctionsRecord>>(
                          future: queryAuctionsRecordOnce(),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<AuctionsRecord> dropDownAuctionsRecordList = snapshot.data!;
                            return FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController ??= FormFieldController<String>(
                                dropDownAuctionsRecordList
                                    .firstWhereOrNull((e) => e.reference == _model.filterByAuction)
                                    ?.name,
                              ),
                              options: dropDownAuctionsRecordList.map((e) => e.name).toList(),
                              onChanged: (val) async {
                                _model.dropDownValue = val;
                                _model.filterByAuction = dropDownAuctionsRecordList
                                    .where((e) => e.name == _model.dropDownValue)
                                    .toList()
                                    .first
                                    .reference;
                                setState(() {});
                              },
                              width: double.infinity,
                              height: 56.0,
                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                              hintText: FFLocalizations.of(context).getText(
                                'd0398rux' /* Все аукционы */,
                              ),
                              maxHeight: 200,
                              icon: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: FlutterFlowTheme.of(context).secondary,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                              elevation: 0.0,
                              borderColor: Colors.transparent,
                              borderWidth: 0.0,
                              borderRadius: 12.0,
                              margin: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: false,
                              isMultiSelect: false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  //geo
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 10.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'yfim2ls3' /* Локация */,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: TextFormField(
                            controller: _model.locationTextController,
                            focusNode: _model.locationFocusNode,
                            onTap: () async {
                              final result = await context.pushNamed('FilterLocationPage');

                              if (result.runtimeType == String && result == 'reset') {
                                _model.filterByGeo = null;
                                _model.filterByGeoRadius = 0;
                                _model.locationTextController.text = '';
                                setState(() {});
                                return;
                              }
                              print(result);
                              if (result != null) {
                                final location = result as Map<String, dynamic>;
                                _model.filterByGeo = location['geo'];
                                _model.filterByGeoRadius = location['radius'];
                                _model.sliderValue = location['radius'].toDouble();
                                _model.locationTextController.text = location['address'];
                                setState(() {});
                              }
                            },
                            autofocus: false,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: FFLocalizations.of(context).getText(
                                '9txcht42' /* Все города */,
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
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
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
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                              contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 16.0, 15.0, 16.0),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                            textAlign: TextAlign.start,
                            minLines: 1,
                            maxLength: 250,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                            keyboardType: TextInputType.streetAddress,
                            cursorColor: FlutterFlowTheme.of(context).primary,
                            validator: _model.locationTextControllerValidator.asValidator(context),
                          ),
                        ),
                        if (_model.filterByGeo != null)
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 24, top: 24),
                                      child: Text(
                                        '${(_model.sliderValue ?? 100).toStringAsFixed(0)} км',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  activeColor: FlutterFlowTheme.of(context).primaryText,
                                  thumbColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  inactiveColor: const Color(0xFFE9E9E9),
                                  min: 1.0,
                                  max: 100.0,
                                  value: (_model.sliderValue ?? 100),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _model.sliderValue = newValue;
                                      _model.filterByGeoRadius = newValue.toInt();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        final int? priceMin = int.tryParse(_model.minTextController.text);
                        final int? priceMax = int.tryParse(_model.maxTextController.text);
                        FFAppState().filterByRate = _model.filterByRate;
                        FFAppState().filterByCostMin = priceMin ?? 0;
                        FFAppState().filterByCostMax = priceMax ?? 0;
                        FFAppState().filterByAuction = _model.filterByAuction;
                        FFAppState().filterByGeo = _model.filterByGeo;
                        FFAppState().filterByGeoRadius = _model.filterByGeoRadius!;
                        print('filter by rate: ${FFAppState().filterByRate}');
                        print('filter by cost min: ${FFAppState().filterByCostMin}');
                        print('filter by cost max: ${FFAppState().filterByCostMax}');
                        print('filter by auction: ${FFAppState().filterByAuction}');
                        print('filter by geo: ${FFAppState().filterByGeo}');
                        print('filter by geo radius: ${FFAppState().filterByGeoRadius}');

                        setState(() {});
                        context.pop();
                      },
                      text: FFLocalizations.of(context).getText(
                        'hm93fsx1' /* Сохранить */,
                      ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
