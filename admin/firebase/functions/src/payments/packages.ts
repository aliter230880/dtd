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

export const TOP_UP_PACKAGES: readonly TopUpPackage[] = [
  { credits: 50, amountCents: 5000, currency: 'usd' },
  { credits: 100, amountCents: 10000, currency: 'usd' },
  { credits: 500, amountCents: 50000, currency: 'usd' },
];

/** Способы оплаты, разрешённые к передаче в Stripe Checkout. */
export const ALLOWED_METHOD_TYPES: readonly string[] = [
  'card',
  'sepa_debit',
  'klarna',
];

export function findPackage(credits: unknown): TopUpPackage | undefined {
  if (typeof credits !== 'number' || !Number.isInteger(credits)) {
    return undefined;
  }
  return TOP_UP_PACKAGES.find((p) => p.credits === credits);
}

export function sanitizeMethodTypes(methodTypes: unknown): string[] {
  if (!Array.isArray(methodTypes)) return ['card'];
  const filtered = methodTypes.filter(
    (type): type is string =>
      typeof type === 'string' && ALLOWED_METHOD_TYPES.includes(type)
  );
  return filtered.length > 0 ? filtered : ['card'];
}
