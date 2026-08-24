"use strict";
/**
 * Пакеты пополнения кошелька.
 *
 * Цены задаются только здесь, на сервере. Клиент передаёт лишь количество
 * кредитов, а сумма к оплате считается по этой таблице — присланной клиентом
 * цене доверять нельзя.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.sanitizeMethodTypes = exports.findPackage = exports.ALLOWED_METHOD_TYPES = exports.CUSTOM_MAX_CREDITS = exports.CUSTOM_MIN_CREDITS = exports.TOP_UP_PACKAGES = void 0;
exports.TOP_UP_PACKAGES = [
    { credits: 50, amountCents: 5000, currency: 'usd' },
    { credits: 100, amountCents: 10000, currency: 'usd' },
    { credits: 500, amountCents: 50000, currency: 'usd' },
];
/** Границы произвольной суммы: 1 кредит = $1. */
exports.CUSTOM_MIN_CREDITS = 50;
exports.CUSTOM_MAX_CREDITS = 10000;
/** Способы оплаты, разрешённые к передаче в Stripe Checkout. */
exports.ALLOWED_METHOD_TYPES = [
    'card',
    'sepa_debit',
    'klarna',
];
/**
 * Возвращает пакет по количеству кредитов: сначала ищет среди готовых,
 * затем принимает произвольную сумму в допустимых границах.
 *
 * Сумма к оплате всегда считается здесь, а не берётся из запроса.
 */
function findPackage(credits) {
    if (typeof credits !== 'number' || !Number.isInteger(credits)) {
        return undefined;
    }
    const preset = exports.TOP_UP_PACKAGES.find((p) => p.credits === credits);
    if (preset)
        return preset;
    if (credits < exports.CUSTOM_MIN_CREDITS || credits > exports.CUSTOM_MAX_CREDITS) {
        return undefined;
    }
    return { credits, amountCents: credits * 100, currency: 'usd' };
}
exports.findPackage = findPackage;
function sanitizeMethodTypes(methodTypes) {
    if (!Array.isArray(methodTypes))
        return ['card'];
    const filtered = methodTypes.filter((type) => typeof type === 'string' && exports.ALLOWED_METHOD_TYPES.includes(type));
    return filtered.length > 0 ? filtered : ['card'];
}
exports.sanitizeMethodTypes = sanitizeMethodTypes;
//# sourceMappingURL=packages.js.map