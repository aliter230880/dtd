/**
 * stripeWebhook — HTTP-функция, принимающая события Stripe.
 *
 * Единственное место, где начисляется баланс: клиент не может увеличить его сам.
 * Подпись запроса проверяется через stripe.webhook_secret, повторные события
 * отсекаются по id сессии (коллекция `stripe_events`).
 *
 * Конфигурация:
 *   firebase functions:config:set stripe.secret_key="sk_..." \
 *     stripe.webhook_secret="whsec_..."
 * Регистрация эндпоинта в Stripe: событие checkout.session.completed →
 *   https://<region>-<project>.cloudfunctions.net/stripeWebhook
 */
import * as functions from 'firebase-functions';
export declare const stripeWebhook: functions.HttpsFunction;
