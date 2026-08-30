# AGENTS.md — правила работы с проектом DTD

## Отчётность (обязательно)

Докладывать о прогрессе **каждую минуту работы**: короткая строка о том, что
сделано и что делается сейчас. Не уходить в длинные молчаливые серии вызовов
инструментов. Если операция долгая (сборка APK 5–7 минут) — предупредить об
этом заранее и назвать ожидаемое время.

## Сборка

```bash
source /e/AI/AI_folder/tools/env.sh     # обязательно в новом шелле
cd /e/AI/AI_folder/dtd/app
"$FLUTTER_BIN" build apk --release      # ~4–7 минут
```

Артефакты кладём в `сборки/` с версией в имени + копия `сборки/dtd-android.apk`.

## Проверка сборки на наличие правок

APK не показывает кириллицу (Dart хранит строки в UTF-16), поэтому проверяем
по латинским маркерам:

```bash
unzip -o -q сборки/dtd-android.apk -d /tmp/apkchk
grep -a -c <marker> /tmp/apkchk/lib/arm64-v8a/libapp.so
```

## Правила по коду

- Правки вносим в `app/`; `web/` — отдельная копия, синхронизируется вручную.
- Стиль и палитра: `primary #FAE28C`, текст на жёлтом чёрный, фон `#F5F5F5`,
  карточки белые, радиус кнопок 30, карточек 10–16.
- `flutter analyze` перед сборкой: ошибок (`error -`) быть не должно.
- **`pubspec.lock` не переписывать без необходимости.** Оговорка: переразрешение
  между v7 и v8 подозревали в поломке входа, но оно оказалось невиновно —
  изменились только URL зеркала, версии всех 209 пакетов совпали.
- Ошибки авторизации показывать через `showAuthError` из
  `app/lib/auth/auth_error_snackbar.dart` — с кодом Firebase в квадратных
  скобках. Не заменять на локализованное «Произошла ошибка»: без кода
  диагностика соцвхода с экрана телефона невозможна.

## Диагностика APK: что уже проверено и больше не проверять

Между сборками v7 (27.08), v7-28.08 (рабочий соцвход) и v8 (сломанный):

- `classes.dex`, `classes2.dex`, `resources.arsc`, `libflutter.so` —
  **побайтово идентичны**. Вся нативная часть (Firebase Auth, Facebook SDK,
  `GenericIdpActivity`, схемы редиректа) не менялась ни разу с 21.08.
- Подпись одна и та же: SHA-1 `bfab152b859a11f5d11285aa8646d1f13c8dd157`,
  и она совпадает с `certificate_hash` в `google-services.json`.
- Dart-снапшоты (`libapp.so`) сравнены построчно с нормализацией суффиксов
  `@<число>` (без неё получите тысячи ложных различий): из auth-слоя
  не удалено ничего, счётчики всех вызовов входа совпадают до единицы,
  набор файлов `auth/**`, `backend/**`, `flutter_flow/**` идентичен.
- Серверная сторона в порядке: `/__/auth/handler` отдаёт настоящий
  Firebase OAuth-helper (а не `index.html`), Identity Toolkit подтверждает,
  что Google и Facebook включены, OAuth-клиент Google живой,
  authorized domains на месте.

Вывод: причина поломки соцвхода **не в сборке**. Искать в консолях
Firebase/Google Cloud/Facebook либо по точному коду ошибки с устройства.

Ключ-хеш нашего keystore для Facebook App Dashboard:
`VF15kJz/Jn5VW2tGLAxhmI61liE=`

## Проверка кириллицы в APK

Dart хранит строки в UTF-16, поэтому `grep` по кириллице даёт 0.
Латинские маркеры ищутся обычным `grep -a -c`, кириллические — так:

```bash
python -c "
d=open('/путь/libapp.so','rb').read()
print(d.count('вход отменён'.encode('utf-16-le')))
"
```

## История критичных багов авторизации

1. `1.0.0+4` — вход после выхода: кешированный `currentUserDocument`.
2. `1.0.0+6` — Google error 12500: убран плагин `google_sign_in`, используется
   `FirebaseAuth.signInWithProvider`.
3. `1.0.0+7` — зависание на HomePage: лишний `return` в `checkUserProfileStatus`
   (`main.dart`).
4. `1.0.0+8` — сломались Google и Facebook, Apple работает. В сборке причины
   нет (см. раздел выше). Ждём точный код Firebase с устройства.
5. `1.0.0+9` — заглушки обработчиков ошибок заменены на `showAuthError`
   с кодом Firebase. Диагностическая сборка, не исправление.
6. `1.0.0+10` — Google переведён на нативный `google_sign_in 6.1.5`
   (нижняя шторка выбора аккаунта, без браузера и `GenericIdpActivity`),
   с `serverClientId` = web-клиент type 3 из google-services.json.
   Браузерный `signInWithProvider` оставлен запасным фолбэком.
   Исходная ошибка 12500 (из-за которой плагин убирали в v6) — про
   SHA-1/Google Play Services; SHA-1 `bfab152b…` с тех пор зарегистрирован.
7. `1.0.0+11` — дефект устройства, не кода: `Failed to generate/retrieve
   public encryption key for Generic IDP flow`. Firebase хранит Tink-keyset
   в prefs `com.google.firebase.auth.api.crypto.[DEFAULT]`, мастер-ключ в
   Android Keystore как `firebear_master_key_id.[DEFAULT]`. Keystore на
   устройстве инвалидировал ключ (обновление ОС / смена блокировки).
   Лечение: MainActivity.kt, MethodChannel `dtd/firebase_auth_crypto` →
   `resetGenericIdpKeyset` (чистит prefs + удаляет alias); google_auth.dart
   вызывает его при Generic IDP-ошибке и повторяет браузерный flow.

