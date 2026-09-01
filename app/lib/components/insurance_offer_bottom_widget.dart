import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

/// Предложение оформить страховку в момент отправки машины перевозчику.
///
/// Показывается дилеру после выбора перевозчика — это последний момент, когда
/// ещё можно застраховать перевозку, и первый, когда известны все данные для
/// расчёта: перевозчик, итоговая цена и автомобиль.
///
/// Почему именно здесь, а не только на этапе создания заказа:
/// на создании заказа `insurance_required` — это лишь пожелание дилера,
/// перевозчик тогда ещё не выбран и премию посчитать не по кому. Тариф зависит
/// от того, КОМУ отдают машину: у физлица без FMCSA-авторитета риск выше.
///
/// Возвращает через `Navigator.pop`:
/// * `{'insured': true, 'quote': {...}}` — дилер оплатил страховку;
/// * `{'insured': false}` — отказался, но подтвердил осознанно;
/// * `null` — закрыл лист, отправку машины продолжать НЕ нужно.
class InsuranceOfferBottomWidget extends StatefulWidget {
  const InsuranceOfferBottomWidget({
    super.key,
    required this.dealRef,
    required this.carName,
    required this.price,
    this.carrierIsIndividual = false,
    this.carrierHasOwnInsurance = false,
  });

  /// Ссылка на заказ — по ней Cloud Function считает премию.
  final DocumentReference dealRef;

  /// Название автомобиля для показа в листе.
  final String carName;

  /// Итоговая цена перевозки в долларах.
  final int price;

  /// Перевозчик — физлицо. Влияет на текст предупреждения: у физлица
  /// нет FMCSA-авторитета и, как правило, нет коммерческого покрытия.
  final bool carrierIsIndividual;

  /// У перевозчика есть подтверждённый полис non-owned auto liability.
  final bool carrierHasOwnInsurance;

  @override
  State<InsuranceOfferBottomWidget> createState() =>
      _InsuranceOfferBottomWidgetState();
}

class _InsuranceOfferBottomWidgetState
    extends State<InsuranceOfferBottomWidget> {
  /// Премия в центах. null — ещё считается или расчёт не удался.
  int? _premiumCents;

  /// Идентификатор квоты от страхового провайдера.
  String? _quoteId;
  String? _provider;

  bool _loadingQuote = true;
  bool _purchasing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Квота запрашивается сразу: дилер не должен ждать лишний тап,
    // чтобы увидеть цену.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadQuote());
  }

  Future<void> _loadQuote() async {
    setState(() {
      _loadingQuote = true;
      _error = null;
    });

    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('calculateInsuranceQuote');
      final result = await callable.call<Map<String, dynamic>>({
        'dealId': widget.dealRef.id,
      });

      final data = result.data;
      final cost = data['cost'];
      if (cost is! int) {
        throw StateError('Некорректный ответ расчёта премии');
      }

      if (!mounted) return;
      setState(() {
        _premiumCents = cost;
        _quoteId = data['quoteId'] as String?;
        _provider = data['provider'] as String?;
        _loadingQuote = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingQuote = false;
        // Ошибку показываем явно, а не глотаем: молча спрятанное
        // предложение страховки — это непроданный полис и незакрытый риск.
        _error = 'Не удалось рассчитать стоимость страховки. '
            'Можно попробовать снова или отправить машину без страховки.';
      });
    }
  }

  Future<void> _purchase() async {
    if (_premiumCents == null || _purchasing) return;

    setState(() {
      _purchasing = true;
      _error = null;
    });

    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('purchaseInsurance');
      final result = await callable.call<Map<String, dynamic>>({
        'dealId': widget.dealRef.id,
        'quoteId': _quoteId,
      });

      final data = result.data;
      if (data['success'] != true) {
        throw StateError(data['message']?.toString() ?? 'Оплата не прошла');
      }

      if (!mounted) return;
      Navigator.of(context).pop(<String, dynamic>{
        'insured': true,
        'quote': {
          'insurance_quote_id': _quoteId,
          'insurance_provider': _provider,
          'insurance_premium': _premiumCents,
          'insurance_policy_id': data['policyId'],
          'insurance_policy_url': data['policyUrl'],
        },
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _purchasing = false;
        _error = 'Оплата не прошла. Машина не отправлена — '
            'попробуйте ещё раз или откажитесь от страховки.';
      });
    }
  }

  /// Отказ от страховки. Требует осознанного подтверждения:
  /// это решение стоимостью в автомобиль.
  Future<void> _declineWithConfirm() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        title: const Text('Отправить без страховки?'),
        content: Text(
          widget.carrierIsIndividual && !widget.carrierHasOwnInsurance
              ? 'Перевозчик — физическое лицо без подтверждённого полиса '
                  'non-owned auto liability. При повреждении или утрате '
                  'автомобиля возмещение придётся требовать лично с водителя.'
              : 'При повреждении или утрате автомобиля в пути платформа '
                  'не возмещает ущерб.',
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Назад'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Отправить без страховки',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop(<String, dynamic>{'insured': false});
    }
  }

  String get _premiumLabel {
    final cents = _premiumCents;
    if (cents == null) return '—';
    return '\$${(cents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: theme.alternate,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            Text(
              'Застраховать перевозку',
              style: theme.headlineSmall.override(
                fontFamily: 'Inter',
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${widget.carName} · перевозка \$${widget.price}',
              style: theme.bodyMedium.override(
                fontFamily: 'Inter',
                color: theme.secondaryText,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
            ),
            const SizedBox(height: 20.0),
            _riskNotice(theme),
            const SizedBox(height: 20.0),
            _premiumRow(theme),
            if (_error != null) ...[
              const SizedBox(height: 12.0),
              Text(
                _error!,
                style: theme.bodySmall.override(
                  fontFamily: 'Inter',
                  color: theme.error,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
              ),
            ],
            const SizedBox(height: 20.0),
            FFButtonWidget(
              onPressed: _premiumCents == null || _purchasing
                  ? null
                  : () => _purchase(),
              text: _purchasing
                  ? 'Оплата...'
                  : _premiumCents == null
                      ? 'Расчёт стоимости...'
                      : 'Оплатить $_premiumLabel и отправить',
              options: FFButtonOptions(
                width: double.infinity,
                height: 56.0,
                color: theme.primary,
                textStyle: theme.titleSmall.override(
                  fontFamily: 'Inter',
                  color: theme.primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  useGoogleFonts: false,
                ),
                elevation: 0.0,
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(28.0),
                disabledColor: theme.alternate,
                disabledTextColor: theme.secondaryText,
              ),
            ),
            if (_error != null && _premiumCents == null) ...[
              const SizedBox(height: 8.0),
              Center(
                child: TextButton(
                  onPressed: _loadingQuote ? null : _loadQuote,
                  child: const Text('Пересчитать'),
                ),
              ),
            ],
            const SizedBox(height: 4.0),
            Center(
              child: TextButton(
                onPressed: _purchasing ? null : _declineWithConfirm,
                child: Text(
                  'Отправить без страховки',
                  style: theme.bodyMedium.override(
                    fontFamily: 'Inter',
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Плашка с объяснением риска. Текст зависит от того, кому отдают машину.
  Widget _riskNotice(FlutterFlowTheme theme) {
    final String message;
    if (widget.carrierHasOwnInsurance) {
      message = 'У перевозчика есть подтверждённый полис. Страховка платформы '
          'покрывает ущерб сверх его лимита.';
    } else if (widget.carrierIsIndividual) {
      message = 'Перевозчик — физическое лицо. Личный автополис обычно '
          'не покрывает перегон чужого автомобиля за плату.';
    } else {
      message = 'Автомобиль передаётся другой компании. Страховка покрывает '
          'повреждение и утрату в пути.';
    }

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: const Color(0xFFF0D089)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined,
              size: 20.0, color: Color(0xFFB26A00)),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              message,
              style: theme.bodySmall.override(
                fontFamily: 'Inter',
                color: const Color(0xFF7A4A00),
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumRow(FlutterFlowTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Стоимость страховки',
          style: theme.bodyMedium.override(
            fontFamily: 'Inter',
            letterSpacing: 0.0,
            useGoogleFonts: false,
          ),
        ),
        if (_loadingQuote)
          const SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          )
        else
          Text(
            _premiumLabel,
            style: theme.titleMedium.override(
              fontFamily: 'Inter',
              letterSpacing: 0.0,
              useGoogleFonts: false,
            ),
          ),
      ],
    );
  }
}
