import 'package:auto_deal_app/backend/backend.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '/auth/firebase_auth/auth_util.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'payment_methods_section.dart';
import 'wallet_page_model.dart';
export 'wallet_page_model.dart';

class TransactionHelper {
  static Future<void> createTransactionOnResponse(int responseCost) async {
    final data = {
      ...createTransactionsRecordData(
        amount: responseCost.toDouble(),
        userRef: currentUserReference,
        type: 'response',
      ),
      'created_time': FieldValue.serverTimestamp(),
    };

    await TransactionsRecord.collection.doc().set(data);
  }

  static Future<void> createTransactionOnDeal(int publicationCost) async {
    final data = {
      ...createTransactionsRecordData(
        amount: publicationCost.toDouble(),
        userRef: currentUserReference,
        type: 'publication',
      ),
      'created_time': FieldValue.serverTimestamp(),
    };

    await TransactionsRecord.collection.doc().set(data);
  }

  static Future<void> createTransactionOnPopup(int amount, double priceSum) async {
    final data = {
      ...createTransactionsRecordData(
        amount: amount.toDouble(),
        userRef: currentUserReference,
        type: 'popup',
        amountPrice: priceSum,
      ),
      'created_time': FieldValue.serverTimestamp(),
    };

    await TransactionsRecord.collection.doc().set(data);
  }
}

class WalletPageWidget extends StatefulWidget {
  const WalletPageWidget({super.key});

  @override
  State<WalletPageWidget> createState() => _WalletPageWidgetState();
}

class _WalletPageWidgetState extends State<WalletPageWidget> {
  late WalletPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WalletPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'WalletPage'});
    revenue_cat.loadOfferings();
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
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_outlined,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          FFLocalizations.of(context).getText(
            'q381mube' /* Пополнение кошелька */,
          ),
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 30.0),
              child: Container(
                width: double.infinity,
                height: 133.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                's55fspw7' /* Ваш баланс */,
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                              child: AuthUserStreamWidget(
                                builder: (context) => Text(
                                  valueOrDefault<String>(
                                    formatNumber(
                                      valueOrDefault(currentUserDocument?.balance, 0.0),
                                      formatType: FormatType.custom,
                                      currency: '\$',
                                      format: '',
                                      locale: '',
                                    ),
                                    '0',
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        fontSize: 32.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  '6tsztnuk' /* Выберите пакет для пополнения */,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 40.0),
                child: Builder(
                  builder: (context) {
                    // RevenueCat не работает в браузере — там показываем
                    // выбор способа оплаты через Stripe Checkout.
                    if (kIsWeb) {
                      return const PaymentMethodsSection();
                    }
                    if (revenue_cat.offerings == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final packages = revenue_cat.offerings!.current!.availablePackages.map((e) => e).toList();

                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CarouselSlider.builder(
                        itemCount: packages.length,
                        itemBuilder: (context, packagesIndex, _) {
                          final packagesItem = packages[packagesIndex];
                          return Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.7,
                                height: double.infinity,
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9E9E9),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).buttonDisabel,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 86.0,
                                        height: 86.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/money-bag.svg',
                                          fit: BoxFit.none,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 20.0),
                                        child: Text(
                                          packagesItem.storeProduct.title,
                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                fontFamily: 'Inter',
                                                color: FlutterFlowTheme.of(context).primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        packagesItem.storeProduct.priceString,
                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                      const Divider(
                                        height: 40.0,
                                        thickness: 1.0,
                                        color: Color(0xFF444444),
                                      ),
                                      Expanded(
                                        child: Text(
                                          packagesItem.storeProduct.description,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          _model.purchaseOut =
                                              await revenue_cat.purchasePackage(packagesItem.identifier);
                                          if (_model.purchaseOut ?? false) {
                                            final int amount = packagesItem.identifier == 'coin50'
                                                ? 50
                                                : packagesItem.identifier == 'coin100'
                                                    ? 100
                                                    : 500;

                                            final priceSum = packagesItem.storeProduct.price;
                                            print('identifier: ${packagesItem.identifier}');
                                            print('Amount: $amount');
                                            print('AmountPrice: $priceSum');
                                            await currentUserReference
                                                ?.update({"balance": FieldValue.increment(amount)});
                                            await TransactionHelper.createTransactionOnPopup(amount, priceSum);
                                            if (context.mounted) {
                                              context.pop();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    FFLocalizations.of(context).getText('buy_succes'),
                                                    style: TextStyle(
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                    ),
                                                  ),
                                                  duration: const Duration(milliseconds: 4000),
                                                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  FFLocalizations.of(context).getText('error'),
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                  ),
                                                ),
                                                duration: const Duration(milliseconds: 4000),
                                                backgroundColor: FlutterFlowTheme.of(context).secondary,
                                              ),
                                            );
                                          }
                                        },
                                        text: FFLocalizations.of(context).getText(
                                          'buy' /* Оплатить */,
                                        ),
                                        options: FFButtonOptions(
                                          width: 142.0,
                                          height: 44.0,
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts: false,
                                              ),
                                          elevation: 0.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0,
                                          ),
                                          borderRadius: BorderRadius.circular(48.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        carouselController: CarouselController(),
                        options: CarouselOptions(
                          height: double.infinity,
                          initialPage: max(0, min(1, packages.length - 1)),
                          viewportFraction: 0.75,
                          disableCenter: true,
                          enlargeCenterPage: false,
                          enlargeFactor: 0.0,
                          enableInfiniteScroll: false,
                          scrollDirection: Axis.horizontal,
                          autoPlay: false,
                          onPageChanged: (index, _) {
                            
                          },
                        ),
                      ),
                    );

                  
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
