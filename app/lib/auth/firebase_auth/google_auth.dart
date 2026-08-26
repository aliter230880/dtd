import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  // Mobile: use signInWithProvider (opens browser, no google_sign_in dependency)
  GoogleAuthProvider googleProvider = GoogleAuthProvider();
  googleProvider.addScope('email');
  googleProvider.addScope('profile');
  
  try {
    return await FirebaseAuth.instance.signInWithProvider(googleProvider);
  } catch (e) {
    print('Google sign-in error: $e');
    rethrow;
  }
}

Future signOutWithGoogle() async {
  // No google_sign_in to sign out from, just Firebase
  await FirebaseAuth.instance.signOut();
}
