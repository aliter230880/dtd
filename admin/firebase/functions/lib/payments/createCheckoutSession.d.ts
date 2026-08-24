/**
 * createCheckoutSession Cloud Function
 *
 * Создаёт сессию Stripe Checkout для пополнения кошелька.
 * Баланс здесь НЕ начисляется — это делает вебхук после подтверждения оплаты
 * (см. stripeWebhook.ts).
 *
 * Конфигурация:
 *   firebase functions:config:set stripe.secret_key="sk_..." \
 *     stripe.success_url="https://.../wallet?paid=1" \
 *     stripe.cancel_url="https://.../wallet"
 */
import * as functions from 'firebase-functions';
export declare const createCheckoutSession: functions.HttpsFunction & functions.Runnable<any>;
