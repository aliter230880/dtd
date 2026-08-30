import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/verification.dart';
import '../services/fmcsa_service.dart';
import '../services/validators.dart';
import '../services/vin_service.dart';
import '../widgets/verified_field.dart';
import '../widgets/trust_badge.dart';
import '../widgets/dtd_ui.dart';
import '../theme/tokens.dart';
import 'individual_kyc_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  final _vin = VinService();
  // Проверка DOT идёт через callable-функцию verifyCarrierDot; если она
  // не задеплоена, сервис сам отвечает в демо-режиме и помечает это.
  final _fmcsa = FmcsaService();

  final Map<String, VerificationResult> _results = {};
  String _dealerState = 'CA';

  void _record(String key, VerificationResult r) =>
      setState(() => _results[key] = r);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T.bg,
      body: SafeArea(        child: Column(
          children: [
            _header(),
            Material(
              color: T.surface,
              child: TabBar(
                controller: _tabs,
                // Жёлтая пилюля вместо подчёркивания — как в таб-баре макетов.
                indicator: BoxDecoration(
                  color: T.accent,
                  borderRadius: BorderRadius.circular(T.rPill),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.circular(T.rPill),
                labelColor: T.onAccent,
                unselectedLabelColor: T.textMuted,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5),
                tabs: const [
                  Tab(icon: Icon(Icons.local_shipping_outlined, size: 19),
                      text: 'Компания'),
                  Tab(icon: Icon(Icons.person_outline_rounded, size: 19),
                      text: 'Физлицо'),
                  Tab(icon: Icon(Icons.store_mall_directory_outlined, size: 19),
                      text: 'Дилер'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _carrierTab(),
                  const IndividualKycScreen(),
                  _dealerTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      color: T.surface,
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 14),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 52,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: T.text, size: 25),
                ),
              ),
              const Expanded(
                child: Text('Верификация документов',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: T.text)),
              ),
              const SizedBox(width: 52),
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: DtdNotice(
              icon: Icons.info_outline,
              color: T.textMuted,
              background: T.bg,
              border: T.divider,
              text: 'VIN проверяется в базе NHTSA vPIC, USDOT — в реестре FMCSA '
                  'через сервер. Если серверная проверка ещё не подключена, '
                  'ответ приходит в демо-режиме и это указано в сообщении.',
            ),
          ),
        ],
      ),
    );
  }

  // ================= ПЕРЕВОЗЧИК =================
  Widget _carrierTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
      children: [
        _sectionTitle('Реестр FMCSA', 'Уровень 2 — официальный источник',
            T.ok),
        const SizedBox(height: 14),
        VerifiedField(
          label: 'USDOT Number',
          hint: '76830',
          icon: Icons.badge_outlined,
          helper: 'Найдём компанию в реестре FMCSA и заполним поля сами',
          maxLength: 8,
          formatters: [FilteringTextInputFormatter.digitsOnly],
          localValidator: Validators.validateDot,
          registryValidator: _fmcsa.verifyDot,
          onResult: (_, r) => _record('dot', r),
        ),
        VerifiedField(
          label: 'MC / MX Number',
          hint: 'MC-135790',
          icon: Icons.confirmation_number_outlined,
          helper: 'Docket number. Заполнится автоматически после USDOT',
          uppercase: true,
          localValidator: Validators.validateMc,
          onResult: (_, r) => _record('mc', r),
        ),
        const SizedBox(height: 6),
        _sectionTitle('Автомобиль', 'Уровень 2 — NHTSA vPIC, работает вживую',
            T.ok),
        const SizedBox(height: 14),
        VerifiedField(
          label: 'VIN автомобиля',
          hint: '1HGCM82633A004352',
          icon: Icons.directions_car_outlined,
          helper: 'Контрольная цифра считается офлайн, затем запрос к NHTSA',
          maxLength: 17,
          uppercase: true,
          localValidator: Validators.validateVin,
          registryValidator: _vin.decode,
          onResult: (_, r) => _record('vin', r),
        ),
        const SizedBox(height: 6),
        _sectionTitle('Водитель', 'Уровень 3 — только ручная модерация',
            T.review),
        const SizedBox(height: 14),
        VerifiedField(
          label: 'Номер водительского удостоверения',
          hint: 'D1234567',
          icon: Icons.credit_card_outlined,
          uppercase: true,
          localValidator: (v) => Validators.validateDriverLicense(v, 'CA'),
          onResult: (_, r) => _record('dl', r),
        ),
        _limitationNote(),
        const SizedBox(height: 20),
        TrustBadgePreview(results: _results, isCarrier: true),
      ],
    );
  }

  // ================= ДИЛЕР =================
  Widget _dealerTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: T.warnBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: T.warnBorder),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: T.warn, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Единого федерального реестра дилерских лицензий в США не '
                  'существует — их выдают 50 отдельных DMV штатов, и API почти '
                  'ни у кого нет. Поэтому автозаполнение здесь невозможно: '
                  'максимум — маска штата, дальше модерация по документу.',
                  style: TextStyle(
                      fontSize: 12, height: 1.4, color: T.warn),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _sectionTitle('Лицензия дилера', 'Уровень 1 + 3 — маска и модерация',
            T.review),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _dealerState,
          decoration: InputDecoration(
            labelText: 'Штат выдачи',
            prefixIcon: const Icon(Icons.map_outlined),
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          items: Validators.dealerLicensePatterns.keys
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _dealerState = v ?? 'CA'),
        ),
        const SizedBox(height: 18),
        VerifiedField(
          // key форсирует пересоздание при смене штата, чтобы
          // валидатор применился к новой маске.
          key: ValueKey(_dealerState),
          label: 'Номер дилерской лицензии ($_dealerState)',
          hint: Validators.dealerLicensePatterns[_dealerState]!.$2,
          icon: Icons.article_outlined,
          helper: 'Маска: ${Validators.dealerLicensePatterns[_dealerState]!.$2}',
          uppercase: true,
          localValidator: (v) =>
              Validators.validateDealerLicense(v, _dealerState),
          onResult: (_, r) => _record('dealer_license', r),
        ),
        _sectionTitle('Автомобиль в сделке', 'Уровень 2 — NHTSA vPIC',
            T.ok),
        const SizedBox(height: 14),
        VerifiedField(
          label: 'VIN выставляемого авто',
          hint: '3VWFE21C04M000001',
          icon: Icons.directions_car_outlined,
          helper: 'Марка, модель и год подтягиваются из базы NHTSA',
          maxLength: 17,
          uppercase: true,
          localValidator: Validators.validateVin,
          registryValidator: _vin.decode,
          onResult: (_, r) => _record('dealer_vin', r),
        ),
        const SizedBox(height: 8),
        _uploadStub(),
        const SizedBox(height: 20),
        TrustBadgePreview(results: _results, isCarrier: false),
      ],
    );
  }

  Widget _sectionTitle(String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(width: 3.5, height: 34,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14.5, fontWeight: FontWeight.w800)),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _limitationNote() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFCE93D8)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gavel_rounded, size: 18, color: Color(0xFF6A1B9A)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Базы DMV по правам закрыты для приложений законом DPPA, '
              'AAMVA DLDV недоступен. Подтверждение личности и прав — '
              'через Stripe Identity (скан + liveness), история нарушений '
              '(MVR) — через Checkr по согласию FCRA.',
              style: TextStyle(
                  fontSize: 11.5, height: 1.45, color: Color(0xFF4A148C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadStub() {
    return DottedUploadBox(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Загрузка в Storage + запись на модерацию '
              '(admin-интерфейса в проекте пока нет)'),
        ),
      ),
    );
  }
}

class DottedUploadBox extends StatelessWidget {
  final VoidCallback onTap;
  const DottedUploadBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black26, style: BorderStyle.solid),
        ),
        child: const Column(
          children: [
            Icon(Icons.cloud_upload_outlined,
                size: 30, color: Color(0xFF0B4C8C)),
            SizedBox(height: 8),
            Text('Загрузить копию лицензии',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            SizedBox(height: 3),
            Text('PDF или фото · проверит модератор',
                style: TextStyle(fontSize: 11, color: T.textMuted)),
          ],
        ),
      ),
    );
  }
}
