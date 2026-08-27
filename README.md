# DTD — Dealer to Dealer (AutoDeal)

Маркетплейс сделок между автодилерами с доставкой перевозчиками.  
Flutter + Firebase (проект `dealertodealer-84957`).

**Статус:** PATENT PENDING (патент подан 28 октября 2025)  
**Изобретатель:** Леонид Лифшиц  
**Компания:** DTD USA Inc., Нью-Йорк  
**Приложение:** версия 1.0.0+7 (27.08.2026) — Android / iOS / Web, полный цикл сделки проходит

---

## 📖 Документация

- **[QUICKSTART.md](docs/QUICKSTART.md)** — быстрый старт: окружение, сборка, деплой (читай первым!)
- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** — полная архитектура, схема данных, текущая точка, план развития

---

## 🚀 Структура монорепо

| Папка | Что это | Платформы |
|---|---|---|
| \pp/\ | Мобильное приложение (дилер / перевозчик) | Android, iOS, Web |
| \web/\ | Веб-версия того же приложения | Web (Firebase Hosting) |
| \dmin/\ | Админ-панель + серверная часть | Web |
| \dmin/firebase/\ | **Cloud Functions и правила безопасности Firestore/Storage** | — |
| \docs/\ | Документация проекта | — |

---

## 🛠️ Быстрый старт

### Требования

- Flutter 3.19.6 (stable)
- Dart 3.x
- JDK 17 (для Android)
- Xcode 15+ (для iOS, только на macOS)

### Сборка

\\\ash
# Android APK
cd app
flutter pub get
flutter build apk --release

# Android AAB для Google Play
flutter build appbundle --release

# Web
flutter build web --release

# iOS (требуется macOS)
flutter build ios --release --no-codesign
\\\

**Подробности → [QUICKSTART.md](docs/QUICKSTART.md)**

---

## 🔥 Firebase Setup

**Проект Firebase:** \dealertodealer-84957\  
**Console:** https://console.firebase.google.com/project/dealertodealer-84957

Конфигурационные файлы уже в репо:
- Android: \pp/android/app/google-services.json\
- iOS: \pp/ios/Runner/GoogleService-Info.plist\
- Web: \pp/lib/backend/firebase/firebase_config.dart\

### Деплой Firebase rules

\\\ash
cd admin/firebase
firebase deploy --only firestore:rules,storage
\\\

---

## 🎯 Что работает (проверено в сборках)

✅ Регистрация/авторизация (Google, Facebook, Apple, Email) — включая вход после выхода (закрыт блокер, v1.0.0+4…+7)  
✅ Две роли: **Diller** (дилер) и **Carrier** (перевозчик), роль видна в профиле  
✅ Полный жизненный цикл сделки: InSearch → InConfirm → InActive → Completed, споры  
✅ Публикация сделки с фото и файлами — в вебе и на Android  
✅ Геокодирование: выбор адреса в строке и на карте (браузер и мобильные)  
✅ Аукцион со ставками перевозчиков, чат, отзывы, жалобы  
✅ Пополнение кошелька через Stripe Checkout: карта, Apple/Google Pay, SEPA, Klarna; суммы 50/100/500 и своя от $50 (серверные функции написаны, деплой — см. ниже)  
✅ КУС-верификация перевозчика по DOT/MC — экран, статусы, badges (**провайдер mock — любой номер проходит**)  
✅ Чекбокс страховки при создании сделки (**расчёт mock**)  
✅ Push-уведомления (FCM), админ-панель (жалобы, аналитика, бан)  

---

## 🚧 В разработке / требует действий

**Разработка:**
1. Замена mock-провайдеров на реальные API — FMCSA (КУС) и страховой партнёр
2. Перенос money-path в Cloud Functions (выплаты перевозчику, статусы сделки) + ужесточение Firestore Rules — **блокер продакшна**
3. Физлица-перегонщики — проработка в ARCHITECTURE.md, ждёт решения юриста

**Действия владельца (без них функциональность не заработает):**
- Деплой Cloud Functions и ключи Stripe (`functions:config:set … stripe.secret_key`) — иначе оплата возвращает «Stripe не сконфигурирован»
- Ограничение Google Maps API-ключа по домену в Google Cloud Console
- Новый keystore до публикации в Google Play (текущий скомпрометирован первым коммитом)

**Следующие фазы:** Scale (геопоиск geohash, пагинация), Business (ваучеры, рефералы, escrow), Killer Features (AI Price, Live GPS Tracking)

**Подробности → [ARCHITECTURE.md](docs/ARCHITECTURE.md), разделы «Текущая точка» и «План доработок»**

---

## 🔒 Безопасность

⚠️ **Критические проблемы (в работе):**
- Финансовая логика выполняется на клиенте → переносим в Cloud Functions
- Firestore Rules требуют ужесточения
- Нет мониторинга (Crashlytics) → подключаем

**Ключи и секреты:**
- \*.jks\, \key.properties\ исключены через \.gitignore\
- \google-services.json\ в репо — это нормально (не секрет, конфигурация клиента)

---

## 📊 CI/CD

\.github/workflows/ios-build.yml\ — сборка iOS на macOS-раннере GitHub Actions  
(ручной запуск из вкладки Actions).

Для подписи и TestFlight раскомментировать блок в конце файла и добавить секреты (см. комментарии).

---

## 🌐 Конкурент

**Central Dispatch** (https://www.centraldispatch.com) — крупнейший load board США с 1999 года, 20k+ перевозчиков.

**Наши преимущества:**
- Встроенное страхование (у них нет)
- Аукцион со ставками в реальном времени
- Умная система обмена маршрутами (патент)
- Фокус на частных водителей (gig-экономика)

**Анализ конкурента → [ARCHITECTURE.md](docs/ARCHITECTURE.md), раздел "Анализ конкурентов"**

---

## 🤝 Контакты

**GitHub:** https://github.com/aliter230880/dtd  
**Основатель:** Леонид Лифшиц  
**Компания:** DTD USA Inc., Нью-Йорк, США

---

## 📝 Лицензия

Проприетарный проект. Все права защищены.  
Patent Pending (заявка подана 28 октября 2025).
