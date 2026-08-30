import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Web client ID (oauth_client type 3 из google-services.json).
/// Нужен, чтобы Google Sign-In выдал idToken, который примет Firebase.
const String _kWebClientId =
    '380857780783-0hqq30ag4fdirstq0qcmtf6qa7vbft4m.apps.googleusercontent.com';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  serverClientId: _kWebClientId,
  scopes: const ['email', 'profile'],
);

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    final googleProvider = GoogleAuthProvider();
    return FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  // Основной путь: нативный Google Sign-In (нижняя шторка выбора аккаунта,
  // без браузера и редиректа — не зависит от GenericIdpActivity/Custom Tab).
  try {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // Пользователь закрыл выбор аккаунта
      return null;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('google_sign_in native failed, falling back to web flow: $e');
  }

  // Запасной путь: браузерный flow через /__/auth/handler.
  final googleProvider = GoogleAuthProvider()
    ..addScope('email')
    ..addScope('profile');
  return FirebaseAuth.instance.signInWithProvider(googleProvider);
}

Future signOutWithGoogle() async {
  try {
    await _googleSignIn.signOut();
  } catch (_) {}
  await FirebaseAuth.instance.signOut();
}
