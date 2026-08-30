/**
 * DTD — Cloud Functions верификации документов (перенесено из «доработки 28,08»).
 *
 * ГЛАВНЫЙ ПРИНЦИП: флаг verified пишется ТОЛЬКО отсюда.
 * Клиент не может установить его сам — иначе бейдж «Проверен» подделывается
 * одним вызовом Firestore API.
 *
 * В firestore.rules поля верификации закрыты от клиентской записи:
 *   verification, balance, carrier_total_earning, free_response_count, type
 *
 * Ключ FMCSA берётся из конфига и НИКОГДА не уходит в клиент:
 *   firebase functions:config:set fmcsa.web_key="..."
 * Получить: https://mobile.fmcsa.dot.gov/QCDevsite/docs/apiAccess
 */
import * as functions from 'firebase-functions';
/**
 * Проверка USDOT перевозчика в реестре FMCSA.
 *
 * КРИТИЧНО: наличие записи ≠ право работать. Проверяется allowedToOperate.
 * Mock verifyCarrier пропускает любой DOT (включая 12345) —
 * именно это здесь и закрывается.
 */
export declare const verifyCarrierDot: functions.HttpsFunction & functions.Runnable<any>;
/** Контрольная цифра VIN, ISO 3779. Сверено с ответами vPIC. */
export declare function vinCheckDigitValid(vin: string): boolean;
/**
 * Декодирование VIN. vPIC открыт и CORS-friendly, поэтому клиент может
 * звать его напрямую. Серверная версия нужна там, где результат влияет
 * на данные сделки — клиенту верить нельзя.
 *
 * ЛОВУШКА (проверено вживую): для битого VIN vPIC всё равно возвращает
 * Make/Model. Решение принимается только по ErrorCode.
 */
export declare const decodeVin: functions.HttpsFunction & functions.Runnable<any>;
/**
 * Приём дилерской лицензии на модерацию.
 * Автоматически verified СТАТЬ НЕ МОЖЕТ: федерального реестра нет,
 * подтверждает человек. Возвращает needs_review — и это честно.
 */
export declare const submitDealerLicense: functions.HttpsFunction & functions.Runnable<any>;
export declare const reviewVerification: functions.HttpsFunction & functions.Runnable<any>;
/**
 * Проверки «гниют»: авторитет FMCSA отзывается, лицензии истекают.
 * Раз в сутки снимаем бейджи с истёкших.
 */
export declare const checkDotVerificationExpiry: functions.CloudFunction<unknown>;
