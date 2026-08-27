/// Общие элементы интерфейса в стиле макетов DTD.
///
/// Снято со скриншотов приложения:
///  * заголовок экрана по центру, стрелка назад слева, без тени;
///  * основное действие — жёлтая таблетка #FAE28C с ЧЁРНЫМ текстом;
///  * вторичное/деструктивное действие — ЧЁРНАЯ таблетка («Удалить»);
///  * загрузка файла — «скрепка + название + статус» и кнопка справа.
library;

import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Заголовок экрана как в макетах: по центру, без AppBar-тени.
class DtdHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const DtdHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: T.surface,
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 16),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: onBack == null
                ? null
                : IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, color: T.text, size: 25),
                  ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: T.text,
              ),
            ),
          ),
          SizedBox(width: 52, child: trailing),
        ],
      ),
    );
  }
}

/// Основное действие. Жёлтая таблетка, чёрный текст — точно как «Сохранить».
class DtdPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const DtdPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: T.accent,
          foregroundColor: T.onAccent,
          disabledBackgroundColor: T.accent.withValues(alpha: 0.45),
          disabledForegroundColor: T.onAccent.withValues(alpha: 0.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(T.rButton),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 20,
                  color: enabled
                      ? T.onAccent
                      : T.onAccent.withValues(alpha: 0.4)),
              const SizedBox(width: 9),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Вторичное действие. Чёрная таблетка — как «Удалить» в макете.
class DtdDarkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool compact;

  const DtdDarkButton({
    super.key,
    required this.label,
    this.onPressed,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 50 : 60,
      width: compact ? null : double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: T.text,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: compact ? 28 : 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(T.rButton),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Строка загрузки документа — структура из макета «Введите данные».
class DtdFileRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool uploaded;
  final VoidCallback? onUpload;
  final VoidCallback? onDelete;

  const DtdFileRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.uploaded,
    this.onUpload,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: T.surface,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.attach_file, size: 22, color: T.text),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: T.text,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                    fontSize: 13, color: T.textFaint, height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        uploaded
            ? DtdDarkButton(label: 'Удалить', onPressed: onDelete)
            : DtdDarkButton(label: 'Загрузить', onPressed: onUpload),
      ],
    );
  }
}

/// Информационная плашка. Используется, чтобы честно объяснить ограничение
/// (например, что реестра дилерских лицензий не существует).
class DtdNotice extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color background;
  final Color? border;

  const DtdNotice({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
    this.color = T.warn,
    this.background = T.warnBg,
    this.border = T.warnBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(T.rCard),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Заголовок секции внутри экрана — жирный, как «Кошелёк» / «Способ оплаты».
class DtdSectionTitle extends StatelessWidget {
  final String text;
  final String? hint;

  const DtdSectionTitle(this.text, {super.key, this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: T.text,
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 5),
          Text(
            hint!,
            style: const TextStyle(
                fontSize: 13, color: T.textMuted, height: 1.4),
          ),
        ],
      ],
    );
  }
}
