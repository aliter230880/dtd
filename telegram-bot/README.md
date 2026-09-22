# DTD: Telegram-бот с еженедельной аналитикой (ТЗ v2, ДОП-3)

Отправляет сводку за последние 7 дней в Telegram-чат каждый понедельник в 09:00 UTC:
количество заказов (созданные / открытые / выполненные), новых пользователей,
объём купленной внутренней валюты и выручку от её покупки.

## Что нужно подготовить (один раз)

1. **Бот**: в Telegram у [@BotFather](https://t.me/BotFather) — `/newbot`, получить токен вида `123456:ABC-DEF...`.
2. **Chat ID**: добавить бота в группу (или написать ему) и узнать id чата,
   например через [@getidsbot](https://t.me/getidsbot) (для групп id отрицательный).
3. **Доступ к Firebase**: локально установить `npm i -g firebase-tools` и выполнить
   `firebase login` под аккаунтом с правами на проект **dtdapp007**
   (для scheduled functions нужен тариф Blaze — привязка карты, оплата только сверх лимитов).

## Деплой

```bash
cd telegram-bot
npm install

# подключить проект и secrets (один раз)
firebase use dtdapp007
firebase functions:secrets:set TELEGRAM_BOT_TOKEN   # вставить токен бота
firebase functions:secrets:set TELEGRAM_CHAT_ID     # вставить id чата

firebase deploy --only functions
```

## Проверка без ожидания понедельника

В консоли Firebase → Functions → `weeklyReport` → «Test»/запуск вручную,
либо временно поменять cron в `index.js` (например, на `*/5 * * * *`) и передеплоить.

## Примечания по данным

- Поля соответствуют схеме приложения: `deals.created_time/status`, `users.created_time`,
  `transactions.{type, amount, amount_price, created_time}`.
- Тип транзакции «покупка валюты» определяется эвристически (`topup`/`purchase`);
  если в БД другой тип — поправить условие в `index.js` (строка с `data.type`).
