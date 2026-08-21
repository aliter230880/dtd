// import 'dart:convert';
// import 'dart:math';


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';


import 'package:auto_deal_admin/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_admin/backend/schema/enums/enums.dart';

bool hasAccess(AdminAccess access) {
  //if admin then has access
  if (currentUserDocument?.role == Role.superuser) return true;

  //if has All access, then has access
  if (currentUserDocument?.access.contains(AdminAccess.all) ?? false) return true;

  if (currentUserDocument?.access.contains(access) ?? false) return true;

  print('No access');
  return false;
}

// /// Generates a cryptographically secure random nonce, to be included in a
// /// credential request.
// String generateNonce([int length = 32]) {
//   const charset =
//       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//   final random = Random.secure();
//   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//       .join();
// }

// /// Returns the sha256 hash of [input] in hex notation.
// String sha256ofString(String input) {
//   final bytes = utf8.encode(input);
//   final digest = sha256.convert(bytes);
//   return digest.toString();
// }

// Future<UserCredential> appleSignIn() async {
//   if (kIsWeb) {
//     final provider = OAuthProvider("apple.com")
//       ..addScope('email')
//       ..addScope('name');

//     // Sign in the user with Firebase.
//     return await FirebaseAuth.instance.signInWithPopup(provider);
//   }
//   // To prevent replay attacks with the credential returned from Apple, we
//   // include a nonce in the credential request. When signing in in with
//   // Firebase, the nonce in the id token returned by Apple, is expected to
//   // match the sha256 hash of `rawNonce`.
//   final rawNonce = generateNonce();
//   final nonce = sha256ofString(rawNonce);

//   // Request credential for the currently signed in Apple account.
//   final appleCredential = await SignInWithApple.getAppleIDCredential(
//     scopes: [
//       AppleIDAuthorizationScopes.email,
//       AppleIDAuthorizationScopes.fullName,
//     ],
//     nonce: nonce,
//   );

//   // Create an `OAuthCredential` from the credential returned by Apple.
//   final oauthCredential = OAuthProvider("apple.com").credential(
//     idToken: appleCredential.identityToken,
//     rawNonce: rawNonce,
//   );

//   // Sign in the user with Firebase. If the nonce we generated earlier does
//   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
//   final user =
//       await FirebaseAuth.instance.signInWithCredential(oauthCredential);

//   final displayName = [appleCredential.givenName, appleCredential.familyName]
//       .where((name) => name != null)
//       .join(' ');

//   // The display name does not automatically come with the user.
//   if (displayName.isNotEmpty) {
//     await user.user?.updateDisplayName(displayName);
//   }

//   return user;
// }
