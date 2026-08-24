import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

/// Пакет пополнения: сколько кредитов начисляем и сколько это стоит.
class TopUpPackage {
  const TopUpPackage({required this.credits, required this.priceUsd});

  final int credits;
  final double priceUsd;

  String get priceLabel => '\$${priceUsd.toStringAsFixed(2)}';
}

/// Способ оплаты. [methodTypes] — типы, которые уходят в Stripe Checkout;
/// пустой список означает, что провайдер пока не подключён.
class PaymentMethodOption {
  const PaymentMethodOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.methodTypes,
    this.regionHint,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> methodTypes;
  final String? regionHint;

  bool get isAvailable => methodTypes.isNotEmpty;
}

const kTopUpPackages = <TopUpPackage>[
  TopUpPackage(credits: 50, priceUsd: 50),
  TopUpPackage(credits: 100, priceUsd: 100),
  TopUpPackage(credits: 500, priceUsd: 500),
];

const kPaymentMethods = <PaymentMethodOption>[
  PaymentMethodOption(
    id: 'card',
    title: 'Банковская карта',
    subtitle: 'Visa, Mastercard, American Express',
    icon: Icons.credit_card,
    methodTypes: ['card'],
    regionHint: 'США и Европа',
  ),
  PaymentMethodOption(
    id: 'wallets',
    title: 'Apple Pay / Google Pay',
    subtitle: 'Оплата в один тап через Stripe',
    icon: Icons.account_balance_wallet_outlined,
    methodTypes: ['card'],
    regionHint: 'США и Европа',
  ),
  PaymentMethodOption(
    id: 'sepa',
    title: 'SEPA Direct Debit',
    subtitle: 'Списание с банковского счёта в евро',
    icon: Icons.account_balance_outlined,
    methodTypes: ['sepa_debit'],
    regionHint: 'Европа',
  ),
  PaymentMethodOption(
    id: 'klarna',
    title: 'Klarna',
    subtitle: 'Оплата частями',
    icon: Icons.schedule_outlined,
    methodTypes: ['klarna'],
    regionHint: 'США и Европа',
  ),
  PaymentMethodOption(
    id: 'paypal',
    title: 'PayPal',
    subtitle: 'Требуется подключение PayPal-аккаунта',
    icon: Icons.payments_outlined,
    methodTypes: [],
    regionHint: 'США и Европа',
  ),
  PaymentMethodOption(
    id: 'bank_transfer',
    title: 'Wise / Revolut',
    subtitle: 'Банковский перевод, зачисление вручную',
    icon: Icons.swap_horiz,
    methodTypes: [],
    regionHint: 'Европа',
  ),
];

/// Пополнение кошелька для платформ без RevenueCat (веб).
///
/// Пакет и способ оплаты уходят в Cloud Function `createCheckoutSession`,
/// которая создаёт сессию Stripe Checkout. Баланс начисляет вебхук на
/// сервере — клиент его не трогает.
class PaymentMethodsSection extends StatefulWidget {
  const PaymentMethodsSection({super.key});

  @override
  State<PaymentMethodsSection> createState() => _PaymentMethodsSectionState();
}

class _PaymentMethodsSectionState extends State<PaymentMethodsSection> {
  int _selectedPackage = 1;
  String _selectedMethod = kPaymentMethods.first.id;
  bool _loading = false;

  PaymentMethodOption get _method =>
      kPaymentMethods.firstWhere((m) => m.id == _selectedMethod);

  Future<void> _startCheckout() async {
    final method = _method;
    if (!method.isAvailable) {
      _showMessage('Этот способ оплаты пока не подключён');
      return;
    }

    setState(() => _loading = true);
    try {
      final package = kTopUpPackages[_selectedPackage];
      final callable =
          FirebaseFunctions.instance.httpsCallable('createCheckoutSession');
      final result = await callable.call(<String, dynamic>{
        'credits': package.credits,
        'methodTypes': method.methodTypes,
      });

      final url = result.data is Map ? result.data['url'] as String? : null;
      if (url == null || url.isEmpty) {
        _showMessage('Не удалось создать платёж, попробуйте позже');
        return;
      }
      await launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
    } catch (e) {
      debugPrint('Checkout error: $e');
      _showMessage('Ошибка оплаты: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: kTopUpPackages.asMap().entries.map((entry) {
              final isSelected = entry.key == _selectedPackage;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () => setState(() => _selectedPackage = entry.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: isSelected
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).border,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${entry.value.credits}',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            entry.value.priceLabel,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Способ оплаты',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          const SizedBox(height: 12.0),
          ...kPaymentMethods.map(_buildMethodTile),
          const SizedBox(height: 24.0),
          FFButtonWidget(
            onPressed: _loading ? null : _startCheckout,
            text: _loading
                ? 'Создаём платёж...'
                : 'Оплатить ${kTopUpPackages[_selectedPackage].priceLabel}',
            options: FFButtonOptions(
              width: double.infinity,
              height: 56.0,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              elevation: 0.0,
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(30.0),
              disabledColor: FlutterFlowTheme.of(context).buttonDisabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile(PaymentMethodOption method) {
    final isSelected = method.id == _selectedMethod;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => setState(() => _selectedMethod = method.id),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).border,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                method.icon,
                size: 24.0,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          method.title,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                        if (method.regionHint != null) ...[
                          const SizedBox(width: 8.0),
                          Text(
                            method.regionHint!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Inter',
                                  fontSize: 11.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      method.subtitle,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20.0,
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
