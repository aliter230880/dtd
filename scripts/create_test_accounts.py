#!/usr/bin/env python3
"""Создание трёх тестовых аккаунтов — по одному на каждую роль.

Роли:
    1. Дилер                  (type=Diller)
    2. Перевозчик-компания    (type=Carrier, carrier_kind=company)
    3. Перевозчик-физлицо     (type=Carrier, carrier_kind=individual)

Физлицо НЕ является третьим значением UserType: в enums.dart объявлено
`enum UserType { Diller, Carrier }`. Физлицо остаётся Carrier по роли,
а `carrier_kind` задаёт путь верификации. Отсутствие carrier_kind
трактуется приложением как 'company' — миграция базы не требуется.

Имена полей взяты из app/lib/backend/schema/users_record.dart и совпадают
с фактической схемой Firestore (в частности, роль лежит в поле `type`,
а не `user_type`).

Запуск:
    pip install firebase-admin==7.1.0
    python3 scripts/create_test_accounts.py

Требуется ключ Admin SDK. Получить: Firebase Console → Project settings →
Service accounts → язык Python → Generate new private key.

Скрипт идемпотентен: повторный запуск не создаёт дубли, а обновляет
существующие профили.
"""

import os
import sys
from datetime import datetime, timezone

try:
    import firebase_admin
    from firebase_admin import auth, credentials, firestore
except ImportError:
    print("[!] Нет пакета firebase-admin.")
    print("    pip install firebase-admin==7.1.0")
    sys.exit(1)

# Пути, по которым ключ оказывается после загрузки через Firebase-вкладку.
CREDENTIAL_PATHS = (
    "/opt/flutter/firebase-admin-sdk.json",
    os.path.expanduser("~/firebase-admin-sdk.json"),
    "./firebase-admin-sdk.json",
)

PASSWORD = "TestPass123!"

# Номера намеренно синтаксически валидные, но заведомо не существующие в
# реестрах: аккаунты не должны проходить проверку FMCSA как настоящие.
# Верификация оставлена в 'idle' — бейдж выдаётся только уровнем registry.
ACCOUNTS = [
    {
        "email": "dealer.test@dtd-test.local",
        "display_name": "Тест Дилер",
        "phone_number": "+12025550101",
        "type": "Diller",
        "profile": {
            "diller_license": "DLR12345",
            "dealer_license_number": "DLR12345",
            "dealer_license_state": "CA",
            "diller_driver_license": "D1234567",
            "diller_cars": [],
        },
    },
    {
        "email": "carrier.company.test@dtd-test.local",
        "display_name": "Тест Перевозчик Компания",
        "phone_number": "+12025550102",
        "type": "Carrier",
        "profile": {
            "carrier_kind": "company",
            "carrier_company_name": "Test Carrier LLC",
            "company_legal_name": "TEST CARRIER LLC",
            "carrier_number": "1234567",
            "dot_number": "1234567",
            "carrier_driver_license": "C7654321",
        },
    },
    {
        "email": "carrier.individual.test@dtd-test.local",
        "display_name": "Тест Перевозчик Физлицо",
        "phone_number": "+12025550103",
        "type": "Carrier",
        "profile": {
            # У физлица нет DOT — вместо реестра проверяются права и личность
            # (уровень provider), поэтому dot_number/company_legal_name пусты.
            "carrier_kind": "individual",
            "carrier_driver_license": "I9876543",
            "carrier_company_name": "",
        },
    },
]


def find_credentials():
    for path in CREDENTIAL_PATHS:
        if os.path.isfile(path):
            return path
    return None


def init_firebase():
    path = find_credentials()
    if not path:
        print("[!] Не найден ключ Firebase Admin SDK. Искал:")
        for candidate in CREDENTIAL_PATHS:
            print(f"      {candidate}")
        print("\n    Firebase Console → Project settings → Service accounts")
        print("    → язык Python → Generate new private key")
        sys.exit(1)

    print(f"[i] Ключ: {path}")
    firebase_admin.initialize_app(credentials.Certificate(path))
    return firestore.client()


def ensure_auth_user(spec):
    """Возвращает uid, создавая пользователя при необходимости."""
    try:
        user = auth.get_user_by_email(spec["email"])
        print(f"[=] Уже существует в Auth: {spec['email']}")
        # Пароль сбрасываем, чтобы он был предсказуемым при повторном запуске.
        auth.update_user(
            user.uid,
            password=PASSWORD,
            display_name=spec["display_name"],
        )
        return user.uid
    except auth.UserNotFoundError:
        user = auth.create_user(
            email=spec["email"],
            password=PASSWORD,
            display_name=spec["display_name"],
            email_verified=True,
        )
        print(f"[+] Создан в Auth: {spec['email']}")
        return user.uid


def write_profile(db, uid, spec):
    now = datetime.now(timezone.utc)

    data = {
        "email": spec["email"],
        "display_name": spec["display_name"],
        "uid": uid,
        "phone_number": spec["phone_number"],
        "type": spec["type"],
        "created_time": now,
        "profile_filled": True,
        "balance": 0.0,
        "rate": 0.0,
        "rate_count": 0,
        "banned": False,
        # Верификация НЕ выставляется в True: бейдж должен появляться только
        # после реальной проверки в реестре, иначе тестовые аккаунты создадут
        # ложное представление о работе модели доверия.
        "verified": False,
        "verification_status": "idle",
        "verification_expired": False,
        "free_deal_count": 3,
        "free_response_count": 3,
        "carrier_total_earning": 0.0,
    }
    data.update(spec["profile"])

    db.collection("users").document(uid).set(data, merge=True)
    print(f"[+] Профиль записан: {spec['display_name']}")


def main():
    db = init_firebase()

    print("\n=== Создание тестовых аккаунтов ===\n")
    created = []
    for spec in ACCOUNTS:
        uid = ensure_auth_user(spec)
        write_profile(db, uid, spec)
        created.append((spec, uid))
        print()

    print("=== Готово. Данные для входа ===\n")
    for spec, uid in created:
        kind = spec["profile"].get("carrier_kind")
        role = spec["type"] + (f" / {kind}" if kind else "")
        print(f"  {role}")
        print(f"    email:    {spec['email']}")
        print(f"    password: {PASSWORD}")
        print(f"    uid:      {uid}")
        print()

    print("Аккаунты созданы неверифицированными (verification_status=idle).")
    print("Это намеренно: бейдж должен выдаваться только уровнем registry.")


if __name__ == "__main__":
    main()
