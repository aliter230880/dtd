/**
 * calculateInsuranceQuote Cloud Function
 *
 * Callable Cloud Function that calculates insurance quotes for deals.
 * Retrieves deal data from Firestore and uses MockInsuranceProvider for MVP.
 *
 * Requirements covered: 3.3 (calculateInsuranceQuote Cloud Function)
 */
import * as functions from 'firebase-functions';
/**
 * Calculate insurance quote for a deal
 *
 * @param data Request data containing dealId
 * @param context Call context with authentication info
 * @returns Quote with cost, expiration, and provider info
 */
export declare const calculateInsuranceQuote: functions.HttpsFunction & functions.Runnable<any>;
