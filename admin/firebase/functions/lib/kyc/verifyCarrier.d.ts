/**
 * verifyCarrier Cloud Function
 *
 * Callable Cloud Function that verifies carriers using DOT/MC numbers.
 * Updates UsersRecord with FMCSA data upon successful verification.
 *
 * Requirements covered: Carrier KYC verification
 */
import * as functions from 'firebase-functions';
/**
 * Verify carrier using DOT/MC number
 *
 * @param data Request data containing dotNumber or mcNumber and userId
 * @param context Call context with authentication info
 * @returns Verification result with FMCSA data or error
 */
export declare const verifyCarrier: functions.HttpsFunction & functions.Runnable<any>;
