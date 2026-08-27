import 'package:flutter/material.dart';
import '../models/verification.dart';
import '../theme/tokens.dart';

/// Предпросмотр публичного бейджа доверия.
///
/// Продуктовый смысл: бейдж «Проверен» НЕ может значить одно и то же для
/// компании с подтверждённым DOT и для человека, загрузившего фото прав.
/// Поэтому уровень выводится из того, что реально подтверждено реестром,
/// а не из факта заполнения формы.
class TrustBadgePreview extends StatelessWidget {
  final Map<String, VerificationResult> results;
  final bool isCarrier;

  /// Физлицо. Уровень доверия НИЖЕ компании с DOT — дилер, отдающий авто
  /// за $80k, вправе не видеть таких предложений (фильтр «только компании»).
  final bool isIndividual;

  const TrustBadgePreview({
    super.key,
    required this.results,
    required this.isCarrier,
    this.isIndividual = false,
  });

  bool _isVerified(String key) =>
      results[key]?.status.grantsBadge ?? false;

  bool get _hasBlocking =>
      results.values.any((r) => r.status.isBlocking);

  /// Итоговый уровень доверия.
  ({String label, String sub, Color color, IconData icon}) _resolve() {
    if (_hasBlocking) {
      return (
        label: 'Есть расхождения',
        sub: 'Часть номеров не прошла проверку — бейдж не выдаётся',
        color: T.danger,
        icon: Icons.gpp_bad_rounded,
      );
    }

    if (isIndividual) {
      final identity = results['identity_verified']?.status;
      final insurance = results['insurance_verified']?.status;
      final identityOk = identity == VerificationStatus.verified ||
          identity == VerificationStatus.pendingProvider;
      final insuranceOk = insurance == VerificationStatus.needsReview ||
          insurance == VerificationStatus.verified;

      if (identityOk && insuranceOk) {
        return (
          label: 'Личность подтверждена',
          sub: 'Stripe Identity + полис на модерации. Уровень ниже, чем '
              '«Компания · DOT подтверждён»',
          color: T.provider,
          icon: Icons.person_pin_circle_rounded,
        );
      }
      if (identityOk) {
        return (
          label: 'Личность подтверждена · без страховки',
          sub: 'Нет полиса non-owned auto liability — допуск к заказам '
              'должен быть закрыт: это главный финансовый риск платформы',
          color: T.warn,
          icon: Icons.shield_outlined,
        );
      }
      return (
        label: 'Не подтверждён',
        sub: 'Пройдите проверку личности через Stripe Identity',
        color: T.neutral,
        icon: Icons.shield_outlined,
      );
    }

    if (isCarrier) {
      final dot = _isVerified('dot');
      final vin = _isVerified('vin');
      if (dot && vin) {
        return (
          label: 'Компания · DOT подтверждён',
          sub: 'FMCSA + NHTSA. Высший уровень: виден дилерам в фильтре '
              '«только компании»',
          color: T.ok,
          icon: Icons.verified_rounded,
        );
      }
      if (dot) {
        return (
          label: 'Компания · DOT подтверждён',
          sub: 'Авторитет FMCSA действителен',
          color: T.ok,
          icon: Icons.verified_rounded,
        );
      }
      return (
        label: 'Не подтверждён',
        sub: 'Введите USDOT — без подтверждения реестром отклик на заказы '
            'должен быть закрыт',
        color: T.neutral,
        icon: Icons.shield_outlined,
      );
    }

    final lic = results['dealer_license']?.status ==
        VerificationStatus.needsReview;
    final vin = _isVerified('dealer_vin');
    if (lic && vin) {
      return (
        label: 'Дилер · документ на модерации',
        sub: 'Формат лицензии верен, VIN подтверждён NHTSA. Финальный статус — '
            'после проверки модератором',
        color: T.review,
        icon: Icons.assignment_ind_rounded,
      );
    }
    if (lic) {
      return (
        label: 'Дилер · документ на модерации',
        sub: 'Реестра нет — подтверждает модератор',
        color: T.review,
        icon: Icons.assignment_ind_rounded,
      );
    }
    return (
      label: 'Не подтверждён',
      sub: 'Заполните номер лицензии',
      color: T.neutral,
      icon: Icons.shield_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = _resolve();
    final canSubmit = !_hasBlocking &&
        results.values.any((r) => r.status.allowsSubmit);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.color.withValues(alpha: 0.3), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Как вас увидят в приложении',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: T.textFaint)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: t.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(t.icon, color: t.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.label,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: t.color)),
                    const SizedBox(height: 3),
                    Text(t.sub,
                        style: const TextStyle(
                            fontSize: 11.5,
                            height: 1.4,
                            color: T.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canSubmit ? () => _showSubmitInfo(context) : null,
              style: FilledButton.styleFrom(
                backgroundColor: T.accent,
                foregroundColor: T.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.lock_outline_rounded, size: 18),
              label: const Text('Отправить на верификацию',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Флаг verified пишется только Cloud Function. Клиент не может '
            'установить его сам — иначе бейдж подделывается вызовом Firestore API.',
            style: TextStyle(fontSize: 10.5, height: 1.4, color: T.textFaint),
          ),
        ],
      ),
    );
  }

  void _showSubmitInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Что уйдёт на сервер',
                style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            ...results.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Icon(
                        e.value.status.grantsBadge
                            ? Icons.check_circle
                            : Icons.remove_circle_outline,
                        size: 16,
                        color: e.value.status.grantsBadge
                            ? T.ok
                            : Colors.black38,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          '${e.key} → ${e.value.status.name}'
                          '${e.value.source != null ? ' · ${e.value.source}' : ''}',
                          style: const TextStyle(
                              fontSize: 12.5, fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 6),
            const Text(
              'Каждая запись сохраняется с провенансом: source, checked_at, '
              'expires_at и сырым ответом реестра — для аудита и разбора споров.',
              style:
                  TextStyle(fontSize: 11.5, height: 1.45, color: T.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
