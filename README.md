# DTD — Dealer to Dealer (AutoDeal)

Маркетплейс сделок между автодилерами с доставкой перевозчиками.  
Flutter + Firebase (проект \dealertodealer-84957\).

**Статус:** PATENT PENDING (патент подан 28 октября 2025)  
**Изобретатель:** Леонид Лифшиц  
**Компания:** DTD USA Inc., Нью-Йорк

---

## 📖 Документация

- **[QUICKSTART.md](docs/QUICKSTART.md)** — быстрый старт для новых разработчиков (читай первым!)
- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** — полная архитектура, схема данных, план развития

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

## 🎯 Что работает (MVP)

✅ Регистрация/авторизация (Google, Apple, Facebook, Email)  
✅ Две роли: **Diller** (дилер) и **Carrier** (перевозчик)  
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

## 🚧 В разработке

**Приоритет заказчика:**
1. **Страхование перегона авто** — интеграция со страховой компанией
2. **Автопроверка партнёров (KYC)** — верификация через FMCSA API (DOT/MC номера)

**Следующие фазы:**
- Security: Cloud Functions для финансовых операций
- Scale: геопоиск через geohash, пагинация
- AI Price Suggestions (как у Central Dispatch)
- Live GPS Tracking перевозчика

**Подробности → [ARCHITECTURE.md](docs/ARCHITECTURE.md), раздел "План доработок"**

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
