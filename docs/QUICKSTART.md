# DTD (Dealer-to-Dealer) — Quick Start Handoff

**Дата:** 23 мая 2026  
**Статус:** MVP готов → переход к production-ready

---

## Что это

**DTD USA Inc.** — маркетплейс доставки автомобилей между дилерами и перевозчиками (патент подан).  
**Целевой рынок:** 170k+ дилеров, 700k+ перевозчиков в США.

**Репозиторий:**  
- Локально: \E:\\AI\\AI_folder\\dtd\
- GitHub: https://github.com/aliter230880/dtd
- Firebase: \dealertodealer-84957\

---

## Быстрый старт

### 1. Клонирование и setup

\\\ash
git clone https://github.com/aliter230880/dtd.git
cd dtd/app
flutter pub get
\\\

### 2. Сборка

\\\ash
# Android APK (debug)
flutter build apk --debug

# Android AAB (release, требуется keystore)
flutter build appbundle --release

# Web
cd ../app
flutter build web --release

# iOS (требуется macOS)
flutter build ios --release --no-codesign
\\\

### 3. Firebase setup

**Если нет доступа к Firebase Console:**
- \google-services.json\ для Android уже в \pp/android/app/\
- \GoogleService-Info.plist\ для iOS уже в \pp/ios/Runner/\
- Web-конфигурация в \lib/backend/firebase/firebase_config.dart\

**Если есть доступ:**
- Console: https://console.firebase.google.com/project/dealertodealer-84957
- Правила: \dmin/firebase/firestore.rules\, \storage.rules\
- Деплой rules: \cd admin/firebase && firebase deploy --only firestore:rules,storage\

---

## Структура проекта

\\\
dtd/
├── app/                    # Мобильное приложение (Android/iOS/Web)
│   ├── lib/
│   │   ├── backend/schema/ # Firestore модели (DealsRecord, UsersRecord и т.д.)
│   │   ├── pages/          # Экраны (*_widget.dart + *_model.dart)
│   │   └── flutter_flow/   # Служебный код FlutterFlow
│   └── android/app/
│       └── build.gradle    # package: com.sprestay.autodealapp
├── web/                    # Веб-версия (почти идентична app/)
├── admin/                  # Админ-панель + Cloud Functions
│   └── firebase/
│       ├── firestore.rules
│       ├── storage.rules
│       └── functions/      # Node.js Cloud Functions
├── docs/
│   └── ARCHITECTURE.md     # 📖 ПОЛНАЯ ДОКУМЕНТАЦИЯ (читай это!)
└── README.md
\\\

---

## Что работает (MVP)

✅ Регистрация/авторизация (Google, Apple, Facebook, Email)  
✅ Две роли: Diller (дилер) и Carrier (перевозчик)  
✅ Жизненный цикл сделки: InSearch → InConfirm → InActive → Completed  
✅ Аукцион со ставками перевозчиков  
✅ Чат между дилером и перевозчиком  
✅ Споры (Disputes) → админ разбирает  
✅ Отзывы (5 звёзд + комментарий)  
✅ Жалобы (Complains) → админ может забанить  
✅ Геолокация (Google Maps, Mapbox Search)  
✅ Push-уведомления (FCM)  
✅ Подписки (RevenueCat)  
✅ Админ-панель (жалобы, аналитика, бан)  

---

## Критические проблемы (читай перед работой!)

🔴 **Финансовая логика на клиенте** — начисление заработка, списание откликов происходит из приложения → легко взломать.  
🔴 **Firestore Rules открытые** — любой может прочитать все сделки.  
🔴 **Производительность** — все сделки грузятся целиком, фильтры на клиенте → при 1000+ сделок упадёт.  
🟡 **Дублирование кода** — app/web/admin дублируют схему.  
🟡 **Нет тестов** — только заглушки.  
🟡 **Нет мониторинга** — Crashlytics не подключён.

**Подробности → \docs/ARCHITECTURE.md\**

---

## Приоритет заказчика (делаем СЕЙЧАС)

### 1. Страхование перегона авто
- Интеграция со страховой компанией (API или реферальная ссылка)
- Чекбокс "Требуется страховка" при создании сделки
- Покупка полиса внутри приложения
- Новые поля в \deals\: \insurance_required\, \insurance_policy_id\, \insurance_cost\

### 2. Автопроверка/автозаполнение партнёров (KYC)
- Интеграция с FMCSA API (проверка DOT/MC номеров для США)
- Автозаполнение: company_legal_name, address, safety_rating
- Бейдж "Verified" в профиле
- Блокировка функций для неверифицированных
- Новые поля в \users\: \erified\, \dot_number\, \mc_number\, \company_legal_name\

---

## План доработок (после приоритета заказчика)

**Фаза 1 (критично, 3–5 дней):** Security  
- Cloud Functions для всех операций с деньгами
- Ужесточение Firestore rules
- Firebase App Check

**Фаза 2 (неделя):** Scale  
- Геопоиск через geohash
- Пагинация списков
- Индексы для фильтров

**Фаза 3 (2–3 недели):** Business Features  
- Ваучеры, реферальная программа
- Escrow платежей (Stripe Connect)
- AI Price Suggestions (как у Central Dispatch)

**Подробности → \docs/ARCHITECTURE.md\, раздел "План доработок"**

---

## Схема данных (Firestore)

### Коллекция \users\

\\\
email, display_name, photo_url, uid
type: Enum (Diller, Carrier)
balance: double
carrier_total_earning: double
free_deal_count: int, free_response_count: int
rate: double, rate_count: int
carrier_company_name, carrier_number (MC/DOT)
diller_license, diller_driver_license
banned: bool
\\\

### Коллекция \deals\

\\\
car_name, car_number, car_photos, description
location: GeoPoint, location_address
price: int
status: Enum (InSearch, InConfirm, InActive, InDispute, Completed, Canceled)
owner: ref users/{uid}  (дилер)
carrier: ref users/{uid}  (перевозчик)
responses: Array<ResponseStruct>  (отклики + ставки)
auction: ref auctions/{id}
review_by_diller, review_by_carrier
\\\

**Полная схема → \docs/ARCHITECTURE.md\, раздел "Схема данных"**

---

## Полезные команды

\\\ash
# Анализ кода
flutter analyze

# Запуск тестов (пока пустые)
flutter test

# Сборка для всех платформ
flutter build apk && flutter build web && flutter build ios

# Деплой Firebase rules
cd admin/firebase
firebase deploy --only firestore:rules,storage

# Деплой Cloud Functions
cd admin/firebase/functions
npm run deploy
\\\

---

## Контакты и ресурсы

**GitHub:** https://github.com/aliter230880/dtd  
**Firebase Console:** https://console.firebase.google.com/project/dealertodealer-84957  
**Package ID:** \com.sprestay.autodealapp\  
**Основатель:** Леонид Лифшиц  
**Патент:** PATENT PENDING (28 октября 2025)

**Конкурент (анализ):** [Central Dispatch](https://www.centraldispatch.com) — крупнейший load board США

---

## Следующий шаг

1. Прочитай \docs/ARCHITECTURE.md\ (полная картина)
2. Проверь доступ к Firebase Console
3. Начинай с приоритета заказчика (страхование + KYC)

**Вопросы?** Пиши заказчику или проверяй \docs/ARCHITECTURE.md\ — там всё расписано.
