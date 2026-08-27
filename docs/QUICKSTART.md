# DTD (Dealer-to-Dealer) — Quick Start

**Обновлено:** 27 августа 2026  
**Версия приложения:** 1.0.0+7  
**Полная документация:** [ARCHITECTURE.md](ARCHITECTURE.md) — архитектура, схема данных, текущая точка, планы.

---

## Что это

**DTD USA Inc.** — маркетплейс доставки автомобилей между дилерами и перевозчиками
(патент pending). Flutter + Firebase, монорепо из трёх приложений.

| Ресурс | Где |
|---|---|
| Локально | `E:\AI\AI_folder\dtd` |
| GitHub | https://github.com/aliter230880/dtd |
| Firebase | `dealertodealer-84957` |

---

## Структура монорепо

```
dtd/
├── app/                  # Приложение (Android / iOS / Web) — основная кодовая база
│   ├── lib/
│   │   ├── backend/      # Firestore-модели, Storage, Functions-клиент
│   │   ├── pages/        # Экраны (*_widget.dart + *_model.dart, паттерн FlutterFlow)
│   │   ├── custom_code/  # Геокодирование и прочий ручной код
│   │   └── flutter_flow/ # Служебный рантайм FlutterFlow
│   └── android/          # dtd.jks + key.properties — ТОЛЬКО локально, в git не попадают
├── web/                  # Отдельная копия веб-версии (дублирует app/)
├── admin/                # Админ-панель
│   └── firebase/         # Cloud Functions (TypeScript: insurance, kyc, payments)
│                         # + firestore.rules, storage.rules
├── docs/                 # Документация
├── .github/workflows/    # iOS-сборка на GitHub Actions
├── сборки/               # Артефакты для тестирования (в git не попадают)
└── _archives/            # Исходные zip, история (в git не попадают)
```

⚠️ **Важно:** `app/` и `web/` — почти идентичные копии. Правки делаются в `app/`;
дублирование в `web/` — известный технический долг (см. ARCHITECTURE.md).

⚠️ **FlutterFlow-проекта-генератора нет.** Код правится руками; при перегенерации
из FlutterFlow все ручные правки будут затёрты.

---

## Окружение сборки (эта машина)

Всё установлено на `E:\AI\AI_folder\tools` — диск C не используется:

- Flutter 3.19.6 (`tools/flutter`), JDK 17 (`tools/jdk-…`), Gradle 7.5
- Pub-кеш: `tools/pub-cache`, Gradle home: `tools/gradle-home`
- Зеркала pub/Flutter (региональные) прописаны в `env.sh`

Перед любой сборкой в новом шелле:

```bash
source /e/AI/AI_folder/tools/env.sh
```

`env.sh` задаёт `PUB_CACHE`, `GRADLE_USER_HOME`, зеркала и `$FLUTTER_BIN`.
Android SDK — стандартный, в `%LOCALAPPDATA%\Android\Sdk` (платформа 34
установлена). Подпись release-APK — ключом `app/android/dtd.jks`
(`key.properties` рядом; пароль в файле).

---

## Сборка

### Android APK (release, подписанный)

```bash
source /e/AI/AI_folder/tools/env.sh
cd /e/AI/AI_folder/dtd/app
"$FLUTTER_BIN" build apk --release
```

Артефакт: `app/build/app/outputs/flutter-apk/app-release.apk` (~34 МБ).
Копия для тестов: `сборки/dtd-android.apk`. Первая сборка ~10–15 мин
(загрузка зависимостей), повторные 2–3 мин (web — около 1 мин).

Для Google Play: `flutter build appbundle --release` (перед публикацией —
новый keystore, текущий скомпрометирован, см. ARCHITECTURE.md).

### Web

```bash
"$FLUTTER_BIN" build web --release
# артефакт app/build/web/
```

Локальный просмотр (Flutter Web требует HTTP-сервер, file:// не работает):

```bash
cd /e/AI/AI_folder/dtd/сборки/web && python -m http.server 8080
# → http://localhost:8080
```

### iOS (без macOS)

Собирается в облаке GitHub Actions: репозиторий → вкладка Actions →
«iOS build» → Run workflow. Артефакт `ios-unsigned-app` (Runner.app без подписи).
Для установки на устройства/TestFlight нужен Apple Developer Program ($99/год) —
блок подписи закомментирован в `.github/workflows/ios-build.yml`.

---

## Cloud Functions

```bash
cd admin/firebase/functions
./node_modules/.bin/tsc --project tsconfig.json   # компиляция TS → lib/
```

Деплой (нужен доступ к Firebase):

```bash
firebase functions:config:set \
  stripe.secret_key="sk_..." \
  stripe.webhook_secret="whsec_..." \
  stripe.success_url="https://<домен>/walletPage" \
  stripe.cancel_url="https://<домен>/walletPage"
firebase deploy --only functions
```

Затем в дашборде Stripe — вебхук на `checkout.session.completed` с URL
функции `stripeWebhook`. **Пока ключи не заданы и функции не задеплоены,
оплата возвращает «Stripe не сконфигурирован».**

Правила безопасности: `firebase deploy --only firestore:rules,storage`
(из `admin/firebase/`).

---

## Проверка APK на «новизну» (по содержимому)

```bash
unzip -o -q сборки/dtd-android.apk -d /tmp/apkchk
grep -a -c createCheckoutSession /tmp/apkchk/lib/arm64-v8a/libapp.so
```

Маркеры свежих правок: `createCheckoutSession`, `sepa_debit`, `klarna`,
`carrier_verification_title`, `CarrierVerificationPage`. Кириллицу grep-ом
в `libapp.so` искать бесполезно — Dart хранит строки в UTF-16.

---

## Что сейчас работает / не работает

**Работает (проверено):** полный цикл сделки в вебе и Android; авторизация
(email + соцвходы, включая вход после выхода); публикация с фото и файлами;
геокодирование (адрес и карта); роль в профиле; страница КУС-верификации
(mock: любой DOT проходит); чат, отзывы, споры; админ-панель.

**Не работает / требует действий:**
- Оплата — «Stripe не сконфигурирован» до деплоя функций и ключей
  (действие владельца)
- КУС-верификация и страховка — mock-провайдеры, реальных API нет
- Google Maps API-ключ не ограничен по домену (действие владельца)

**Критические риски до продакшна** — money-path на клиенте, открытые
Firestore Rules: детали и порядок работ в [ARCHITECTURE.md](ARCHITECTURE.md),
разделы «Текущая точка» и «План доработок».

---

## Контакты

**GitHub:** https://github.com/aliter230880/dtd  
**Firebase Console:** https://console.firebase.google.com/project/dealertodealer-84957  
**Основатель:** Леонид Лифшиц, DTD USA Inc.
