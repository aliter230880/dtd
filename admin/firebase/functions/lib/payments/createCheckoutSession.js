"use strict";
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
exports.createCheckoutSession = void 0;
const functions = __importStar(require("firebase-functions"));
const stripe_1 = __importDefault(require("stripe"));
const packages_1 = require("./packages");
exports.createCheckoutSession = functions.https.onCall(async (data, context) => {
    var _a, _b, _c;
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'Требуется авторизация');
    }
    const selected = (0, packages_1.findPackage)(data === null || data === void 0 ? void 0 : data.credits);
    if (!selected) {
        throw new functions.https.HttpsError('invalid-argument', 'Неизвестный пакет пополнения');
    }
    const stripeConfig = (_a = functions.config().stripe) !== null && _a !== void 0 ? _a : {};
    const secretKey = stripeConfig.secret_key;
    if (!secretKey) {
        throw new functions.https.HttpsError('failed-precondition', 'Stripe не сконфигурирован');
    }
    const stripe = new stripe_1.default(secretKey, { apiVersion: '2020-08-27' });
    const uid = context.auth.uid;
    try {
        const session = await stripe.checkout.sessions.create({
            mode: 'payment',
            payment_method_types: (0, packages_1.sanitizeMethodTypes)(data === null || data === void 0 ? void 0 : data.methodTypes),
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
            success_url: (_b = stripeConfig.success_url) !== null && _b !== void 0 ? _b : 'https://dtdweb.web.app/walletPage',
            cancel_url: (_c = stripeConfig.cancel_url) !== null && _c !== void 0 ? _c : 'https://dtdweb.web.app/walletPage',
        });
        if (!session.url) {
            throw new functions.https.HttpsError('internal', 'Stripe не вернул ссылку на оплату');
        }
        return { url: session.url, sessionId: session.id };
    }
    catch (error) {
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        console.error('Stripe checkout error', error);
        throw new functions.https.HttpsError('internal', 'Не удалось создать платёжную сессию');
    }
});
//# sourceMappingURL=createCheckoutSession.js.map