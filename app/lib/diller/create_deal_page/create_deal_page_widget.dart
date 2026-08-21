import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/backend/schema/enums/enums.dart';
import 'package:auto_deal_app/flutter_flow/currency_text_input_formatter.dart';
import 'package:auto_deal_app/profile/wallet_page/wallet_page_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../components/success_createdeal_custom_alert_widget.dart';
import '/components/create_deal1_comp_widget.dart';
import '/components/create_deal2_comp_widget.dart';
import '/components/create_deal3_comp_widget.dart';
import '/components/create_deal4_comp_widget.dart';
import '/components/create_deal5_comp_widget.dart';
import '/components/create_deal6_comp_widget.dart';
import '/components/create_deal7_comp_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'create_deal_page_model.dart';
export 'create_deal_page_model.dart';

final CurrencyTextInputFormatter currencyFormatter =
    CurrencyTextInputFormatter.currency(locale: 'ru', decimalDigits: 0, symbol: '\$');

class CreateDealPageWidget extends StatefulWidget {
  const CreateDealPageWidget({super.key});

  @override
  State<CreateDealPageWidget> createState() => _CreateDealPageWidgetState();
}

class _CreateDealPageWidgetState extends State<CreateDealPageWidget> {
  late CreateDealPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDealPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'CreateDealPage'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void clearAll() {
    FFAppState().clearAll();
    setState(() {});
  }

  Future<void> _balanceAction(DocumentReference<Object?> dealsRecord) async {
    final int freeDealCount = currentUserDocument?.freeDealCount ?? 0;

    if (freeDealCount == 0) {
      final configRef = FirebaseFirestore.instance.collection('config').doc('configs');
      final configDoc = await configRef.get();
      final configData = configDoc.data() as Map<String, dynamic>;
      final int dealCost = configData['publication_cost'] ?? 0;

      final oldBalance = (currentUserDocument?.balance ?? 0);
      final data = createUsersRecordData(
        balance: oldBalance - dealCost.toDouble(),
      );
      await currentUserReference?.update(data);

      await TransactionHelper.createTransactionOnDeal(dealCost);

      await dealsRecord.update({'pay_token_value': dealCost});
    } else {
      final data = {'free_deal_count': FieldValue.increment(-1)};
      await currentUserReference?.update(data);
      await dealsRecord.update({'pay_token_value': 0});
    }
  }

  Future<void> onCreateDeal() async {
    final int freeDealCount = currentUserDocument?.freeDealCount ?? 0;
    final price = int.parse(FFAppState().createDealPrice);

    final List<String> carPhotos = FFAppState().createDealCarPhotos.where((p) => p.isNotEmpty).toList();

    final carPhotosUrl = (await Future.wait(carPhotos.map((m) async => await uploadToDBPath(m))));

    final List<String> carFiles = FFAppState().creatDealFiles.where((p) => p.isNotEmpty).toList();

    final carFilesUrl = (await Future.wait(carFiles.map((m) async => await uploadToDBPath(m))));

    final dealsRecordData = {
      ...createDealsRecordData(
        carName: FFAppState().createDealCarName.trim(),
        description: FFAppState().createDealDescription.isEmpty ? null : FFAppState().createDealDescription.trim(),
        locationAddress: FFAppState().createDealAddress,
        location: FFAppState().createDealGeo,
        auction: FFAppState().createDealAuction,
        dealDate: FFAppState().createDealDate,
        price: price,
        payType: FFAppState().createDealPayType,
        owner: currentUserReference,
        ownerRate: currentUserDocument?.rate ?? 0,
        status: DealStatus.InSearch,
      ),
      "car_photos": carPhotosUrl,
      "files": carFilesUrl,
      "responses": [],
      "created_time": FieldValue.serverTimestamp(),
    };

    final dealsRecord = DealsRecord.collection.doc();
    await dealsRecord.set(dealsRecordData);

    await _balanceAction(dealsRecord);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
          child: SuccessCreatedealCustomAlertWidget(
            isDiller: true,
            isFreePublication: freeDealCount != 0,
          ),
        );
      },
    );

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
            child: FlutterFlowIconButton(
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
                if (_model.pageViewCurrentIndex == 0) {
                  clearAll();
                  context.pop();
                } else {
                  _model.pageViewController?.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
          title: Text(
            'Шаг ${_model.pageViewCurrentIndex + 1} из 7',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 24.0, 0.0),
              child: InkWell(
                onTap: () {
                  clearAll();
                  context.pop();
                },
                child: Text(
                  FFLocalizations.of(context).getText(
                    'puetag84' /* Отменить */,
                  ),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).hintColor,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: false,
                      ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _model.pageViewController ??= PageController(initialPage: 0),
              onPageChanged: (_) => setState(() {}),
              scrollDirection: Axis.horizontal,
              children: [
                wrapWithModel(
                  model: _model.createDeal1CompModel,
                  updateCallback: () => setState(() {}),
                  child: CreateDeal1CompWidget(
                    onTap: () async {
                      await _model.pageViewController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                wrapWithModel(
                  model: _model.createDeal2CompModel,
                  updateCallback: () => setState(() {}),
                  child: CreateDeal2CompWidget(
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await _model.pageViewController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                wrapWithModel(
                  model: _model.createDeal3CompModel,
                  updateCallback: () => setState(() {}),
                  child: CreateDeal3CompWidget(
                    onTap: () async {
                      await _model.pageViewController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                wrapWithModel(
                  model: _model.createDeal4CompModel,
                  updateCallback: () => setState(() {}),
                  child: CreateDeal4CompWidget(
                    onTap: () async {
                      await _model.pageViewController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                wrapWithModel(
                  model: _model.createDeal5CompModel,
                  updateCallback: () => setState(() {}),
                  child: CreateDeal5CompWidget(
                    onTap: () async {
                      await _model.pageViewController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                wrapWithModel(
                  model: _model.createDeal6CompModel,
                  updateCallback: () => setState(() {}),
                  child: CreateDeal6CompWidget(
                    onTap: () async {
                      await _model.pageViewController?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (context) => wrapWithModel(
                    model: _model.createDeal7CompModel,
                    updateCallback: () => setState(() {}),
                    child: CreateDeal7CompWidget(
                      onTap: onCreateDeal,
                    ),
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
