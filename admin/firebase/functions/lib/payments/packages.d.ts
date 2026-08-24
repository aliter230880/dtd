/**
 * Пакеты пополнения кошелька.
 *
 * Цены задаются только здесь, на сервере. Клиент передаёт лишь количество
 * кредитов, а сумма к оплате считается по этой таблице — присланной клиентом
 * цене доверять нельзя.
 */
export interface TopUpPackage {
    credits: number;
    /** Цена в центах (Stripe принимает минимальные единицы валюты). */
    amountCents: number;
    currency: 'usd';
}
export declare const TOP_UP_PACKAGES: readonly TopUpPackage[];
/** Границы произвольной суммы: 1 кредит = $1. */
export declare const CUSTOM_MIN_CREDITS = 50;
export declare const CUSTOM_MAX_CREDITS = 10000;
/** Способы оплаты, разрешённые к передаче в Stripe Checkout. */
export declare const ALLOWED_METHOD_TYPES: readonly string[];
/**
 * Возвращает пакет по количеству кредитов: сначала ищет среди готовых,
 * затем принимает произвольную сумму в допустимых границах.
 *
 * Сумма к оплате всегда считается здесь, а не берётся из запроса.
 */
export declare function findPackage(credits: unknown): TopUpPackage | undefined;
export declare function sanitizeMethodTypes(methodTypes: unknown): string[];
