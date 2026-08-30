import 'package:flutter/material.dart';

/// Единая точка правды по цветам и геометрии.
///
/// Палитра снята пиксельно со скриншотов реального приложения DTD
/// (главная, поиск заказов, чат, профиль), а не придумана:
///   #FAE28C — акцент (кошелёк, кнопка «Создать заказ», пилюля таб-бара)
///   #F5F5F5 — фон экрана
///   #FFFFFF — карточки
///   #010101 — основной текст (на жёлтом тоже чёрный, не белый)
class T {
  T._();

  // ---- Бренд: жёлтый акцент, НЕ синий ----
  /// Основной акцент приложения.
  static const accent = Color(0xFFFAE28C);

  /// Более насыщенный жёлтый для иконок и активных состояний.
  static const accentStrong = Color(0xFFF5C842);

  /// Текст и иконки НА жёлтом. В макетах он чёрный — белый читается плохо.
  static const onAccent = Color(0xFF010101);

  // ---- Фон и поверхности ----
  static const bg = Color(0xFFF5F5F5);
  static const surface = Colors.white;

  /// Слегка лиловый фон заголовка профиля из макета.
  static const surfaceAlt = Color(0xFFF3F0F7);

  // ---- Текст ----
  static const text = Color(0xFF010101);
  static const textMuted = Color(0xFF6B6B6B);
  static const textFaint = Color(0xFF9E9E9E);
  static const divider = Color(0xFFE8E8E8);

  // ---- Семантика статусов верификации ----
  // Приглушены под спокойный макет: чистый #4CAF50 рядом с #FAE28C кричит.
  /// Подтверждено госреестром.
  static const ok = Color(0xFF2E7D4F);

  /// Расхождение, отказ.
  static const danger = Color(0xFFC0392B);

  /// Не найдено, нужна правка.
  static const warn = Color(0xFFB26A00);
  static const warnBg = Color(0xFFFFF6E5);
  static const warnBorder = Color(0xFFF0D089);

  /// Недоступно, не заполнено.
  static const neutral = Color(0xFF8A8A8A);

  /// Ручная модерация админом.
  static const review = Color(0xFF6A4C93);

  /// Сторонний KYC-провайдер (Stripe Identity, Checkr).
  /// Отдельный цвет намеренно: это не госреестр, но и не «фото на модерации».
  static const provider = Color(0xFF00695C);

  // ---- Геометрия из макетов ----
  static const rCard = 16.0;
  static const rField = 14.0;
  static const rChip = 12.0;

  /// Кнопки в макете — почти таблетки.
  static const rButton = 28.0;

  /// Пилюля выбранного пункта таб-бара.
  static const rPill = 24.0;

  static BoxDecoration get card => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(rCard),
      );
}
