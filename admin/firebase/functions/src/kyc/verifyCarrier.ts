/**
 * verifyCarrier Cloud Function
 * 
 * Callable Cloud Function that verifies carriers using DOT/MC numbers.
 * Updates UsersRecord with FMCSA data upon successful verification.
 * 
 * Requirements covered: Carrier KYC verification
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { MockFmcsaProvider } from './mock-fmcsa-provider';
import { FmcsaResult } from './fmcsa-interface';

/**
 * Request data structure
 */
interface VerifyCarrierRequest {
  dotNumber?: string;
  mcNumber?: string;
  userId: string;
}

/**
 * Response data structure
 */
interface VerifyCarrierResponse {
  success: boolean;
  data?: FmcsaResult;
  error?: string;
}

/**
 * Verify carrier using DOT/MC number
 * 
 * @param data Request data containing dotNumber or mcNumber and userId
 * @param context Call context with authentication info
 * @returns Verification result with FMCSA data or error
 */
export const verifyCarrier = functions.https.onCall(
  async (data: VerifyCarrierRequest, context: functions.https.CallableContext): Promise<VerifyCarrierResponse> => {
    // Authenticate user
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated to verify carrier.'
      );
    }

    // Validate input - must have either dotNumber or mcNumber
    if ((!data.dotNumber && !data.mcNumber) || !data.userId) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Either dotNumber or mcNumber is required, along with userId.'
      );
    }

    // Validate userId format
    if (typeof data.userId !== 'string' || !data.userId.trim()) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'userId must be a non-empty string.'
      );
    }

    // Validate that the user is verifying their own account or is an admin
    const isAdmin = context.auth.token.admin === true;
    if (!isAdmin && context.auth.uid !== data.userId) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Users can only verify their own accounts.'
      );
    }

    try {
      // Get user data from Firestore
      const firestore = admin.firestore();
      const userRef = firestore.collection('users').doc(data.userId);
      const userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw new functions.https.HttpsError(
          'not-found',
          `User with ID ${data.userId} not found.`
        );
      }

      const userData = userDoc.data();

      // Check if user is a Carrier
      if (userData?.type !== 'Carrier') {
        throw new functions.https.HttpsError(
          'failed-precondition',
          'Only Carrier users can be verified with DOT/MC numbers.'
        );
      }

      // Call MockFmcsaProvider to verify carrier
      const provider = new MockFmcsaProvider();
      let result: FmcsaResult;

      if (data.dotNumber) {
        result = await provider.verifyDOT(data.dotNumber);
      } else {
        result = await provider.verifyMC(data.mcNumber!);
      }

      // If verification failed, return error
      if (!result.success) {
        return {
          success: false,
          error: result.error || 'Verification failed.',
        };
      }

      // Update user record with FMCSA data
      const updateData: any = {
        verified: true,
        verificationDate: admin.firestore.FieldValue.serverTimestamp(),
        verificationExpired: false,
      };

      // Add FMCSA data if available
      if (result.companyLegalName) {
        updateData.company_legal_name = result.companyLegalName;
      }
      if (result.safetyRating) {
        updateData.safety_rating = result.safetyRating;
      }
      if (result.authorityStatus) {
        updateData.authority_status = result.authorityStatus;
      }
      if (result.address) {
        updateData.fmcsa_address = result.address;
      }

      // Store DOT/MC numbers used for verification
      if (data.dotNumber) {
        updateData.dot_number = data.dotNumber;
      }
      if (data.mcNumber) {
        updateData.mc_number = data.mcNumber;
      }

      // Add metadata if available
      if (result.metadata) {
        updateData.verification_metadata = result.metadata;
      }

      await userRef.update(updateData);

      // Return success response with FMCSA data
      return {
        success: true,
        data: result,
      };
    } catch (error) {
      // Handle Firebase HttpsError (re-throw as-is)
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }

      // Handle unexpected errors
      console.error('Unexpected error in verifyCarrier:', error);
      throw new functions.https.HttpsError(
        'internal',
        'An unexpected error occurred while verifying the carrier.',
        { error: error instanceof Error ? error.message : String(error) }
      );
    }
  }
);
