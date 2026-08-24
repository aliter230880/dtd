"use strict";
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
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.stripeWebhook = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const stripe_1 = __importDefault(require("stripe"));
exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
    var _a, _b, _c;
    const stripeConfig = (_a = functions.config().stripe) !== null && _a !== void 0 ? _a : {};
    const secretKey = stripeConfig.secret_key;
    const webhookSecret = stripeConfig.webhook_secret;
    if (!secretKey || !webhookSecret) {
        console.error('Stripe webhook is not configured');
        res.status(500).send('Stripe is not configured');
        return;
    }
    const stripe = new stripe_1.default(secretKey, { apiVersion: '2020-08-27' });
    const signature = req.headers['stripe-signature'];
    let event;
    try {
        event = stripe.webhooks.constructEvent(
        // rawBody обязателен: по разобранному JSON подпись не сходится.
        req.rawBody, signature, webhookSecret);
    }
    catch (error) {
        console.error('Invalid Stripe signature', error);
        res.status(400).send('Invalid signature');
        return;
    }
    if (event.type !== 'checkout.session.completed') {
        res.status(200).send('Ignored');
        return;
    }
    const session = event.data.object;
    const uid = (_b = session.metadata) === null || _b === void 0 ? void 0 : _b.uid;
    const credits = Number((_c = session.metadata) === null || _c === void 0 ? void 0 : _c.credits);
    if (!uid || !Number.isInteger(credits) || credits <= 0) {
        console.error('Checkout session without valid metadata', session.id);
        res.status(400).send('Missing metadata');
        return;
    }
    const firestore = admin.firestore();
    const eventRef = firestore.collection('stripe_events').doc(session.id);
    try {
        await firestore.runTransaction(async (tx) => {
            var _a;
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
                amount_price: ((_a = session.amount_total) !== null && _a !== void 0 ? _a : 0) / 100,
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
    }
    catch (error) {
        console.error('Failed to apply checkout session', session.id, error);
        // 500 заставит Stripe повторить доставку события.
        res.status(500).send('Failed to apply payment');
    }
});
//# sourceMappingURL=stripeWebhook.js.map