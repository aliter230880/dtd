import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';

/// Показывает реальную причину сбоя авторизации вместо общего «Произошла ошибка».
///
/// Код Firebase (`ERROR_WEB_CONTEXT_CANCELED`, `account-exists-with-different-credential`
/// и прочие) нужен для диагностики соцвхода: без него отличить отмену пользователем
/// от неверной конфигурации провайдера по экрану невозможно.
void showAuthError(BuildContext context, Object error, String provider) {
  final text = _describe(error);
  log('$provider login error: $error');

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '$provider: $text',
        style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
      ),
      duration: const Duration(seconds: 10),
      backgroundColor: FlutterFlowTheme.of(context).secondary,
    ),
  );
}

String _describe(Object error) {
  if (error is FirebaseAuthException) {
    final human = switch (error.code) {
      'email-already-in-use' => 'этот email уже занят другим аккаунтом',
      'INVALID_LOGIN_CREDENTIALS' || 'invalid-credential' => 'неверный email или пароль',
      'user-not-found' => 'аккаунт с таким email не найден',
      'wrong-password' => 'неверный пароль',
      'weak-password' => 'пароль слишком простой (минимум 6 символов)',
      'web-context-canceled' => 'вход отменён',
      'account-exists-with-different-credential' =>
        'этот email уже привязан к другому способу входа',
      'network-request-failed' => 'нет связи с сервером',
      _ => error.message ?? '',
    };
    return human.isEmpty ? error.code : '$human [${error.code}]';
  }
  return error.toString();
}
