# Firestore Security Rules - KYC Fields

These rules should be added to `admin/firebase/firestore.rules` to secure the new KYC verification fields.

---

## New Fields in `users` Collection

```
verified: boolean
verificationDate: timestamp
verificationExpired: boolean
verificationExpiredAt: timestamp
dot_number: string
mc_number: string
company_legal_name: string
safety_rating: string
authority_status: string
fmcsa_address: string
verification_metadata: map
```

---

## Recommended Rules

Add to the `users` collection rules in `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is owner or admin
    function isOwnerOrAdmin(userId) {
      return request.auth != null && 
             (request.auth.uid == userId || 
              get(/databases/$(database)/documents/admins/$(request.auth.uid)).data.admin == true);
    }
    
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
             get(/databases/$(database)/documents/admins/$(request.auth.uid)).data.admin == true;
    }
    
    match /users/{userId} {
      // Allow read for authenticated users (for displaying verified badges, etc.)
      allow read: if request.auth != null;
      
      // Allow create for new users
      allow create: if request.auth != null && request.auth.uid == userId;
      
      // Allow update for user's own document
      allow update: if isOwnerOrAdmin(userId) && validateUserUpdate();
      
      // Validate user update - prevent users from setting verification fields directly
      function validateUserUpdate() {
        // Get the fields that are being changed
        let changedKeys = request.resource.data.diff(resource.data).affectedKeys();
        
        // KYC verification fields that only Cloud Functions can modify
        let kycFields = ['verified', 'verificationDate', 'verificationExpired', 
                        'verificationExpiredAt', 'company_legal_name', 
                        'safety_rating', 'authority_status', 'fmcsa_address',
                        'verification_metadata'].toSet();
        
        // Check if any KYC fields are being modified
        let modifyingKycFields = changedKeys.hasAny(kycFields);
        
        // If modifying KYC fields, must be from Cloud Functions (not from client)
        // Cloud Functions have special admin privileges
        return !modifyingKycFields || isAdmin();
      }
      
      // Alternatively, simpler rule that blocks KYC field updates from clients
      // Uncomment this and remove validateUserUpdate() if you prefer simpler approach:
      /*
      allow update: if request.auth != null && 
                      request.auth.uid == userId &&
                      !request.resource.data.diff(resource.data).affectedKeys()
                        .hasAny(['verified', 'verificationDate', 'verificationExpired',
                                'verificationExpiredAt', 'company_legal_name',
                                'safety_rating', 'authority_status', 'fmcsa_address',
                                'verification_metadata'].toSet());
      */
    }
  }
}
```

---

## Rule Explanation

### Read Access
```javascript
allow read: if request.auth != null;
```
- Any authenticated user can read user profiles
- This allows showing "Verified" badges in UI
- Public safety ratings visible to all users

### Write Protection
```javascript
function validateUserUpdate() {
  let kycFields = ['verified', 'verificationDate', ...].toSet();
  let modifyingKycFields = changedKeys.hasAny(kycFields);
  return !modifyingKycFields || isAdmin();
}
```
- Users **cannot** directly modify KYC verification fields
- Only Cloud Functions (with admin privileges) can update these fields
- Prevents users from faking verification status

### Why This Matters
Without these rules, a malicious user could:
1. Open browser console
2. Call `firestore.collection('users').doc(uid).update({ verified: true })`
3. Bypass verification process

With these rules:
- Only the `verifyCarrier` Cloud Function can set `verified: true`
- Users can update other fields (name, photo, etc.) but not verification
- Admins retain ability to manually fix data if needed

---

## Testing Rules

### Test in Firebase Console

1. Go to Firestore > Rules
2. Paste the rules
3. Click "Test Rules" simulator

### Test Cases

#### ✅ Should ALLOW: Read verified status
```javascript
// Authenticated user reading another user's profile
get(/databases/$(database)/documents/users/USER_B_ID)
Auth: USER_A_ID
Expected: ALLOW
```

#### ✅ Should ALLOW: User updating own profile (non-KYC fields)
```javascript
// User updating their own display name
update(/databases/$(database)/documents/users/USER_A_ID, {
  display_name: "New Name"
})
Auth: USER_A_ID
Expected: ALLOW
```

#### ❌ Should DENY: User setting verified=true directly
```javascript
// User trying to fake verification
update(/databases/$(database)/documents/users/USER_A_ID, {
  verified: true
})
Auth: USER_A_ID
Expected: DENY
```

#### ❌ Should DENY: User setting company_legal_name directly
```javascript
// User trying to set company name without verification
update(/databases/$(database)/documents/users/USER_A_ID, {
  company_legal_name: "Fake Trucking LLC"
})
Auth: USER_A_ID
Expected: DENY
```

#### ✅ Cloud Function updates (via admin SDK) always succeed
```javascript
// verifyCarrier function updating verification status
// Uses admin SDK with elevated privileges - no rules apply
```

---

## Deployment

### 1. Update firestore.rules file
```bash
cd E:\AI\AI_folder\dtd\admin\firebase
# Edit firestore.rules to add the new rules
```

### 2. Test rules in Firebase Console
- Go to Firebase Console > Firestore > Rules
- Use "Test Rules" simulator

### 3. Deploy rules
```bash
firebase deploy --only firestore:rules
```

### 4. Verify in production
```javascript
// Try to update verified field from Flutter app
// Should fail with permission-denied error
await FirebaseFirestore.instance
  .collection('users')
  .doc(currentUser.uid)
  .update({'verified': true});
// Expected: FirebaseException: permission-denied
```

---

## Alternative: Simpler Rules

If the complex validation is causing issues, use this simpler approach:

```javascript
match /users/{userId} {
  allow read: if request.auth != null;
  
  allow create: if request.auth != null && request.auth.uid == userId;
  
  // Simple rule: Allow updates except for KYC fields
  allow update: if request.auth != null && 
                  request.auth.uid == userId &&
                  !('verified' in request.resource.data.diff(resource.data).addedKeys()) &&
                  !('verified' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('verificationDate' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('verificationExpired' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('verificationExpiredAt' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('company_legal_name' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('safety_rating' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('authority_status' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('fmcsa_address' in request.resource.data.diff(resource.data).changedKeys()) &&
                  !('verification_metadata' in request.resource.data.diff(resource.data).changedKeys());
}
```

---

## Important Notes

1. **Cloud Functions bypass rules**: The `verifyCarrier` function uses Admin SDK, which has full access regardless of rules
2. **Admin users**: Create admin users in `admins` collection for manual overrides
3. **Testing**: Always test rules in simulator before deploying
4. **Monitoring**: Watch for permission-denied errors in Firebase Console
5. **Documentation**: Update security rules docs when adding new fields

---

## Additional Security Recommendations

### 1. Rate Limiting
Add to Cloud Functions:
```typescript
// In verifyCarrier function
// Check if user already verified recently
const lastVerification = userData.verificationDate;
if (lastVerification) {
  const hoursSinceVerification = 
    (Date.now() - lastVerification.toMillis()) / (1000 * 60 * 60);
  
  if (hoursSinceVerification < 24) {
    throw new functions.https.HttpsError(
      'resource-exhausted',
      'You can only verify once per 24 hours.'
    );
  }
}
```

### 2. Audit Logging
Log all verification attempts:
```typescript
await firestore.collection('verification_audit').add({
  userId: data.userId,
  dotNumber: data.dotNumber,
  mcNumber: data.mcNumber,
  success: result.success,
  timestamp: admin.firestore.FieldValue.serverTimestamp(),
  requestedBy: context.auth.uid,
});
```

### 3. Admin Notifications
Send alert when high-value carrier verifies:
```typescript
if (result.success && result.safetyRating === 'Satisfactory') {
  // Send notification to admin
  await sendAdminNotification({
    type: 'new_verification',
    carrier: result.companyLegalName,
    userId: data.userId,
  });
}
```

---

## Support

For questions about Firestore security rules:
- [Firebase Security Rules Documentation](https://firebase.google.com/docs/firestore/security/get-started)
- [Rules Playground](https://firebase.google.com/docs/rules/simulator)
- Project docs in `docs/ARCHITECTURE.md`
