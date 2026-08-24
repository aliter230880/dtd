/**
 * checkVerificationExpiry Cloud Function
 *
 * Scheduled Cloud Function that runs daily to check for expired carrier verifications.
 * Marks carriers as expired if verification is older than 365 days.
 *
 * Requirements covered: Carrier KYC verification expiry management
 */
import * as functions from 'firebase-functions';
/**
 * Check and update expired carrier verifications
 * Runs daily at 2:00 AM UTC
 *
 * Cron schedule: "0 2 * * *" (every day at 2:00 AM UTC)
 */
export declare const checkVerificationExpiry: functions.CloudFunction<unknown>;
