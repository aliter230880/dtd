# DTD (Dealer-to-Dealer) — Архитектура и План Развития

**Дата создания:** 23 мая 2026  
**Версия:** 1.0  
**Статус проекта:** MVP готов, переход к production-ready фазе

---

## Содержание

1. [Обзор проекта](#обзор-проекта)
2. [Текущая архитектура](#текущая-архитектура)
3. [Схема данных](#схема-данных)
4. [Что уже работает](#что-уже-работает)
5. [Критические проблемы](#критические-проблемы)
6. [Анализ конкурентов](#анализ-конкурентов)
7. [План доработок](#план-доработок)
8. [Roadmap](#roadmap)

---

## Обзор проекта

### Что такое DTD

**DTD USA Inc.** — логистическая платформа для доставки автомобилей между дилерами, аукционами, транспортными компаниями, частными водителями, страховыми и рент-компаниями.

**Статус:** PATENT PENDING (патент подан 28 октября 2025, изобретатель: Леонид Лифшиц)

**Уникальность:** Умная система обмена маршрутами между дилерами, устраняющая холостые пробеги. Не просто load board, а marketplace с auction-механикой и AI-pricing (в планах).

### Целевой рынок (США)

- **170,000+** дилерских компаний
- **~700,000** автоперевозчиков
- **Рент-кары** с парком 10–100 машин
- **~50%** перевозок делают частные водители

### Монетизация

- Фиксированная ставка за сервис + комиссия с клиента или транспортной компании
- Subscription-модель (Basic/Pro/Enterprise через RevenueCat)
- Клиент не платит за неиспользованные услуги
- Ваучеры на бесплатное использование для новых клиентов (в планах)
- Партнёрские интеграции со страховыми (баннеры/сервисы, в планах)

### Бизнес-цель

Рост клиентов **50%/месяц** (геометрическая прогрессия), т.к. аналогов с такой функциональностью нет ни в США, ни в других странах.

---

## Текущая архитектура

### Структура монорепо

\\\
dtd/
├── app/               # Мобильное приложение (Android, iOS, Web)
│   ├── lib/
│   │   ├── backend/schema/     # Firestore модели (DealsRecord, UsersRecord и т.д.)
│   │   ├── pages/              # Экраны приложения (*_widget.dart + *_model.dart)
│   │   ├── flutter_flow/       # Служебный код FlutterFlow
│   │   └── main.dart
│   └── android/
│       └── app/
│           ├── build.gradle    # package: com.sprestay.autodealapp
│           └── google-services.json
├── web/               # Веб-версия (почти идентична app/)
├── admin/             # Админ-панель (Flutter Web)
│   └── firebase/
│       ├── firestore.rules     # Правила безопасности Firestore
│       ├── storage.rules       # Правила безопасности Storage
│       ├── firestore.indexes.json
│       └── functions/          # Cloud Functions (Node.js/TypeScript)
├── docs/              # Документация (этот файл)
└── README.md
\\\

### Технологический стек

**Frontend:**
- Flutter 3.x (SDK >=3.0.0, рекомендуется 3.19.6)
- Dart 3.x
- 73 зависимости (все запинены на конкретные версии ~2024)
- FlutterFlow-генерированный код (паттерн: \*_widget.dart\ + \*_model.dart\)

**Backend:**
- Firebase (проект: \dealertodealer-84957\)
  - **Firestore** — основная БД (документо-ориентированная)
  - **Firebase Auth** — авторизация (Google, Apple, Facebook, Email)
  - **Cloud Functions** — серверная логика (пока только \ddFcmToken\)
  - **Cloud Storage** — файлы (фото авто, документы)
  - **Firebase Messaging (FCM)** — push-уведомления
  - **Firebase Analytics** — аналитика
  - **Firebase Performance** — мониторинг производительности

**Платежи и подписки:**
- RevenueCat — управление подписками (iOS/Android)

**Карты и геолокация:**
- Google Maps Platform — отображение карт, маршруты
- Mapbox Search API — поиск адресов, автокомплит

**Локализация:**
- Поддержка русского и английского языков

### Архитектурные особенности

**Паттерн FlutterFlow:**
- Каждый экран = \*_widget.dart\ (UI) + \*_model.dart\ (состояние)
- Вся бизнес-логика внутри виджетов (нет отдельного слоя services/repositories)
- Служебный код (\lutter_flow/\) генерируется автоматически

**Состояние приложения:**
- \FFAppState\ — синглтон над \shared_preferences\
- Хранит черновик сделки (9 фото, 5 файлов, цена, адрес)
- Не переживает переустановку, но переживает выход из аккаунта

**Данные:**
- Клиенты пишут в Firestore **напрямую** из виджетов (через \.update()\, \.add()\)
- Схема данных сгенерирована как Dart record-классы
- **Критично:** Финансовая логика (начисление заработка, списание баланса) выполняется на клиенте

---

## Схема данных

### Коллекции Firestore

#### \users\ — Пользователи

\\\dart
{
  email: String
  display_name: String
  photo_url: String
  uid: String
  created_time: Timestamp
  phone_number: String
  
  // Роль (Diller или Carrier)
  type: Enum<UserType>  // Diller, Carrier
  
  // Финансы
  balance: double                    // Баланс пользователя
  carrier_total_earning: double      // Общий заработок перевозчика
  free_deal_count: int               // Бесплатные сделки (дилер)
  free_response_count: int           // Бесплатные отклики (перевозчик)
  
  // Рейтинг
  rate: double                       // Средний рейтинг
  rate_count: int                    // Количество оценок
  
  // Профиль
  profile_filled: bool
  
  // Данные перевозчика
  carrier_company_name: String
  carrier_number: String             // MC/DOT number (пока просто строка)
  carrier_driver_license: String
  file: String                       // URL файла (лицензия)
  
  // Данные дилера
  diller_license: String
  diller_driver_license: String
  diller_driver_date: Timestamp
  diller_cars: Array<String>
  
  // Модерация
  banned: bool
  banned_time: Timestamp
}
\\\

**⚠️ Критические поля для KYC (в планах):**
- \carrier_number\, \diller_license\ — сейчас просто строки, нужна автопроверка через FMCSA API
- \erified: bool\ — статус верификации (добавим)
- \erification_date: Timestamp\ — дата проверки (добавим)
- \company_legal_name: String\ — полное юрид. название из реестра (добавим)

#### \deals\ — Сделки

\\\dart
{
  // Автомобиль
  car_name: String
  car_number: String              // VIN или номер
  car_photos: Array<String>       // URLs фото
  files: Array<String>            // Дополнительные файлы (документы)
  
  // Маршрут
  location: GeoPoint              // Откуда (точка назначения для дилера)
  location_address: String
  request_location: GeoPoint      // Откуда забрать (для перевозчика)
  geo_request_date: Timestamp
  
  // Описание
  description: String
  deal_date: Timestamp            // Желаемая дата доставки
  created_time: Timestamp
  
  // Финансы
  price: int                      // Цена за доставку (центы)
  pay_type: String                // Тип оплаты
  pay_token_value: int            // Токены (для будущих платежей)
  
  // Участники
  owner: DocumentReference        // users/{uid} — дилер
  carrier: DocumentReference      // users/{uid} — перевозчик (выбранный)
  carriers: Array<DocumentReference>  // Все откликнувшиеся перевозчики
  
  // Статус сделки
  status: Enum<DealStatus>        // InSearch, InConfirm, InActive, InDispute, Completed, Canceled, CanceledByAdmin
  
  // Аукцион
  auction: DocumentReference      // auctions/{id}
  responses: Array<ResponseStruct>  // Отклики перевозчиков с их ставками
  
  // Завершение
  completed_by: DocumentReference
  owner_rate: double              // Оценка дилера перевозчиком
  review_by_diller: DocumentReference
  review_by_carrier: DocumentReference
  
  // Споры
  disput_created_by: DocumentReference
  cancel_reason: DocumentReference
}
\\\

**⚠️ Поля для страхования (добавим):**
- \insurance_required: bool\ — нужна ли страховка
- \insurance_policy_id: String\ — ID полиса страховой компании
- \insurance_cost: int\ — стоимость страховки (центы)
- \insurance_provider: String\ — название страховщика
- \insurance_document_url: String\ — ссылка на документ полиса

#### \uctions\ — Аукционы

\\\dart
{
  deal_id: DocumentReference      // ссылка на deals/{id}
  bids: Array<BidStruct> {
    carrier: DocumentReference
    price: int
    created_time: Timestamp
  }
  status: String                  // active, closed
  created_time: Timestamp
}
\\\

#### \eviews\ — Отзывы

\\\dart
{
  deal_id: DocumentReference
  from: DocumentReference         // кто оставил
  receiver: DocumentReference     // кому
  rate: double                    // 1-5
  comment: String
  created_time: Timestamp
}
\\\

**⚠️ Категоризированные рейтинги (добавим):**
- \categories: Map<String, double>\ — например:
  - Для перевозчика: \on_time\, \ehicle_condition\, \communication\
  - Для дилера: \payment_speed\, \ccurate_description\, \esponsive\

#### \	ransactions\ — Транзакции

\\\dart
{
  user: DocumentReference
  amount: double
  type: String                    // debit, credit
  description: String
  created_time: Timestamp
  deal_id: DocumentReference
}
\\\

#### \chats\ — Чаты

\\\dart
{
  users: Array<DocumentReference>  // [diller, carrier]
  deal_id: DocumentReference
  last_message: String
  last_message_time: Timestamp
}
\\\

**Подколлекция \message\:**
\\\dart
{
  text: String
  sender: DocumentReference
  timestamp: Timestamp
  read: bool
}
\\\

#### \complains\ — Жалобы

\\\dart
{
  from: DocumentReference
  receiver: DocumentReference
  deal_ref: DocumentReference
  type: String                    // на пользователя, на сделку
  reason: String
  time: Timestamp
  status: String                  // pending, resolved, rejected
}
\\\

### Статусы сделки (DealStatus enum)

\\\
InSearch         → Дилер создал сделку, ждёт откликов
InConfirm        → Дилер выбрал перевозчика, ждёт подтверждения
InActive         → Доставка в процессе
InDispute        → Открыт спор (админ разбирает)
InConfirmComplete → Ожидание финального подтверждения
Completed        → Сделка завершена, стороны оценили друг друга
Canceled         → Отменена одной из сторон
CanceledByAdmin  → Отменена администратором
\\\

---

## Что уже работает

### Основной функционал ✅

1. **Регистрация и авторизация:**
   - Google Sign-In
   - Apple Sign-In
   - Facebook Login
   - Email/Password

2. **Роли:**
   - **Diller (дилер)** — создаёт сделки, выбирает перевозчика
   - **Carrier (перевозчик)** — откликается на сделки, везёт авто

3. **Жизненный цикл сделки:**
   - Дилер создаёт заказ (откуда-куда, фото авто, описание, цена)
   - Перевозчики видят все заказы в статусе \InSearch\
   - Перевозчик откликается → сделка переходит в \InConfirm\
   - Дилер выбирает перевозчика из откликнувшихся
   - Перевозчик подтверждает → сделка в \InActive\
   - После доставки → \Completed\
   - Стороны оценивают друг друга (reviews)

4. **Аукцион:**
   - Перевозчики делают ставки (bid) на сделку
   - Дилер видит список ставок в реальном времени
   - Может выбрать любую ставку (не обязательно минимальную)

5. **Чат:**
   - Переписка между дилером и перевозчиком по конкретной сделке
   - Уведомления о новых сообщениях

6. **Споры (Disputes):**
   - Любая сторона может открыть спор
   - Админ в панели рассматривает жалобу и разрешает сделку

7. **Отзывы:**
   - После \Completed\ обе стороны оставляют рейтинг (1-5) и комментарий
   - Средний рейтинг отображается в профиле пользователя

8. **Жалобы (Complains):**
   - Пользователи могут пожаловаться друг на друга
   - Админ видит все жалобы и может забанить нарушителя

9. **Геолокация:**
   - Google Maps для отображения маршрутов
   - Mapbox Search для автокомплита адресов
   - Фильтрация сделок по геолокации (пока на клиенте)

10. **Push-уведомления:**
    - FCM настроен, токены сохраняются через Cloud Function \ddFcmToken\

11. **Подписки:**
    - RevenueCat интегрирован (есть код для покупки subscription)
    - Отслеживание \ree_deal_count\ и \ree_response_count\

12. **Админ-панель:**
    - Жалобы по сделкам и пользователям
    - Просмотр всех заказов, отзывов, транзакций
    - Базовая аналитика
    - Управление персоналом (воркеры)
    - Бан пользователей

---

## Критические проблемы

### 🔴 1. Финансовая логика на клиенте

**Проблема:**  
Начисление заработка, списание бесплатных откликов, смена статусов сделок происходит **из приложения**.

**Пример кода (\deal_detail_carrier_widget.dart:336\):**
\\\dart
await widget.deal!.reference.update({
  'carrier': currentUserReference,
  'carrier_total_earning': FieldValue.increment(price),  // 💣 начисление на клиенте!
  'status': DealStatus.InActive,
});
\\\

**Риск:**  
Модифицированный клиент (или прямой вызов Firestore API из скрипта) может:
- Начислять себе деньги
- Списывать чужой баланс
- Менять статусы чужих сделок
- Обнулять \ree_response_count\ для бесконечных откликов

**Решение:**  
Перенести всю money-path логику в Cloud Functions с проверкой прав.

---

### 🔴 2. Firestore Rules слишком открытые

**Текущие правила (\irestore.rules\):**
\\\
match /deals/{document} {
  allow create: if true;    // Любой может создать
  allow read: if true;      // Любой может прочитать
  allow write: if false;    // Изменение запрещено
  allow delete: if false;
}
\\\

**Проблема:**  
- \write: false\ запрещает \.update()\, но клиент всё равно его вызывает → значит, где-то rules перезаписываются в консоли, либо есть race condition с деплоем.
- Нет проверки владения: любой может прочитать все сделки (включая приватные данные).

**Решение:**  
Ужесточить rules после переноса логики в Cloud Functions:
\\\
match /deals/{dealId} {
  allow read: if request.auth != null &&
    (resource.data.owner == request.auth.uid ||
     resource.data.carrier == request.auth.uid ||
     request.auth.uid in resource.data.carriers);
  allow create: if request.auth != null && request.auth.token.type == 'Diller';
  allow update, delete: if false;  // Только через Cloud Functions
}
\\\

---

### 🔴 3. Производительность списка сделок

**Проблема:**  
В \home_page_widget.dart:511-522\ стримятся **все сделки**, фильтры применяются на клиенте:
\\\dart
StreamBuilder<List<DealsRecord>>(
  stream: queryDealsRecord(),  // Все документы!
  builder: (context, snapshot) {
    final filtered = snapshot.data?.where((deal) =>
      deal.status == DealStatus.InSearch &&
      isInRadius(deal.location, userLocation, 50) &&  // 💣 геофильтр на клиенте
      deal.price >= minPrice && deal.price <= maxPrice
    ).toList();
    ...
  }
)
\\\

**Риск:**  
При 1000+ активных сделок:
- Загрузка 1–2 МБ данных на каждое открытие приложения
- Firestore читает все документы → растёт счёт за чтение
- Фильтры на клиенте → задержка UI

**Решение:**
1. Составные индексы: \status + created_time\
2. Геопоиск через geohash (префиксный запрос)
3. Пагинация (\limit(20).startAfter(lastDoc)\)
4. Опционально: Cloud Function для complex-запросов

---

### 🟡 4. Тройное дублирование кода

**Проблема:**  
- \pp/\ и \web/\ — почти идентичны (даже package ID \com.sprestay.autodealapp\)
- \dmin/\ дублирует схему (\lib/backend/schema/\)
- Любое изменение модели данных нужно вносить в 3 местах

**Решение:**  
1. Проверить, можно ли собрать Web из \pp/\ через \lutter build web\
2. Схему вынести в общий пакет (\packages/dtd_models/\)
3. Использовать melos для монорепо-управления

---

### 🟡 5. Нет исходника FlutterFlow-проекта

**Проблема:**  
Код экспортирован из FlutterFlow, но сам проект в репо не попал.

**Риск:**  
При следующей генерации из FlutterFlow все ручные правки затрутся.

**Решение:**  
1. Уточнить у заказчика статус FlutterFlow-проекта
2. Если есть доступ → положить ссылку/бэкап в README
3. Если нет → работать только с Dart-кодом, не пересобирать из FlutterFlow

---

### 🟡 6. Отсутствие тестов и CI/CD

**Текущее состояние:**  
- \	est/\ — только заглушки Flutter
- CI: есть заготовка \.github/workflows/ios-build.yml\ (ручной запуск)
- Нет автотестов, нет автодеплоя

**Решение:**  
1. GitHub Actions: \lutter analyze\ + сборка APK/Web на каждый коммит
2. Unit-тесты для схемы данных (\DealsRecord\, \UsersRecord\)
3. Integration-тесты для критичных флоу (создание сделки, отклик, завершение)

---

### 🟡 7. Мониторинг и алертинг

**Текущее состояние:**  
- Firebase Performance включён, но не настроен
- Crashlytics не подключён
- Нет Sentry или аналогов
- Ошибки приложения не логируются централизованно

**Решение:**  
1. Подключить Firebase Crashlytics
2. Настроить алерты в Firebase Console (ошибки, падения, медленные запросы)
3. Опционально: Sentry для более детальных логов

---

## Анализ конкурентов

### Central Dispatch — индустриальный стандарт

**Кто они:**  
Крупнейший маркетплейс авто-перевозок США (с 1999 года, часть Cox Automotive).  
20,000+ перевозчиков, 10 млн авто/год.

**Что у них сильное:**

1. **Price Check / Price Check Plus (AI-pricing):**
   - Показывает рыночные цены аналогичных маршрутов
   - AI-модель предсказывает оптимальную цену + время до dispatch
   - Помогает дилерам и перевозчикам принимать обоснованные решения

2. **Двусторонняя рейтинговая система:**
   - Перевозчики оценивают дилеров (платёжная дисциплина, описание авто)
   - Дилеры оценивают перевозчиков (аккуратность, сроки)
   - Категоризированные оценки (не просто 1-5)

3. **Real-Time Tracking:**
   - Live-отслеживание локации перевозчика во время доставки
   - Push-уведомления о ключевых этапах

4. **Verified Transactions:**
   - Оценить можно только после завершённой сделки
   - Нельзя накрутить фейковые отзывы

5. **Fraud Protection & KYC:**
   - Верификация всех участников (DOT/MC лицензии)
   - История рейтингов → видно опыт

6. **Premium-тарифы:**
   - Базовый: доступ к маркетплейсу
   - Premium: AI-цены, live tracking, приоритетная поддержка

7. **Dashboard с аналитикой:**
   - Единый экран: активные, completed, revenue, metrics
   - Экспорт в CSV/PDF

**Чего у них НЕТ (наше преимущество):**
- ❌ Встроенного страхования (только marketplace)
- ❌ Фокуса на частных водителей (gig-экономика)
- ❌ Аукциона со ставками в реальном времени
- ❌ Умной системы обмена маршрутами (патент DTD)

---

## План доработок

### Приоритет заказчика (1–2 недели)

#### Фича 1: Страхование перегона авто

**Цель:** Дилер/перевозчик может купить страховку на доставку прямо в приложении.

**Задачи:**
1. **Выбор страховой компании-партнёра:**
   - Например: Progressive Commercial Auto, Nationwide, Liberty Mutual
   - Нужен API для получения quote и покупки полиса
2. **Расширение схемы \deals\:**
   - \insurance_required: bool\
   - \insurance_policy_id: String\
   - \insurance_cost: int\
   - \insurance_provider: String\
   - \insurance_document_url: String\
3. **UI в создании сделки:**
   - Чекбокс "Требуется страховка"
   - Кнопка "Получить расчёт" → API-запрос к страховщику
   - Показ стоимости полиса
   - Кнопка "Купить страховку" → оплата через партнёра или Stripe
4. **Отображение страховки:**
   - В карточке сделки — бейдж "Insured"
   - Ссылка на скачивание полиса (PDF)
5. **Cloud Function \calculateInsurance\:**
   - Принимает: маршрут, тип авто, стоимость авто
   - Возвращает: quote от страховщика
6. **Cloud Function \purchaseInsurance\:**
   - Покупка полиса через API страховщика
   - Сохранение \insurance_policy_id\ в сделку
   - Транзакция для оплаты

**Интеграция:**  
Если страховая не даёт API → начать с реферальной ссылки (партнёрская программа).

---

#### Фича 2: Автопроверка/автозаполнение партнёров (KYC)

**Цель:** Верификация дилеров и перевозчиков через официальные базы данных (для США — FMCSA).

**Задачи:**
1. **API-интеграция с FMCSA (Federal Motor Carrier Safety Administration):**
   - Endpoint: \https://mobile.fmcsa.dot.gov/qc/services/carriers/{DOT_NUMBER}\
   - Бесплатный публичный API для проверки MC/DOT номеров
   - Возвращает: legal_name, address, safety_rating, insurance_info
2. **Расширение схемы \users\:**
   - \erified: bool\ (статус верификации)
   - \erification_date: Timestamp\
   - \company_legal_name: String\ (из FMCSA)
   - \safety_rating: String\ (Satisfactory, Conditional, Unsatisfactory)
   - \dot_number: String\
   - \mc_number: String\
3. **UI верификации:**
   - Экран "Verify Your Company"
   - Поле ввода DOT или MC номера
   - Кнопка "Проверить" → запрос в FMCSA API
   - Автозаполнение: company_legal_name, address
   - Кнопка "Подтвердить" → сохранение в профиль
4. **Бейдж "Verified":**
   - Показывается в профиле пользователя
   - В списке сделок — иконка галочки рядом с именем
5. **Ограничения для неверифицированных:**
   - Перевозчик не может откликаться на сделки
   - Дилер не может создавать сделки
   - Уведомление: "Complete verification to access features"
6. **Cloud Function \erifyCarrier\ / \erifyDealer\:**
   - Запрос в FMCSA API
   - Валидация данных
   - Обновление профиля пользователя
   - Audit log записи

**Альтернатива:**  
Если FMCSA API не подходит → ручная модерация в админке + загрузка документов.

---

### Фаза 0: Foundation (неделя, параллельно с фичами заказчика)

**Цель:** Код готов для команды разработки и аудита инвесторов.

1. ✅ **Монорепо** — уже есть
2. **Firebase rules в git:**
   - Перенести \irestore.rules\/\storage.rules\ из консоли в \dmin/firebase/\
   - Настроить \irebase deploy --only firestore:rules,storage\
3. **CI/CD:**
   - GitHub Actions: \lutter analyze\ на каждый PR
   - Автосборка APK/Web на \main\ branch
   - Деплой админ-панели на Firebase Hosting
4. **Базовые тесты:**
   - Unit-тесты для \DealsRecord\, \UsersRecord\
   - Widget-тесты для критичных экранов
5. **Мониторинг:**
   - Подключить Firebase Crashlytics
   - Настроить алерты (ошибки, падения)

---

### Фаза 1: Security (критично, 3–5 дней)

**Цель:** Убрать возможность fraud'а с деньгами.

1. **Cloud Functions для money-path:**
   - \espondToDeal\ — списание \ree_response_count\
   - \confirmCarrier\ — подтверждение перевозчика
   - \completeDeal\ — начисление \carrier_total_earning\ + создание \TransactionsRecord\
   - \openDispute\, \cancelDeal\ — статусные переходы
2. **Ужесточение Firestore rules:**
   - Запись в \deals/\, \	ransactions/\, \eviews/\ только через functions
   - Чтение с проверкой участия в сделке
3. **Firebase App Check:**
   - Защита от поддельных клиентов
   - reCAPTCHA для Web, DeviceCheck/Play Integrity для мобильных
4. **Audit log:**
   - Новая коллекция \udit_logs\ для всех финансовых операций

---

### Фаза 2: Scale (неделя)

**Цель:** Приложение выдержит 10,000+ активных сделок.

1. **Фильтры на сервере:**
   - Геопоиск через geohash
   - Составные индексы \status + created_time\
   - Пагинация (\limit + startAfter\)
2. **Кеширование:**
   - Cloud Functions для поиска "ближайшего перевозчика"
   - Invalidation при создании/обновлении сделок

---

### Фаза 3: Business Features (2–3 недели)

**Цель:** Реализовать монетизацию и viral-механики.

1. **Ваучеры и подписки:**
   - Модель \VoucherCodes\ в Firestore
   - Интеграция с RevenueCat (Basic/Pro/Enterprise планы)
   - Free trial 5 откликов
2. **Реферальная программа:**
   - Промокоды для привлечения
   - Бонусы за приглашённых
3. **Escrow платежей:**
   - Stripe Connect для hold'а денег до завершения
   - Автоматический release при \completeDeal\

---

### Фаза 4: Killer Features (из анализа Central Dispatch)

1. **AI Price Suggestions:**
   - Автоподсказка цены на основе исторических данных
   - ML-модель для предсказания оптимальной цены
2. **Категоризированные рейтинги:**
   - Не просто 5 звёзд, а разбивка (\on_time\, \ehicle_condition\, \communication\)
3. **Live GPS Tracking:**
   - Отслеживание перевозчика в реальном времени
   - Push-уведомления: "Carrier picked up", "Estimated arrival in 2 hours"
4. **Personal Dashboard:**
   - Аналитика для каждого пользователя (заработок, топ-маршруты, динамика)

---

## Roadmap

### Sprint 1 (неделя 1–2): Приоритет заказчика
- [ ] Интеграция страхования (API партнёра или реферальная ссылка)
- [ ] KYC через FMCSA API (автопроверка DOT/MC номеров)
- [ ] UI для верификации и покупки страховки

### Sprint 2 (неделя 3): Foundation + Security
- [ ] Firebase rules в git, CI/CD
- [ ] Cloud Functions для money-path
- [ ] Firebase App Check, Crashlytics

### Sprint 3 (неделя 4): Scale + Business Features
- [ ] Геопоиск через geohash, пагинация
- [ ] Ваучеры, реферальная программа
- [ ] Escrow платежей (Stripe Connect)

### Sprint 4 (неделя 5–6): Killer Features
- [ ] AI Price Suggestions (MVP)
- [ ] Live GPS Tracking
- [ ] Категоризированные рейтинги
- [ ] Personal Dashboard

### Sprint 5+ (long-term):
- [ ] Рент-кары как отдельная роль
- [ ] Частные водители (gig-экономика)
- [ ] Адаптация под другие страны (не только США)

---

## Контакты и ресурсы

**GitHub:** https://github.com/aliter230880/dtd  
**Firebase Console:** https://console.firebase.google.com/project/dealertodealer-84957  
**Package ID:** \com.sprestay.autodealapp\  
**Основатель:** Леонид Лифшиц  
**Патент:** PATENT PENDING (28 октября 2025)

---

**Этот документ — живая документация.**  
Обновляется при каждом значительном изменении архитектуры или планов.
