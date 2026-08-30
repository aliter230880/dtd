/// DTD — модели верификации документов.
///
/// Ключевая идея схемы: «проверен» — не bool, а ТРИ уровня доверия,
/// каждый со своим провенансом. Бинарный флаг verified:true — это то,
/// из-за чего mock-верификация в текущем проекте выглядит как гарантия,
/// которой нет.
library;

/// Уровень, на котором подтверждено значение поля.
enum VerificationTier {
  /// Уровень 1 — формат. Локально, мгновенно, бесплатно.
  /// Ловит опечатки, ничего не подтверждает по существу.
  format,

  /// Уровень 2 — официальный реестр (FMCSA QCMobile, NHTSA vPIC).
  /// Единственный уровень, дающий право на публичный бейдж.
  registry,

  /// Уровень 3 — сторонний KYC-провайдер (Stripe Identity, Checkr).
  /// Не госреестр, но и не «фото на модерации»: провайдер несёт
  /// ответственность за результат и работает асинхронно (вебхук).
  provider,

  /// Уровень 4 — ручная модерация админом по загруженному документу.
  /// Фолбэк там, где реестра не существует (лицензии дилеров, 50 DMV штатов,
  /// страховой полис физлица).
  manual,
}

/// Состояние проверки конкретного поля.
enum VerificationStatus {
  /// Пусто, пользователь ещё не вводил.
  idle,

  /// Не проходит формат (длина, контрольная цифра, маска штата).
  invalidFormat,

  /// Формат корректен, идёт запрос к реестру.
  checking,

  /// Реестр подтвердил.
  verified,

  /// Реестр нашёл запись, но она противоречит заявленному
  /// (например, авторитет FMCSA отозван, allowedToOperate = N).
  mismatch,

  /// Реестра не нашёл записи.
  notFound,

  /// Реестр недоступен: сеть, 5xx, отсутствует webKey.
  /// КРИТИЧНО: это НЕ «неверно». Форму блокировать нельзя.
  unavailable,

  /// Сессия у провайдера создана, ждём результат вебхуком.
  /// Отличается от checking: это минуты-часы, а не один HTTP-запрос,
  /// и переживает закрытие приложения.
  pendingProvider,

  /// Реестра для этого поля не существует — нужна ручная модерация.
  needsReview,
}

extension VerificationStatusX on VerificationStatus {
  /// Можно ли отправлять форму. «Недоступен» и «на модерации» — можно.
  bool get allowsSubmit =>
      this == VerificationStatus.verified ||
      this == VerificationStatus.unavailable ||
      this == VerificationStatus.pendingProvider ||
      this == VerificationStatus.needsReview;

  /// Даёт ли статус право на публичный бейдж доверия.
  bool get grantsBadge => this == VerificationStatus.verified;

  bool get isBlocking =>
      this == VerificationStatus.invalidFormat ||
      this == VerificationStatus.mismatch ||
      this == VerificationStatus.notFound;
}

/// Результат проверки + провенанс.
///
/// Провенанс обязателен: без source/checkedAt проверка «гниёт» —
/// safety rating и авторитет FMCSA отзываются со временем.
class VerificationResult {
  final VerificationStatus status;
  final VerificationTier? tier;

  /// Человекочитаемое сообщение для пользователя.
  final String? message;

  /// Поля, подтянутые из реестра, — для автозаполнения формы.
  final Map<String, String> autofill;

  /// Кто подтвердил: 'fmcsa_qcmobile', 'nhtsa_vpic', 'admin', 'format'.
  final String? source;

  final DateTime? checkedAt;

  /// Когда проверка истекает и требует повтора (FMCSA — 30 дней).
  final DateTime? expiresAt;

  /// Сырой ответ реестра — для аудита и разбора споров.
  final Map<String, dynamic>? raw;

  const VerificationResult({
    required this.status,
    this.tier,
    this.message,
    this.autofill = const {},
    this.source,
    this.checkedAt,
    this.expiresAt,
    this.raw,
  });

  const VerificationResult.idle()
      : status = VerificationStatus.idle,
        tier = null,
        message = null,
        autofill = const {},
        source = null,
        checkedAt = null,
        expiresAt = null,
        raw = null;

  const VerificationResult.checking()
      : status = VerificationStatus.checking,
        tier = null,
        message = null,
        autofill = const {},
        source = null,
        checkedAt = null,
        expiresAt = null,
        raw = null;

  factory VerificationResult.invalidFormat(String message) =>
      VerificationResult(
        status: VerificationStatus.invalidFormat,
        tier: VerificationTier.format,
        message: message,
        source: 'format',
        checkedAt: DateTime.now(),
      );

  factory VerificationResult.unavailable(String message) => VerificationResult(
        status: VerificationStatus.unavailable,
        message: message,
        checkedAt: DateTime.now(),
      );

  bool get isTerminal =>
      status != VerificationStatus.idle && status != VerificationStatus.checking;

  /// То, что уходит в Firestore. Никогда не пишется с клиента напрямую —
  /// только результат Cloud Function (см. functions/src/verification.ts).
  Map<String, dynamic> toFirestore() => {
        'status': status.name,
        'tier': tier?.name,
        'source': source,
        'checked_at': checkedAt?.toIso8601String(),
        'expires_at': expiresAt?.toIso8601String(),
        'autofill': autofill,
      };
}
