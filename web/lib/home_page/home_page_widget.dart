
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/diller_deals_comp_widget.dart';
import '/components/diller_empty_active_deals_comp_widget.dart';
import '/components/no_deals_diller_comp_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'HomePage'});
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
        child: Builder(
          builder: (context) {
            if (loggedIn == false) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: wrapWithModel(
                      model: _model.dillerEmptyActiveDealsCompModel,
                      updateCallback: () => setState(() {}),
                      child: const DillerEmptyActiveDealsCompWidget(),
                    ),
                  ),
                ],
              );
            } else if (currentUserDocument?.type == UserType.Diller) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            FFLocalizations.of(context).getText(
                              'g0zc5ir2' /* Добро пожаловать, */,
                            ),
                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 26.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                  useGoogleFonts: false,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                            child: Text(
                              currentUserDisplayName,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder<List<DealsRecord>>(
                          stream: queryDealsRecord(
                            queryBuilder: (dealsRecord) =>
                                dealsRecord.where('owner', isEqualTo: currentUserReference).whereIn('status', [
                              DealStatus.InSearch.name,
                              DealStatus.InConfirm.name,
                              DealStatus.InActive.name,
                              DealStatus.InDispute.name,
                              DealStatus.InConfirmComplete.name,
                            ]).orderBy('created_time', descending: true),
                          ),
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
                            List<DealsRecord> containerDealsRecordList = snapshot.data!;
                            return Container(
                              decoration: const BoxDecoration(),
                              child: Builder(
                                builder: (context) {
                                  if (containerDealsRecordList.isEmpty) {
                                    return wrapWithModel(
                                      model: _model.noDealsDillerCompModel,
                                      updateCallback: () => setState(() {}),
                                      child: const NoDealsDillerCompWidget(),
                                    );
                                  } else {
                                    return wrapWithModel(
                                      model: _model.dillerDealsCompModel,
                                      updateCallback: () => setState(() {}),
                                      child: DillerDealsCompWidget(
                                        deals: containerDealsRecordList,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                     
                    ],
                  ),
                ),
              );
            } else {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            FFLocalizations.of(context).getText(
                              'g0zc5ir2' /* Добро пожаловать, */,
                            ),
                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 26.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                  useGoogleFonts: false,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                            child: Text(
                              currentUserDisplayName,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder<List<DealsRecord>>(
                            stream: queryDealsRecord(
                              queryBuilder: (dealsRecord) =>
                                  dealsRecord.where('carriers', arrayContains: currentUserReference).whereIn('status', [
                                DealStatus.InSearch.name,
                                DealStatus.InConfirm.name,
                                DealStatus.InActive.name,
                                DealStatus.InDispute.name,
                                DealStatus.InConfirmComplete.name,
                              ]).orderBy('created_time', descending: true),
                            ),
                            builder: (context, snapshot) {
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
                              List<DealsRecord> deals = snapshot.data!;
                              return Builder(
                                builder: (context) {
                                  //if no deals
                                  if (deals.isEmpty) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 92.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFEFEFE),
                                              borderRadius: BorderRadius.circular(16.0),
                                              border: Border.all(
                                                color: const Color(0xFFE9E9E9),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          FFLocalizations.of(context).getText(
                                                            'tm3yt4d1' /* Активные заказы */,
                                                          ),
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16.0,
                                                                letterSpacing: 0.0,
                                                                fontWeight: FontWeight.w500,
                                                                useGoogleFonts: false,
                                                              ),
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              FFLocalizations.of(context).getText(
                                                                'yuw1fhx3' /* У вас нет активных заказов */,
                                                              ),
                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                    fontFamily: 'Inter',
                                                                    letterSpacing: 0.0,
                                                                    useGoogleFonts: false,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 32.0,
                                                    height: 32.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/images/car.svg',
                                                      width: 300.0,
                                                      height: 200.0,
                                                      fit: BoxFit.none,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 92.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFEFEFE),
                                              borderRadius: BorderRadius.circular(16.0),
                                              border: Border.all(
                                                color: const Color(0xFFE9E9E9),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          FFLocalizations.of(context).getText(
                                                            '47nv3ok6' /* Ваши отклики */,
                                                          ),
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16.0,
                                                                letterSpacing: 0.0,
                                                                fontWeight: FontWeight.w500,
                                                                useGoogleFonts: false,
                                                              ),
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              FFLocalizations.of(context).getText(
                                                                'ltc9tcv1' /* Вы пока не откликались на зака... */,
                                                              ),
                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                    fontFamily: 'Inter',
                                                                    letterSpacing: 0.0,
                                                                    useGoogleFonts: false,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 32.0,
                                                    height: 32.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/images/responses.svg',
                                                      width: 300.0,
                                                      height: 200.0,
                                                      fit: BoxFit.none,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    final activeDeals = deals
                                        .where((d) =>
                                            d.carrier == currentUserReference &&
                                            (d.status == DealStatus.InActive ||
                                                d.status == DealStatus.InConfirmComplete))
                                        .toList();
                                    final needConfrimDeals = deals
                                        .where((d) =>
                                            d.carrier == currentUserReference && (d.status == DealStatus.InConfirm))
                                        .toList();
                                    final disptuteDeals = deals
                                        .where((d) =>
                                            d.carrier == currentUserReference && (d.status == DealStatus.InDispute))
                                        .toList();
                                    final responsedDeals = deals
                                        .where(
                                          (d) =>
                                              d.carriers.contains(currentUserReference) &&
                                              (d.status == DealStatus.InSearch || d.status == DealStatus.InConfirm) &&
                                              !(d.carrier == currentUserReference &&
                                                  (d.status == DealStatus.InConfirm)),
                                        )
                                        .toList();
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (activeDeals.isEmpty)
                                            // No active deals
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 92.0,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFEFEFE),
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  border: Border.all(
                                                    color: const Color(0xFFE9E9E9),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              FFLocalizations.of(context).getText(
                                                                'tm3yt4d1' /* Активные заказы */,
                                                              ),
                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                    fontFamily: 'Inter',
                                                                    fontSize: 16.0,
                                                                    letterSpacing: 0.0,
                                                                    fontWeight: FontWeight.w500,
                                                                    useGoogleFonts: false,
                                                                  ),
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Text(
                                                                  FFLocalizations.of(context).getText(
                                                                    'yuw1fhx3' /* У вас нет активных заказов */,
                                                                  ),
                                                                  style:
                                                                      FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            fontFamily: 'Inter',
                                                                            letterSpacing: 0.0,
                                                                            useGoogleFonts: false,
                                                                          ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 32.0,
                                                        height: 32.0,
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        child: SvgPicture.asset(
                                                          'assets/images/car.svg',
                                                          width: 300.0,
                                                          height: 200.0,
                                                          fit: BoxFit.none,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            // Active deals
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.pushNamed(
                                                    'CarrierActiveDeals',
                                                    queryParameters: {
                                                      'length': serializeParam(activeDeals.length, ParamType.int),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 92.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFEFEFE),
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    border: Border.all(
                                                      color: const Color(0xFFE9E9E9),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                FFLocalizations.of(context)
                                                                    .getText('diller_status_in_active'),
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w500,
                                                                      useGoogleFonts: false,
                                                                    ),
                                                              ),
                                                              Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Text(
                                                                    // '${activeDeals.length} ${FFLocalizations.of(context).getText('deals1')}',
                                                                     getDealsCounterText(context, activeDeals.length),
                                                                    style: FlutterFlowTheme.of(context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily: 'Inter',
                                                                          letterSpacing: 0.0,
                                                                          fontSize: 16.0,
                                                                          useGoogleFonts: false,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 32.0,
                                                          height: 32.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/images/car.svg',
                                                            width: 300.0,
                                                            height: 200.0,
                                                            fit: BoxFit.none,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (needConfrimDeals.isNotEmpty)
                                            //in confirm
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.pushNamed(
                                                    'CarrierNeedConfirmDeals',
                                                    queryParameters: {
                                                      'length': serializeParam(needConfrimDeals.length, ParamType.int),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 92.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFEFEFE),
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    border: Border.all(
                                                      color: const Color(0xFFE9E9E9),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                FFLocalizations.of(context)
                                                                    .getText('carrier_status_in_confirm'),
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w500,
                                                                      useGoogleFonts: false,
                                                                    ),
                                                              ),
                                                              Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Text(
                                                                    // '${needConfrimDeals.length} ${FFLocalizations.of(context).getText('deals1')}',
                                                                     getDealsCounterText(context, needConfrimDeals.length),
                                                                    style: FlutterFlowTheme.of(context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily: 'Inter',
                                                                          letterSpacing: 0.0,
                                                                          fontSize: 16.0,
                                                                          useGoogleFonts: false,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 32.0,
                                                          height: 32.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/images/car.svg',
                                                            width: 300.0,
                                                            height: 200.0,
                                                            fit: BoxFit.none,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (disptuteDeals.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.pushNamed(
                                                    'CarrierDisputeDeals',
                                                    queryParameters: {
                                                      'length': serializeParam(disptuteDeals.length, ParamType.int),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 92.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFEFEFE),
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    border: Border.all(
                                                      color: const Color(0xFFE9E9E9),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                FFLocalizations.of(context)
                                                                    .getText('diller_status_in_dispute'),
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w500,
                                                                      useGoogleFonts: false,
                                                                    ),
                                                              ),
                                                              Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Text(
                                                                    // '${disptuteDeals.length} ${FFLocalizations.of(context).getText('deals1')}',
                                                                     getDealsCounterText(context, disptuteDeals.length),
                                                                    style: FlutterFlowTheme.of(context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily: 'Inter',
                                                                          letterSpacing: 0.0,
                                                                          fontSize: 16.0,
                                                                          useGoogleFonts: false,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 32.0,
                                                          height: 32.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/images/car.svg',
                                                            width: 300.0,
                                                            height: 200.0,
                                                            fit: BoxFit.none,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (responsedDeals.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.pushNamed(
                                                    'CarrierRespondedDeals',
                                                    queryParameters: {
                                                      'length': serializeParam(responsedDeals.length, ParamType.int),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 92.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFEFEFE),
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    border: Border.all(
                                                      color: const Color(0xFFE9E9E9),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                FFLocalizations.of(context)
                                                                    .getText('carrier_status_in_search'),
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w500,
                                                                      useGoogleFonts: false,
                                                                    ),
                                                              ),
                                                              Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Text(
                                                                    // '${responsedDeals.length} ${FFLocalizations.of(context).getText('responses1')}',
                                                                      getResponseCounterText(context, responsedDeals.length),
                                                                    style: FlutterFlowTheme.of(context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily: 'Inter',
                                                                          letterSpacing: 0.0,
                                                                          fontSize: 16.0,
                                                                          useGoogleFonts: false,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 32.0,
                                                          height: 32.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/images/responses.svg',
                                                            width: 300.0,
                                                            height: 200.0,
                                                            fit: BoxFit.none,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 92.0,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFEFEFE),
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  border: Border.all(
                                                    color: const Color(0xFFE9E9E9),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              FFLocalizations.of(context).getText(
                                                                '47nv3ok6' /* Ваши отклики */,
                                                              ),
                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                    fontFamily: 'Inter',
                                                                    fontSize: 16.0,
                                                                    letterSpacing: 0.0,
                                                                    fontWeight: FontWeight.w500,
                                                                    useGoogleFonts: false,
                                                                  ),
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Text(
                                                                  FFLocalizations.of(context).getText(
                                                                    'ltc9tcv1' /* Вы пока не откликались на зака... */,
                                                                  ),
                                                                  style:
                                                                      FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            fontFamily: 'Inter',
                                                                            letterSpacing: 0.0,
                                                                            useGoogleFonts: false,
                                                                          ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 32.0,
                                                        height: 32.0,
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        child: SvgPicture.asset(
                                                          'assets/images/responses.svg',
                                                          width: 300.0,
                                                          height: 200.0,
                                                          fit: BoxFit.none,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
