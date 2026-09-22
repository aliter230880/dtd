/**
 * DTD: еженедельная аналитика в Telegram (ТЗ v2, ДОП-3).
 *
 * Отправляет сводку за последние 7 дней:
 *  - количество заказов (созданные / открытые / выполненные);
 *  - количество новых пользователей;
 *  - сумма покупок внутренней валюты (реальные деньги);
 *  - количество купленной валюты.
 *
 * Настройка перед деплоем (один раз):
 *   firebase functions:secrets:set TELEGRAM_BOT_TOKEN   # токен от @BotFather
 *   firebase functions:secrets:set TELEGRAM_CHAT_ID     # id чата/группы
 *
 * Деплой (из этой папки):
 *   npm install
 *   firebase deploy --only functions
 *
 * Расписание: каждый понедельник 09:00 по UTC (см. cron ниже).
 */
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");

const TELEGRAM_BOT_TOKEN = defineSecret("TELEGRAM_BOT_TOKEN");
const TELEGRAM_CHAT_ID = defineSecret("TELEGRAM_CHAT_ID");

admin.initializeApp();
const db = admin.firestore();

const WEEK_MS = 7 * 24 * 60 * 60 * 1000;

function isStatus(status, name) {
  return typeof status === "string" && status.endsWith(name);
}

async function sendToTelegram(text) {
  const token = TELEGRAM_BOT_TOKEN.value();
  const chatId = TELEGRAM_CHAT_ID.value();
  const url = `https://api.telegram.org/bot${token}/sendMessage`;
  const resp = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      chat_id: chatId,
      text,
      parse_mode: "HTML",
    }),
  });
  if (!resp.ok) {
    const body = await resp.text();
    throw new Error(`Telegram API ${resp.status}: ${body}`);
  }
}

exports.weeklyReport = onSchedule(
  {
    schedule: "0 9 * * 1", // каждый понедельник 09:00 UTC
    timeZone: "UTC",
    secrets: [TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID],
  },
  async () => {
    const since = new Date(Date.now() - WEEK_MS);

    // Заказы за период
    const dealsSnap = await db
      .collection("deals")
      .where("created_time", ">=", since)
      .get();
    let created = 0;
    let open = 0;
    let completed = 0;
    dealsSnap.forEach((d) => {
      const data = d.data() || {};
      created += 1;
      if (isStatus(data.status, "Completed")) completed += 1;
      else if (["InSearch", "InConfirm", "InActive", "InDispute", "InConfirmComplete"].some((s) => isStatus(data.status, s)))
        open += 1;
    });

    // Новые пользователи
    const usersSnap = await db
      .collection("users")
      .where("created_time", ">=", since)
      .get();
    const newUsers = usersSnap.size;

    // Покупки внутренней валюты
    const txSnap = await db
      .collection("transactions")
      .where("created_time", ">=", since)
      .get();
    let currencyBought = 0;
    let moneySpent = 0;
    txSnap.forEach((t) => {
      const data = t.data() || {};
      if (data.type === "topup" || data.type === "TopUp" || data.type === "purchase") {
        currencyBought += Number(data.amount) || 0;
        moneySpent += Number(data.amount_price) || 0;
      }
    });

    const fmt = (n) => (Math.round(n * 100) / 100).toString();
    const lines = [
      "<b>DTD: сводка за неделю</b>",
      `Заказы всего: <b>${created}</b>`,
      `• открытые: ${open}`,
      `• выполненные: ${completed}`,
      `Новые пользователи: <b>${newUsers}</b>`,
      `Куплено валюты: <b>${fmt(currencyBought)}</b>`,
      `Выручка от покупки валюты: <b>${fmt(moneySpent)}</b>`,
    ];

    await sendToTelegram(lines.join("\n"));
  }
);
