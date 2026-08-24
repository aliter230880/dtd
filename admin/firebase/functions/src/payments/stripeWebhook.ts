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
import * as admin from 'firebase-admin';
import Stripe from 'stripe';

export const stripeWebhook = functions.https.onRequest(async (req, res) => {
  const stripeConfig = functions.config().stripe ?? {};
  const secretKey: string | undefined = stripeConfig.secret_key;
  const webhookSecret: string | undefined = stripeConfig.webhook_secret;

  if (!secretKey || !webhookSecret) {
    console.error('Stripe webhook is not configured');
    res.status(500).send('Stripe is not configured');
    return;
  }

  const stripe = new Stripe(secretKey, { apiVersion: '2020-08-27' });
  const signature = req.headers['stripe-signature'];

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(
      // rawBody обязателен: по разобранному JSON подпись не сходится.
      (req as functions.https.Request).rawBody,
      signature as string,
      webhookSecret
    );
  } catch (error) {
    console.error('Invalid Stripe signature', error);
    res.status(400).send('Invalid signature');
    return;
  }

  if (event.type !== 'checkout.session.completed') {
    res.status(200).send('Ignored');
    return;
  }

  const session = event.data.object as Stripe.Checkout.Session;
  const uid = session.metadata?.uid;
  const credits = Number(session.metadata?.credits);

  if (!uid || !Number.isInteger(credits) || credits <= 0) {
    console.error('Checkout session without valid metadata', session.id);
    res.status(400).send('Missing metadata');
    return;
  }

  const firestore = admin.firestore();
  const eventRef = firestore.collection('stripe_events').doc(session.id);

  try {
    await firestore.runTransaction(async (tx) => {
      const alreadyHandled = await tx.get(eventRef);
      if (alreadyHandled.exists) {
        return;
      }

      const userRef = firestore.collection('users').doc(uid);
      tx.update(userRef, {
        balance: admin.firestore.FieldValue.increment(credits),
      });

      tx.set(firestore.collection('transactions').doc(), {
        amount: credits,
        amount_price: (session.amount_total ?? 0) / 100,
        type: 'popup',
        user_ref: userRef,
        payment_provider: 'stripe',
        payment_session_id: session.id,
        created_time: admin.firestore.FieldValue.serverTimestamp(),
      });

      tx.set(eventRef, {
        uid,
        credits,
        handled_at: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    res.status(200).send('OK');
  } catch (error) {
    console.error('Failed to apply checkout session', session.id, error);
    // 500 заставит Stripe повторить доставку события.
    res.status(500).send('Failed to apply payment');
  }
});
