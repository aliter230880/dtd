# Модуль верификации и KYC

Референсная реализация верификации документов для DTD: перевозчик-компания,
перевозчик-физлицо, дилер.

Полное описание всех решений с обоснованиями —
**[`docs/VERIFICATION_KYC_IMPLEMENTATION.md`](../docs/VERIFICATION_KYC_IMPLEMENTATION.md)**

## Состояние

```
flutter test                 →  33/33 All tests passed!
flutter analyze              →  No issues found!
flutter build web --release   →  ✓ Built build/web
```

## Что здесь

| Путь | Строк | Назначение |
|---|---|---|
| `lib/theme/tokens.dart` | 75 | Палитра, снятая пиксельно со скринов приложения (`#FAE28C`) |
| `lib/models/verification.dart` | 165 | 4 уровня доверия, 9 статусов, правило `grantsBadge` |
| `lib/models/user_kind.dart` | 106 | `CarrierKind`, `VerificationMethod`, `KycLayer` |
| `lib/services/validators.dart` | 371 | 8 офлайн-валидаторов (VIN, DOT, MC, SSN, DOB, телефон, права, лицензия) |
| `lib/services/vin_service.dart` | 138 | NHTSA vPIC — живая расшифровка VIN |
| `lib/services/fmcsa_service.dart` | 204 | FMCSA — живая проверка перевозчика |
| `lib/services/kyc_service.dart` | 180 | Stripe Identity / Checkr / страховка + правило допуска |
| `lib/widgets/dtd_ui.dart` | 295 | 6 компонентов из макетов |
| `lib/widgets/verified_field.dart` | 388 | Поле с живой проверкой, debounce, отменой запросов |
| `lib/widgets/trust_badge.dart` | 274 | Бейдж доверия, различает физлицо и компанию |
| `lib/screens/verification_screen.dart` | 360 | 3 таба: Компания / Физлицо / Дилер |
| `lib/screens/carrier_kind_screen.dart` | 201 | Выбор пути верификации |
| `lib/screens/individual_kyc_screen.dart` | 618 | KYC физлица, 4 слоя |
| `test/widget_test.dart` | 272 | 33 теста |
| `functions/src/verification.ts` | 535 | 5 Cloud Functions |

## Три ключевых решения

**1. «Проверено» — не булево, а 4 уровня.**
Бейдж «Проверено» даёт **только** госреестр (FMCSA, NHTSA). Формат, сторонний
KYC-провайдер и ручная модерация — отдельные уровни с отдельной визуализацией.

```dart
bool get grantsBadge =>
    this == VerificationStatus.verified && tier == VerificationTier.registry;
```

**2. Физлицо — это способ проверки, а не роль.**
Третий `UserType` НЕ добавлялся: `UserType.Diller` проверяется в 14 местах,
`Carrier` — в 3, плюс запросы Firestore. Вместо этого — `carrier_kind`
(`company` | `individual`). Обратная совместимость через дефолт `company`,
миграция базы не нужна.

**3. Страховка — узкое место.**
Личный автополис обычно НЕ покрывает перегон чужого авто за плату. Отсутствие
`non-owned auto liability` даёт `mismatch`, а не `needsReview`, и закрывает
допуск к заказам.

## Слои KYC физлица

| Слой | Провайдер | Цена | Обязателен на старте |
|---|---|---|---|
| Личность | Stripe Identity | ~$1.50 | **Да** |
| Страховка | Ручная модерация | $0 | **Да** |
| MVR (история нарушений) | Checkr | ~$10 | Нет, 2-й этап |
| Криминальный фон | Checkr | ~$10–30 | Нет, 2-й этап |

## Правовая база валидаторов

* **ISO 3779** — контрольная цифра VIN
* **Правила выпуска SSA** — area ≠ 000/666/900+, group ≠ 00, serial ≠ 0000
* **49 CFR §391.11** — 21 год для межштатных; 18–20 = ограничение, не отказ
* **NANP** — NPA и NXX не могут начинаться с 0 или 1
* **FCRA** — MVR требует письменного согласия

## Безопасность

Секретные ключи (`FMCSA_WEB_KEY`, `STRIPE_SECRET_KEY`) **никогда** не попадают
в клиент — только в Cloud Functions. Проверено фактически: запрос к Stripe
Identity без ключа возвращает `HTTP 401`.

Статус верификации пишется **только** серверной функцией `persist()`. Клиент не
может выдать себе бейдж правкой локального состояния.

## Запуск

```bash
flutter pub get
flutter test
flutter run -d chrome
```

Без ключей API сервисы работают в demo-режиме. Demo возвращает
`pendingProvider`, а не `verified` — демонстрация не выдаёт подтверждений,
которых не было.
