# Carrier Verification Cloud Functions

This document describes the KYC (Know Your Customer) Cloud Functions for carrier verification using FMCSA DOT/MC numbers.

## Functions Overview

### 1. `verifyCarrier` - Carrier Verification Function

**Type:** Callable Cloud Function (HTTPS)

**Purpose:** Verify carrier credentials using DOT or MC numbers and update user records with FMCSA data.

**Input:**
```typescript
{
  dotNumber?: string;    // DOT number (e.g., "12345")
  mcNumber?: string;     // MC number (e.g., "111111")
  userId: string;        // User ID to verify
}
```

**Output:**
```typescript
{
  success: boolean;
  data?: FmcsaResult;    // FMCSA verification data if success
  error?: string;        // Error message if failed
}
```

**Authentication:** Required. Users can only verify their own accounts unless they have admin privileges.

**Validation:**
- Either `dotNumber` or `mcNumber` must be provided
- `userId` is required and must be a valid user ID
- User must be of type "Carrier"
- User must be authenticated

**Behavior:**
1. Authenticates the requesting user
2. Validates input parameters
3. Checks that user is a Carrier
4. Calls `MockFmcsaProvider.verifyDOT()` or `verifyMC()`
5. If successful, updates user record with:
   - `verified: true`
   - `verificationDate: serverTimestamp`
   - `verificationExpired: false`
   - `company_legal_name`: Company name from FMCSA
   - `safety_rating`: Safety rating (Satisfactory/Conditional/Unsatisfactory)
   - `authority_status`: Authority status (Active/Inactive)
   - `fmcsa_address`: Company address
   - `dot_number` and/or `mc_number`: Numbers used for verification
   - `verification_metadata`: Additional metadata from provider

**Error Handling:**
- `unauthenticated`: User must be authenticated
- `invalid-argument`: Missing or invalid parameters
- `permission-denied`: User trying to verify another user's account
- `not-found`: User ID not found
- `failed-precondition`: User is not a Carrier
- `internal`: Unexpected errors

**Example Usage (from client):**
```javascript
const functions = firebase.functions();
const verifyCarrier = functions.httpsCallable('verifyCarrier');

try {
  const result = await verifyCarrier({
    dotNumber: '12345',
    userId: currentUser.uid
  });
  
  if (result.data.success) {
    console.log('Verification successful:', result.data.data);
  } else {
    console.error('Verification failed:', result.data.error);
  }
} catch (error) {
  console.error('Error calling function:', error);
}
```

---

### 2. `checkVerificationExpiry` - Scheduled Expiry Check

**Type:** Scheduled Cloud Function (Pub/Sub)

**Purpose:** Automatically check for expired carrier verifications (older than 365 days) and mark them as expired.

**Schedule:** Runs daily at 2:00 AM UTC (`0 2 * * *`)

**Behavior:**
1. Calculates date 365 days ago
2. Queries for verified Carriers where:
   - `verified == true`
   - `type == 'Carrier'`
   - `verificationExpired == false`
3. For each carrier, checks if `verificationDate` is older than 365 days
4. Marks expired carriers with:
   - `verificationExpired: true`
   - `verificationExpiredAt: serverTimestamp`
5. Logs summary of checked and expired carriers

**Output (logged):**
```typescript
{
  success: true,
  checked: number,    // Total carriers checked
  expired: number     // Carriers marked as expired
}
```

**Firestore Indexes Required:**
```
Collection: users
Fields:
  - verified (Ascending)
  - type (Ascending)
  - verificationExpired (Ascending)
```

**Monitoring:**
- Check Cloud Functions logs for daily execution
- Monitor for errors in the execution
- Review the count of expired verifications

---

## Firestore Schema Changes

### `users` Collection - New Fields

```typescript
interface UsersRecord {
  // ... existing fields ...
  
  // KYC Verification fields
  verified?: boolean;                    // True if carrier is verified
  verificationDate?: Timestamp;          // Date of verification
  verificationExpired?: boolean;         // True if verification expired (365+ days)
  verificationExpiredAt?: Timestamp;     // Date when verification was marked expired
  
  // FMCSA Data
  dot_number?: string;                   // DOT number used for verification
  mc_number?: string;                    // MC number used for verification
  company_legal_name?: string;           // Legal company name from FMCSA
  safety_rating?: SafetyRating;          // Satisfactory | Conditional | Unsatisfactory
  authority_status?: AuthorityStatus;    // Active | Inactive
  fmcsa_address?: string;                // Company address from FMCSA
  verification_metadata?: object;        // Additional data from provider
}
```

---

## Testing

### Unit Tests

Run tests with:
```bash
cd admin/firebase/functions
npm test
```

Test files:
- `src/kyc/verifyCarrier.test.ts` - Tests for verification logic
- `src/kyc/mock-fmcsa-provider.test.ts` - Tests for FMCSA provider

### Mock Data

The `MockFmcsaProvider` includes three test carriers:

1. **DOT 12345 / MC 111111** - Test Trucking LLC
   - Safety Rating: Satisfactory
   - Authority Status: Active
   - Address: Chicago, IL

2. **DOT 67890 / MC 222222** - Fast Freight Inc
   - Safety Rating: Conditional
   - Authority Status: Active
   - Address: Dallas, TX

3. **DOT 99999 / MC 333333** - Old Transport Co
   - Safety Rating: Unsatisfactory
   - Authority Status: Inactive
   - Address: Detroit, MI

---

## Deployment

Deploy functions to Firebase:

```bash
cd admin/firebase/functions
npm run compile  # or: npx tsc
cd ..
firebase deploy --only functions:verifyCarrier,functions:checkVerificationExpiry
```

Deploy all functions:
```bash
firebase deploy --only functions
```

---

## Security Considerations

1. **Authentication Required**: Only authenticated users can call `verifyCarrier`
2. **Authorization**: Users can only verify their own accounts (unless admin)
3. **Type Check**: Only Carrier users can be verified with DOT/MC numbers
4. **Rate Limiting**: Consider adding rate limits to prevent abuse
5. **Admin Access**: Admins can verify any user's account (for manual review/support)

---

## Future Improvements

1. **Real FMCSA Integration**: Replace `MockFmcsaProvider` with real FMCSA SAFER API
2. **Rate Limiting**: Add Cloud Functions rate limiting to prevent abuse
3. **Notification**: Send notification to user when verification expires
4. **Re-verification Flow**: Allow users to re-verify after expiry
5. **Admin Dashboard**: Add admin interface to manually verify/unverify carriers
6. **Audit Log**: Track all verification attempts and changes
7. **Background Verification**: Automatically verify on signup if DOT/MC provided
8. **Verification Badge**: Display badge in UI for verified carriers

---

## Related Files

- `src/kyc/fmcsa-interface.ts` - FMCSA provider interface and types
- `src/kyc/mock-fmcsa-provider.ts` - Mock implementation for testing
- `src/kyc/verifyCarrier.ts` - Verification Cloud Function
- `src/kyc/checkVerificationExpiry.ts` - Scheduled expiry check
- `src/kyc/verifyCarrier.test.ts` - Unit tests
- `index.js` - Function exports

---

## Support

For questions or issues, refer to:
- [FMCSA SAFER System](https://safer.fmcsa.dot.gov/)
- [Firebase Cloud Functions Documentation](https://firebase.google.com/docs/functions)
- Project documentation in `docs/ARCHITECTURE.md`
