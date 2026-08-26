import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn();

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  try {
    await signOutWithGoogle().catchError((_) => null);
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User cancelled
    }
    final auth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken, accessToken: auth.accessToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Google sign-in error: $e');
    rethrow;
  }
}

Future signOutWithGoogle() => _googleSignIn.signOut();
