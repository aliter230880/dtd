# DTD — Dealer to Dealer (AutoDeal)

Маркетплейс сделок между автодилерами с доставкой перевозчиками.
Flutter + Firebase (проект `dealertodealer-84957`).

## Структура монорепо

| Папка | Что это | Платформы |
|---|---|---|
| `app/` | Мобильное приложение (дилер / перевозчик) | Android, iOS, Web |
| `web/` | Веб-версия того же приложения | Web (Firebase Hosting, сайт `dtdweb`) |
| `admin/` | Админ-панель + серверная часть | Web |
| `admin/firebase/` | **Cloud Functions и правила безопасности Firestore/Storage** | — |

## Сборка

Требуется Flutter 3.19.6 (stable), JDK 17 для Android.

```bash
cd app
flutter pub get
flutter build apk --release      # Android APK
flutter build appbundle          # Android AAB для Google Play
flutter build web --release      # Web
flutter build ios --release --no-codesign   # iOS (требуется macOS)
```

## CI

`.github/workflows/ios-build.yml` — сборка iOS на macOS-раннере GitHub Actions
(ручной запуск из вкладки Actions). Для подписи и TestFlight раскомментировать
блок в конце файла и добавить секреты (см. комментарии в файле).

## Безопасность

- `*.jks`, `key.properties`, ключи сервис-аккаунтов исключены через `.gitignore`.
- `google-services.json` в репозитории — это нормально (не секрет, конфигурация клиента).
