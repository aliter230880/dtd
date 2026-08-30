/// DTD — тип перевозчика и путь верификации.
///
/// РЕШЕНИЕ ИЗ ARCHITECTURE.md (раздел «Физлица-перегонщики»), соблюдено буквально:
/// НЕ добавлять третье значение в UserType. Сейчас `UserType.Diller`
/// проверяется в 14 местах, `UserType.Carrier` — в 3, плюс Firestore-запросы
/// с фильтрами. Третья роль размножила бы ветвления и потребовала переписывать
/// запросы.
///
/// Вместо этого разделены два независимых понятия:
///   * `type` (существующий UserType)  — РОЛЬ на маркетплейсе (кто создаёт
///     заказы, кто выполняет). Физлицо-перегонщик — это тот же Carrier.
///   * `carrier_kind`                  — ПУТЬ ВЕРИФИКАЦИИ (company | individual).
///
/// Обратная совместимость: существующие перевозчики получают
/// carrier_kind: company, и текущие экраны с запросами работают без правок.
library;

enum CarrierKind {
  /// Компания или sole proprietor с авторитетом FMCSA. Путь: DOT/MC.
  company,

  /// Частное лицо без авторитета FMCSA. Путь: KYC личности.
  individual,
}

extension CarrierKindX on CarrierKind {
  String get firestoreValue => name;

  static CarrierKind fromFirestore(String? v) =>
      v == 'individual' ? CarrierKind.individual : CarrierKind.company;

  String get label => switch (this) {
        CarrierKind.company => 'Компания',
        CarrierKind.individual => 'Частное лицо',
      };
}

/// Чем подтверждён перевозчик. Пишется только Cloud Function.
enum VerificationMethod {
  /// Госреестр FMCSA — для компаний.
  fmcsa,

  /// KYC-провайдер (Stripe Identity + Checkr) — для физлиц.
  identity,
}

/// Слой KYC физлица.
///
/// Слои НЕ равнозначны: identity закрывается провайдером автоматически,
/// insurance — только человеком, потому что реестра автополисов нет.
enum KycLayer {
  /// Госдокумент + селфи с liveness. Stripe Identity.
  identity,

  /// Подлинность прав + история нарушений (MVR). Checkr.
  drivingRecord,

  /// Судимости, розыск. Checkr, регулируется FCRA.
  criminal,

  /// Полис, покрывающий вождение чужого авто за плату.
  /// Реестра нет → загрузка документа + модерация админом.
  insurance,
}

extension KycLayerX on KycLayer {
  String get title => switch (this) {
        KycLayer.identity => 'Личность',
        KycLayer.drivingRecord => 'Право вождения',
        KycLayer.criminal => 'Криминальный фон',
        KycLayer.insurance => 'Страховка',
      };

  String get what => switch (this) {
        KycLayer.identity => 'Госдокумент + селфи с liveness',
        KycLayer.drivingRecord => 'Подлинность прав, история нарушений (MVR)',
        KycLayer.criminal => 'Судимости, розыск',
        KycLayer.insurance => 'Полис на вождение чужого авто за плату',
      };

  String get vendor => switch (this) {
        KycLayer.identity => 'Stripe Identity',
        KycLayer.drivingRecord => 'Checkr',
        KycLayer.criminal => 'Checkr',
        KycLayer.insurance => 'Загрузка + модерация',
      };

  /// Обязателен ли слой для допуска к заказам на первом этапе.
  /// Рекомендация из документации: начать со Stripe Identity (Stripe уже
  /// интегрирован — один вендор, одна схема вебхуков, ~$1.5 за проверку).
  /// Checkr — вторым этапом, когда пойдёт реальный трафик.
  bool get requiredAtLaunch => switch (this) {
        KycLayer.identity => true,
        KycLayer.insurance => true, // главный практический риск, см. ниже
        KycLayer.drivingRecord => false,
        KycLayer.criminal => false,
      };

  /// Firestore-ключ внутри users/{uid}.verification.
  String get fieldKey => switch (this) {
        KycLayer.identity => 'identity_verified',
        KycLayer.drivingRecord => 'mvr_verified',
        KycLayer.criminal => 'background_verified',
        KycLayer.insurance => 'insurance_verified',
      };
}
