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
import Stripe from 'stripe';

import { findPackage, sanitizeMethodTypes } from './packages';

interface CreateCheckoutRequest {
  credits: number;
  methodTypes?: string[];
}

interface CreateCheckoutResponse {
  url: string;
  sessionId: string;
}

export const createCheckoutSession = functions.https.onCall(
  async (
    data: CreateCheckoutRequest,
    context: functions.https.CallableContext
  ): Promise<CreateCheckoutResponse> => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Требуется авторизация'
      );
    }

    const selected = findPackage(data?.credits);
    if (!selected) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Неизвестный пакет пополнения'
      );
    }

    const stripeConfig = functions.config().stripe ?? {};
    const secretKey: string | undefined = stripeConfig.secret_key;
    if (!secretKey) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Stripe не сконфигурирован'
      );
    }

    const stripe = new Stripe(secretKey, { apiVersion: '2020-08-27' });
    const uid = context.auth.uid;

    try {
      const session = await stripe.checkout.sessions.create({
        mode: 'payment',
        payment_method_types: sanitizeMethodTypes(
          data?.methodTypes
        ) as Stripe.Checkout.SessionCreateParams.PaymentMethodType[],
        client_reference_id: uid,
        // Метаданные читает вебхук, чтобы понять кому и сколько начислить.
        metadata: {
          uid,
          credits: String(selected.credits),
        },
        line_items: [
          {
            quantity: 1,
            price_data: {
              currency: selected.currency,
              unit_amount: selected.amountCents,
              product_data: {
                name: `Пополнение кошелька DTD: ${selected.credits} кредитов`,
              },
            },
          },
        ],
        success_url: stripeConfig.success_url ?? 'https://dtdweb.web.app/walletPage',
        cancel_url: stripeConfig.cancel_url ?? 'https://dtdweb.web.app/walletPage',
      });

      if (!session.url) {
        throw new functions.https.HttpsError(
          'internal',
          'Stripe не вернул ссылку на оплату'
        );
      }

      return { url: session.url, sessionId: session.id };
    } catch (error) {
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      console.error('Stripe checkout error', error);
      throw new functions.https.HttpsError(
        'internal',
        'Не удалось создать платёжную сессию'
      );
    }
  }
);
