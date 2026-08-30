/// Развилка «компания / частное лицо».
///
/// Встраивается в существующий fill_profile_type как второй шаг — так и
/// записано в ARCHITECTURE.md. Роль (UserType) при этом НЕ меняется:
/// физлицо-перегонщик остаётся Carrier, различает их только carrier_kind.
///
/// Визуально повторяет карточки «Способ оплаты» из макета пополнения:
/// белая карточка, радио справа, жёлтая обводка и фон у выбранной.
library;

import 'package:flutter/material.dart';
import '../models/user_kind.dart';
import '../theme/tokens.dart';
import '../widgets/dtd_ui.dart';

class CarrierKindScreen extends StatefulWidget {
  final void Function(CarrierKind kind) onSelected;

  const CarrierKindScreen({super.key, required this.onSelected});

  @override
  State<CarrierKindScreen> createState() => _CarrierKindScreenState();
}

class _CarrierKindScreenState extends State<CarrierKindScreen> {
  CarrierKind? _kind;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: T.bg,
      child: Column(
        children: [
          const DtdHeader(title: 'Тип перевозчика'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Выберите, как вы работаете — от этого зависит способ '
                    'проверки документов',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.5, color: T.textMuted, height: 1.45),
                  ),
                  const SizedBox(height: 24),
                  _card(
                    kind: CarrierKind.company,
                    icon: Icons.local_shipping_outlined,
                    title: 'Компания',
                    subtitle: 'Есть USDOT или MC',
                    bullets: const [
                      'Проверка по госреестру FMCSA за секунды',
                      'Автозаполнение названия, адреса, safety rating',
                      'Высший уровень доверия в приложении',
                    ],
                  ),
                  const SizedBox(height: 14),
                  _card(
                    kind: CarrierKind.individual,
                    icon: Icons.person_outline_rounded,
                    title: 'Частное лицо',
                    subtitle: 'Перегон без авторитета FMCSA',
                    bullets: const [
                      'Проверка личности через Stripe Identity',
                      'Нужен полис на вождение чужого авто за плату',
                      'Доступны заказы, где дилер допускает физлиц',
                    ],
                  ),
                  const SizedBox(height: 22),
                  if (_kind == CarrierKind.individual) _legalNotice(),
                  if (_kind == CarrierKind.company) _companyNotice(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
            child: DtdPrimaryButton(
              label: 'Продолжить',
              onPressed:
                  _kind == null ? null : () => widget.onSelected(_kind!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required CarrierKind kind,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> bullets,
  }) {
    final selected = _kind == kind;
    return GestureDetector(
      onTap: () => setState(() => _kind = kind),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
        decoration: BoxDecoration(
          // Как в «Способе оплаты»: выбранная карточка светло-жёлтая с обводкой.
          color: selected ? T.accent.withOpacity(0.16) : T.surface,
          borderRadius: BorderRadius.circular(T.rCard),
          border: Border.all(
            color: selected ? T.accentStrong : T.divider,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 26, color: T.text),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: T.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: T.textMuted),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? T.accentStrong : T.textFaint,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 13),
            ...bullets.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5, left: 2, right: 9),
                      child: Icon(Icons.circle, size: 5, color: T.textFaint),
                    ),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                            fontSize: 13, height: 1.4, color: T.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Честное предупреждение вместо тихого пропуска.
  ///
  /// Требование DOT/MC зависит НЕ от того, компания вы или физлицо, а от
  /// характера перевозки: for-hire между штатами требует авторитета FMCSA
  /// даже от sole proprietor. Просто «отключить проверку для физлиц» — значит
  /// вывести часть перевозок из легального поля и переложить риск на платформу.
  Widget _legalNotice() => const DtdNotice(
        icon: Icons.gavel_rounded,
        text: 'Перевозка чужого имущества за плату между штатами требует '
            'авторитета FMCSA даже от частного лица. Без DOT доступны только '
            'внутриштатные заказы — окончательные правила подтверждает юрист '
            'по транспортному праву США.',
      );

  Widget _companyNotice() => const DtdNotice(
        icon: Icons.verified_outlined,
        color: T.ok,
        background: Color(0xFFEFF6F1),
        border: Color(0xFFCADFD1),
        text: 'Номер USDOT проверяется в реестре FMCSA сразу при вводе: '
            'название компании и статус авторитета подставятся автоматически.',
      );
}
