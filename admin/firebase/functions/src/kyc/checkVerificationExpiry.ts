/**
 * checkVerificationExpiry Cloud Function
 * 
 * Scheduled Cloud Function that runs daily to check for expired carrier verifications.
 * Marks carriers as expired if verification is older than 365 days.
 * 
 * Requirements covered: Carrier KYC verification expiry management
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Check and update expired carrier verifications
 * Runs daily at 2:00 AM UTC
 * 
 * Cron schedule: "0 2 * * *" (every day at 2:00 AM UTC)
 */
export const checkVerificationExpiry = functions.pubsub
  .schedule('0 2 * * *')
  .timeZone('UTC')
  .onRun(async (context) => {
    const firestore = admin.firestore();

    try {
      // Calculate the date 365 days ago
      const expiryDate = new Date();
      expiryDate.setDate(expiryDate.getDate() - 365);

      console.log(`Checking for verifications older than ${expiryDate.toISOString()}`);

      // Query for verified carriers with old verification dates
      const usersRef = firestore.collection('users');
      const snapshot = await usersRef
        .where('verified', '==', true)
        .where('type', '==', 'Carrier')
        .where('verificationExpired', '==', false)
        .get();

      if (snapshot.empty) {
        console.log('No verified carriers found for expiry check.');
        return null;
      }

      console.log(`Found ${snapshot.size} verified carriers to check.`);

      // Track expired carriers
      let expiredCount = 0;
      const batch = firestore.batch();

      // Check each carrier's verification date
      snapshot.forEach((doc) => {
        const userData = doc.data();
        const verificationDate = userData.verificationDate;

        // Skip if no verification date (shouldn't happen, but be safe)
        if (!verificationDate) {
          console.warn(`User ${doc.id} has verified=true but no verificationDate`);
          return;
        }

        // Convert Firestore Timestamp to Date
        const verificationDateObj = verificationDate.toDate();

        // Check if verification is expired (older than 365 days)
        if (verificationDateObj < expiryDate) {
          console.log(
            `Marking user ${doc.id} as expired. Verification date: ${verificationDateObj.toISOString()}`
          );

          // Mark as expired in batch
          batch.update(doc.ref, {
            verificationExpired: true,
            verificationExpiredAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          expiredCount++;
        }
      });

      // Commit batch update if there are expired verifications
      if (expiredCount > 0) {
        await batch.commit();
        console.log(`Successfully marked ${expiredCount} carrier(s) as expired.`);
      } else {
        console.log('No expired verifications found.');
      }

      return {
        success: true,
        checked: snapshot.size,
        expired: expiredCount,
      };
    } catch (error) {
      console.error('Error checking verification expiry:', error);
      throw error;
    }
  });
