/// Верификация физлица-перегонщика.
///
/// Структура и стиль — по макетам «Введите данные» / «Ваши данные»:
/// серый лейбл над белым полем, статус подписью снизу, жёлтая таблетка
/// действия внизу экрана, чёрная кнопка для второстепенных действий.
///
/// Логика слоёв — по таблице KYC из ARCHITECTURE.md.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_kind.dart';
import '../models/verification.dart';
import '../services/kyc_service.dart';
import '../services/validators.dart';
import '../theme/tokens.dart';
import '../widgets/dtd_ui.dart';
import '../widgets/verified_field.dart';

class IndividualKycScreen extends StatefulWidget {
  const IndividualKycScreen({super.key});

  @override
  State<IndividualKycScreen> createState() => _IndividualKycScreenState();
}

class _IndividualKycScreenState extends State<IndividualKycScreen> {
  final _kyc = const KycService();

  final Map<String, VerificationResult> _fields = {};
  final Map<KycLayer, VerificationResult> _layers = {};

  String _state = 'CA';
  bool _mvrConsent = false;
  bool _insuranceFile = false;
  bool _nonOwned = false;
  bool _busy = false;

  void _setField(String key, VerificationResult r) =>
      setState(() => _fields[key] = r);

  bool get _dobOk => _fields['dob']?.status.grantsBadge ?? false;
  bool get _ssnOk =>
      _fields['ssn']?.status == VerificationStatus.needsReview;

  @override
  Widget build(BuildContext context) {
    final access = KycService.resolveIndividualAccess(_layers);

    return Container(
      color: T.bg,
      child: Column(
        children: [
          const DtdHeader(title: 'Введите данные'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Для идентификации необходимо заполнить ваши данные',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.5, height: 1.45, color: T.textMuted),
                  ),
                  const SizedBox(height: 22),

                  // ---- Слой 1: базовые поля, проверяются офлайн ----
                  VerifiedField(
                    label: 'Дата рождения',
                    hint: '27.08.2000',
                    icon: Icons.cake_outlined,
                    maxLength: 10,
                    helper: '49 CFR §391.11: для перевозок между штатами '
                        'нужно 21 год',
                    localValidator: Validators.validateDateOfBirth,
                    onResult: (_, r) => _setField('dob', r),
                  ),
                  VerifiedField(
                    label: 'Телефон',
                    hint: '(555) 123-4567',
                    icon: Icons.phone_outlined,
                    maxLength: 14,
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9()\s-]')),
                    ],
                    localValidator: Validators.validateUsPhone,
                    onResult: (_, r) => _setField('phone', r),
                  ),
                  VerifiedField(
                    label: 'SSN',
                    hint: '123-45-6789',
                    icon: Icons.badge_outlined,
                    maxLength: 11,
                    helper: 'Проверяется по правилам выпуска SSA локально. '
                        'В базу платформы не сохраняется',
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                    ],
                    localValidator: Validators.validateSsn,
                    onResult: (_, r) => _setField('ssn', r),
                  ),

                  // Номер прав. В текущем приложении на это поле стоит
                  // keyboardType: number и фильтр [0-9] — валидный номер вида
                  // D1234567 ввести физически невозможно. Здесь буквы разрешены.
                  _stateSelector(),
                  const SizedBox(height: 16),
                  VerifiedField(
                    key: ValueKey('dl_$_state'),
                    label: 'Номер водительских прав ($_state)',
                    hint: 'D1234567',
                    icon: Icons.credit_card_outlined,
                    uppercase: true,
                    maxLength: 20,
                    helper: 'Буквы обязательны: в большинстве штатов номер '
                        'буквенно-цифровой',
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9*-]')),
                    ],
                    localValidator: (v) =>
                        Validators.validateDriverLicense(v, _state),
                    onResult: (_, r) => _setField('dl', r),
                  ),

                  const SizedBox(height: 8),
                  const DtdSectionTitle(
                    'Проверки',
                    hint: 'Личность и страховку нельзя подтвердить формой — '
                        'их закрывает провайдер или модератор',
                  ),
                  const SizedBox(height: 16),

                  _layerCard(KycLayer.identity),
                  const SizedBox(height: 12),
                  _layerCard(KycLayer.insurance),
                  const SizedBox(height: 12),
                  _layerCard(KycLayer.drivingRecord),
                  const SizedBox(height: 12),
                  _layerCard(KycLayer.criminal),

                  const SizedBox(height: 22),
                  _accessCard(access),
                  const SizedBox(height: 20),
                  DtdPrimaryButton(
                    label: 'Сохранить',
                    icon: Icons.lock_outline_rounded,
                    onPressed: access.allowed ? () => _save(context) : null,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Статус verified записывает только Cloud Function по '
                    'вебхуку провайдера. Клиент не может выставить его сам.',
                    style: TextStyle(
                        fontSize: 10.5, height: 1.45, color: T.textFaint),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 7),
          child: Text('Штат выдачи прав',
              style: TextStyle(fontSize: 14, color: T.textFaint)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: T.surface,
            borderRadius: BorderRadius.circular(T.rField),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _state,
              isExpanded: true,
              borderRadius: BorderRadius.circular(T.rField),
              icon: const Icon(Icons.expand_more, color: T.textMuted),
              style: const TextStyle(fontSize: 16, color: T.text),
              items: Validators.dealerLicensePatterns.keys
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(s),
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _state = v ?? 'CA'),
            ),
          ),
        ),
      ],
    );
  }

  /// Карточка слоя KYC. Показывает, кто проверяет и сколько это стоит —
  /// стоимость видна намеренно: она объясняет, почему форматная отсечка
  /// (SSN, возраст) обязана срабатывать раньше запроса к провайдеру.
  Widget _layerCard(KycLayer layer) {
    final res = _layers[layer];
    final st = res?.status;
    final done = st == VerificationStatus.pendingProvider ||
        st == VerificationStatus.needsReview ||
        (st?.grantsBadge ?? false);

    final Color accent = switch (st) {
      VerificationStatus.pendingProvider => T.provider,
      VerificationStatus.needsReview => T.review,
      VerificationStatus.mismatch => T.danger,
      VerificationStatus.invalidFormat => T.danger,
      VerificationStatus.verified => T.ok,
      _ => T.textFaint,
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: T.surface,
        borderRadius: BorderRadius.circular(T.rCard),
        border: Border.all(
          color: done ? accent.withValues(alpha: 0.45) : T.divider,
          width: done ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(T.rChip),
                ),
                child: Icon(_layerIcon(layer), size: 20, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          layer.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: T.text,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (layer.requiredAtLaunch)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: T.accent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'обязательно',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: T.onAccent,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: T.bg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: T.divider),
                            ),
                            child: const Text(
                              '2-й этап',
                              style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: T.textMuted),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${layer.what} · ${layer.vendor}',
                      style: const TextStyle(
                          fontSize: 12.5, color: T.textMuted, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (res?.message != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_statusIcon(st), size: 17, color: accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    res!.message!,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 13),
          ..._layerControls(layer, done),
        ],
      ),
    );
  }

  List<Widget> _layerControls(KycLayer layer, bool done) {
    switch (layer) {
      case KycLayer.identity:
        final blocked = !_dobOk || !_ssnOk;
        return [
          if (blocked)
            const Text(
              'Сначала заполните дату рождения и SSN — форматная проверка '
              r'бесплатна, а запрос к провайдеру стоит $1.50',
              style: TextStyle(fontSize: 12, height: 1.4, color: T.textFaint),
            )
          else
            DtdDarkButton(
              label: done ? 'Проверка запущена' : 'Пройти проверку личности',
              onPressed: done || _busy
                  ? null
                  : () async {
                      setState(() => _busy = true);
                      final r = await _kyc.startIdentitySession(
                        dateOfBirth: '',
                        ssnLast4: null,
                      );
                      if (!mounted) return;
                      setState(() {
                        _layers[KycLayer.identity] = r;
                        _busy = false;
                      });
                    },
            ),
        ];

      case KycLayer.insurance:
        return [
          DtdFileRow(
            title: 'Фото полиса',
            subtitle: _insuranceFile ? 'Файл загружен' : 'Не загружен',
            uploaded: _insuranceFile,
            onUpload: () => setState(() => _insuranceFile = true),
            onDelete: () => setState(() {
              _insuranceFile = false;
              _layers.remove(KycLayer.insurance);
            }),
          ),
          const SizedBox(height: 10),
          _check(
            value: _nonOwned,
            onChanged: (v) => setState(() => _nonOwned = v),
            text: 'В полисе есть покрытие non-owned auto liability '
                '(вождение чужого авто за плату)',
          ),
          const SizedBox(height: 8),
          DtdDarkButton(
            label: 'Отправить на модерацию',
            onPressed: !_insuranceFile || _busy
                ? null
                : () async {
                    setState(() => _busy = true);
                    final r = await _kyc.submitInsurance(
                      fileAttached: _insuranceFile,
                      nonOwnedCoverage: _nonOwned,
                    );
                    if (!mounted) return;
                    setState(() {
                      _layers[KycLayer.insurance] = r;
                      _busy = false;
                    });
                  },
          ),
        ];

      case KycLayer.drivingRecord:
        return [
          _check(
            value: _mvrConsent,
            onChanged: (v) => setState(() => _mvrConsent = v),
            text: 'Согласен на проверку водительской истории (требование FCRA)',
          ),
          const SizedBox(height: 8),
          DtdDarkButton(
            label: 'Запросить MVR',
            onPressed: _busy
                ? null
                : () async {
                    setState(() => _busy = true);
                    final r = await _kyc.startMvrCheck(
                      hasConsent: _mvrConsent,
                      state: _state,
                    );
                    if (!mounted) return;
                    setState(() {
                      _layers[KycLayer.drivingRecord] = r;
                      _busy = false;
                    });
                  },
          ),
        ];

      case KycLayer.criminal:
        return [
          const Text(
            'Подключается вторым этапом, когда пойдёт реальный трафик. '
            'Регулируется FCRA — нужно отдельное согласие и процедура '
            'adverse action при отказе.',
            style: TextStyle(fontSize: 12, height: 1.45, color: T.textFaint),
          ),
        ];
    }
  }

  Widget _check({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String text,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 22,
              color: value ? T.accentStrong : T.textFaint,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 12.5, height: 1.4, color: T.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  /// Итоговый допуск. Отдельная карточка, потому что физлицо и компания
  /// НЕ равны по уровню доверия — дилер вправе не видеть предложений физлиц.
  Widget _accessCard(({bool allowed, String label, String reason}) a) {
    final color = a.allowed ? T.provider : T.neutral;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: T.surface,
        borderRadius: BorderRadius.circular(T.rCard),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'КАК ВАС УВИДЯТ В ПРИЛОЖЕНИИ',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: T.textFaint,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(T.rChip),
                ),
                child: Icon(
                  a.allowed
                      ? Icons.person_pin_circle_rounded
                      : Icons.shield_outlined,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      a.reason,
                      style: const TextStyle(
                          fontSize: 12, height: 1.4, color: T.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _layerIcon(KycLayer l) => switch (l) {
        KycLayer.identity => Icons.face_rounded,
        KycLayer.drivingRecord => Icons.directions_car_outlined,
        KycLayer.criminal => Icons.fingerprint_rounded,
        KycLayer.insurance => Icons.shield_outlined,
      };

  IconData _statusIcon(VerificationStatus? s) => switch (s) {
        VerificationStatus.pendingProvider => Icons.hourglass_top_rounded,
        VerificationStatus.needsReview => Icons.assignment_ind_outlined,
        VerificationStatus.verified => Icons.verified_rounded,
        VerificationStatus.mismatch => Icons.gpp_bad_rounded,
        VerificationStatus.invalidFormat => Icons.error_outline_rounded,
        _ => Icons.info_outline_rounded,
      };

  void _save(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: T.surface,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Что уйдёт на сервер',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            const Text(
              'carrier_kind: individual\n'
              'verification_method: identity\n'
              'type: Carrier — роль НЕ меняется',
              style: TextStyle(
                  fontSize: 12.5, fontFamily: 'monospace', height: 1.6),
            ),
            const SizedBox(height: 14),
            ..._layers.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(_statusIcon(e.value.status),
                        size: 16, color: T.textMuted),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        '${e.key.fieldKey} → ${e.value.status.name}'
                        '${e.value.source != null ? ' · ${e.value.source}' : ''}',
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'SSN целиком в Firestore не пишется — в платформе остаются '
              'только последние 4 цифры и результат от провайдера.',
              style:
                  TextStyle(fontSize: 11.5, height: 1.45, color: T.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
