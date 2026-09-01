import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Web client ID (oauth_client type 3 из google-services.json).
/// Нужен, чтобы Google Sign-In выдал idToken, который примет Firebase.
const String _kWebClientId =
    '406048199497-cnsnonu4e22n7uesgh5g14oc4o26i4c5.apps.googleusercontent.com';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  serverClientId: _kWebClientId,
  scopes: const ['email', 'profile'],
);

const MethodChannel _cryptoChannel = MethodChannel('dtd/firebase_auth_crypto');

/// Признак повреждённого keyset: Android Keystore на устройстве
/// инвалидировал мастер-ключ Tink, и браузерный flow не может стартовать.
bool _isBrokenKeysetError(Object error) {
  final text = error.toString();
  return text.contains('encryption key for Generic IDP') ||
      text.contains('Generic IDP');
}

Future<void> _resetGenericIdpKeyset() async {
  try {
    await _cryptoChannel.invokeMethod('resetGenericIdpKeyset');
  } catch (e) {
    print('resetGenericIdpKeyset failed: $e');
  }
}

Future<UserCredential?> _webFlowGoogleSignIn() {
  final googleProvider = GoogleAuthProvider()
    ..addScope('email')
    ..addScope('profile');
  return FirebaseAuth.instance.signInWithProvider(googleProvider);
}

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    final googleProvider = GoogleAuthProvider();
    return FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  // Основной путь: нативный Google Sign-In (нижняя шторка выбора аккаунта).
  Object? nativeError;
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    nativeError = e;
    print('google_sign_in native failed: $e');
  }

  // Запасной путь: браузерный flow. Перед ним чистим повреждённый
  // keyset Firebase, если ошибка указывает на Generic IDP / keystore.
  try {
    return await _webFlowGoogleSignIn();
  } catch (e) {
    if (_isBrokenKeysetError(e)) {
      print('Generic IDP keyset broken, resetting and retrying once');
      await _resetGenericIdpKeyset();
      try {
        return await _webFlowGoogleSignIn();
      } catch (retryError) {
        throw Exception(
          'Google: $retryError\nсброс ключей не помог; первичная ошибка: $nativeError',
        );
      }
    }
    // Иначе показываем обе ошибки — код нативного пути может объяснить всё.
    throw Exception(
      'Google fallback error: $e\nпервичная нативная ошибка: $nativeError',
    );
  }
}

Future signOutWithGoogle() async {
  // disconnect() отзывает доступы и сбрасывает выбранный аккаунт:
  // без него signIn() молча заходит в прежний аккаунт, не показывая выбор.
  try {
    await _googleSignIn.disconnect();
  } catch (_) {}
  try {
    await _googleSignIn.signOut();
  } catch (_) {}
  await FirebaseAuth.instance.signOut();
}
