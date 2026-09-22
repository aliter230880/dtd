import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Автоначисление внутренней валюты (пункт ТЗ «Настройки» / ДОП-1).
///
/// Поля в документе config/configs:
///   auto_accrual_enabled  (bool)   — выключатель;
///   auto_accrual_amount   (num)    — сколько валюты начислять;
///   auto_accrual_period_days (num) — раз в сколько дней начислять.
///
/// У пользователя хранится users.last_accrual_at — время последнего
/// начисления. Начисление ленивое: проверка при каждом входе в аккаунт.
void initAutoAccrual() {
  FirebaseAuth.instance.userChanges().listen((user) {
    if (user != null) {
      // fire-and-forget: не блокируем запуск приложения
      _maybeAccrue(user.uid);
    }
  });
}

Future<void> _maybeAccrue(String uid) async {
  try {
    final fs = FirebaseFirestore.instance;
    final userRef = fs.collection('users').doc(uid);
    final configSnap = await fs.collection('config').doc('configs').get();
    final config = (configSnap.data() as Map<String, dynamic>?) ?? {};
    if (config['auto_accrual_enabled'] != true) return;

    final amount = (config['auto_accrual_amount'] as num?)?.toDouble() ?? 0;
    if (amount <= 0) return;

    final periodDays =
        (config['auto_accrual_period_days'] as num?)?.toInt() ?? 7;
    if (periodDays <= 0) return;

    final userSnap = await userRef.get();
    final data = userSnap.data();
    if (data == null) return;

    final last = data['last_accrual_at'] as DateTime?;
    final now = DateTime.now();
    if (last != null && now.difference(last).inDays < periodDays) return;

    final balance = (data['balance'] as num?)?.toDouble() ?? 0.0;
    await userRef.update({
      'balance': balance + amount,
      'last_accrual_at': now,
    });
  } catch (e) {
    // ignore: avoid_print
    print('auto accrual skipped: $e');
  }
}
