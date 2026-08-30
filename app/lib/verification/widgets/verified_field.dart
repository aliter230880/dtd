/// Переиспользуемое поле «ввод + живая проверка».
///
/// Три правила, заложенные в поведение:
///  1. Debounce 700 мс — не дёргаем реестр на каждый символ.
///  2. Гонка запросов гасится счётчиком: ответ на устаревший ввод
///     отбрасывается (иначе быстрый набор даёт результат от старого VIN).
///  3. Сбой сети ≠ ошибка ввода. Статус unavailable не блокирует форму.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/verification.dart';
import '../theme/tokens.dart';

class VerifiedField extends StatefulWidget {
  final String label;
  final String hint;
  final String? helper;
  final IconData icon;
  final int? maxLength;
  final bool uppercase;
  final List<TextInputFormatter> formatters;

  /// Мгновенная локальная проверка (без сети).
  final VerificationResult Function(String) localValidator;

  /// Проверка в реестре. null → поле только форматное.
  final Future<VerificationResult> Function(String)? registryValidator;

  final void Function(String value, VerificationResult result)? onResult;

  const VerifiedField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.localValidator,
    this.registryValidator,
    this.helper,
    this.maxLength,
    this.uppercase = false,
    this.formatters = const [],
    this.onResult,
  });

  @override
  State<VerifiedField> createState() => _VerifiedFieldState();
}

class _VerifiedFieldState extends State<VerifiedField> {
  final _controller = TextEditingController();
  Timer? _debounce;
  VerificationResult _result = const VerificationResult.idle();

  /// Номер последнего инициированного запроса — защита от гонок.
  int _requestId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String raw) {
    _debounce?.cancel();
    final local = widget.localValidator(raw);

    // Локальный результат показываем сразу.
    setState(() => _result = local);

    // Дальше в реестр идём только если формат прошёл.
    if (local.status != VerificationStatus.checking ||
        widget.registryValidator == null) {
      if (local.isTerminal) widget.onResult?.call(raw, local);
      return;
    }

    final myId = ++_requestId;
    _debounce = Timer(const Duration(milliseconds: 700), () async {
      if (!mounted) return;
      setState(() => _result = const VerificationResult.checking());
      final res = await widget.registryValidator!(raw);
      // Ответ устарел — пользователь успел изменить ввод.
      if (!mounted || myId != _requestId) return;
      setState(() => _result = res);
      widget.onResult?.call(raw, res);
    });
  }

  ({Color color, IconData icon, String label}) get _visual {
    switch (_result.status) {
      case VerificationStatus.verified:
        return (
          color: T.ok,
          icon: Icons.verified_rounded,
          label: 'Подтверждено реестром'
        );
      case VerificationStatus.checking:
        return (
          color: T.textMuted,
          icon: Icons.sync_rounded,
          label: 'Проверяем…'
        );
      case VerificationStatus.invalidFormat:
        return (
          color: T.danger,
          icon: Icons.error_outline_rounded,
          label: 'Ошибка формата'
        );
      case VerificationStatus.mismatch:
        return (
          color: T.danger,
          icon: Icons.gpp_bad_rounded,
          label: 'Расхождение с реестром'
        );
      case VerificationStatus.notFound:
        return (
          color: T.warn,
          icon: Icons.search_off_rounded,
          label: 'Не найдено в реестре'
        );
      case VerificationStatus.unavailable:
        return (
          color: T.neutral,
          icon: Icons.cloud_off_rounded,
          label: 'Реестр недоступен'
        );
      case VerificationStatus.pendingProvider:
        return (
          color: T.provider,
          icon: Icons.hourglass_top_rounded,
          label: 'Ожидаем ответ провайдера'
        );
      case VerificationStatus.needsReview:
        return (
          color: T.review,
          icon: Icons.assignment_ind_outlined,
          label: 'На модерацию'
        );
      case VerificationStatus.idle:
        return (
          color: T.divider,
          icon: Icons.circle_outlined,
          label: ''
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = _visual;
    final active = _result.status != VerificationStatus.idle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Лейбл серым НАД полем — как в макетах «Ваши данные» / «Введите данные».
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 7),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              color: T.textFaint,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          maxLength: widget.maxLength,
          style: const TextStyle(fontSize: 16, color: T.text),
          textCapitalization: widget.uppercase
              ? TextCapitalization.characters
              : TextCapitalization.none,
          inputFormatters: [
            if (widget.uppercase) _UpperCaseFormatter(),
            ...widget.formatters,
          ],
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: T.textFaint, fontSize: 15),
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 19),
            suffixIcon: _buildSuffix(v),
            filled: true,
            fillColor: T.surface,
            // Белая карточка без обводки — обводка появляется только как
            // сигнал статуса, чтобы не спорить со спокойным макетом.
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(T.rField),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(T.rField),
              borderSide: active
                  ? BorderSide(color: v.color.withOpacity(0.5), width: 1.4)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(T.rField),
              borderSide: BorderSide(
                  color: active ? v.color : T.accentStrong, width: 1.6),
            ),
          ),
        ),
        if (widget.helper != null && _result.message == null)
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 4),
            child: Text(
              widget.helper!,
              style: const TextStyle(
                  fontSize: 12, height: 1.35, color: T.textFaint),
            ),
          ),
        if (_result.message != null && _result.message!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(v.icon, size: 17, color: v.color),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    _result.message!,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: v.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_result.autofill.isNotEmpty) _AutofillCard(result: _result),
        if (_result.status == VerificationStatus.verified &&
            _result.expiresAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Проверка действительна до '
              '${_fmtDate(_result.expiresAt!)} · источник: ${_result.source}',
              style: const TextStyle(fontSize: 11, color: T.textMuted),
            ),
          ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget? _buildSuffix(({Color color, IconData icon, String label}) v) {
    if (_result.status == VerificationStatus.checking) {
      return const Padding(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
              strokeWidth: 2.2, color: T.accentStrong),
        ),
      );
    }
    // Крестик-очистка — как в макетах. Показываем, пока поле не подтверждено:
    // на подтверждённом важнее видеть галочку.
    if (_result.status == VerificationStatus.idle) {
      if (_controller.text.isEmpty) return null;
      return _clearButton();
    }
    if (!_result.status.grantsBadge && _controller.text.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(v.icon, color: v.color, size: 21),
          _clearButton(),
        ],
      );
    }
    return Icon(v.icon, color: v.color);
  }

  Widget _clearButton() => IconButton(
        icon: const Icon(Icons.close, size: 21, color: T.textMuted),
        splashRadius: 20,
        onPressed: () {
          _debounce?.cancel();
          _requestId++; // гасим ответ на уже стёртый ввод
          _controller.clear();
          setState(() => _result = const VerificationResult.idle());
          widget.onResult?.call('', const VerificationResult.idle());
        },
      );

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

/// Карточка автозаполненных из реестра данных.
class _AutofillCard extends StatelessWidget {
  final VerificationResult result;
  const _AutofillCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final accent = switch (result.tier) {
      VerificationTier.registry => T.ok,
      VerificationTier.provider => T.provider,
      _ => T.review,
    };

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 15, color: accent),
              const SizedBox(width: 6),
              Text(
                'Заполнено из реестра автоматически',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: accent,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...result.autofill.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 104,
                    child: Text(
                      e.key,
                      style: const TextStyle(
                          fontSize: 12, color: T.textMuted, height: 1.3),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
