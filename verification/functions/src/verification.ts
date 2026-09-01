/**
 * DTD — Cloud Functions верификации документов.
 *
 * ГЛАВНЫЙ ПРИНЦИП: флаг verified пишется ТОЛЬКО отсюда.
 * Клиент не может установить его сам — иначе бейдж «Проверен» подделывается
 * одним вызовом Firestore API, ровно как сейчас подделывается
 * carrier_total_earning из deal_detail_carrier_widget.dart.
 *
 * Соответственно в firestore.rules поля верификации должны быть закрыты:
 *
 *   match /users/{uid} {
 *     allow update: if request.auth.uid == uid
 *       && !request.resource.data.diff(resource.data).affectedKeys()
 *            .hasAny(['verification', 'balance', 'carrier_total_earning',
 *                     'free_response_count', 'type']);
 *   }
 *
 * Ключ FMCSA берётся из конфига и НИКОГДА не уходит в клиент:
 *   firebase functions:config:set fmcsa.web_key="..."
 * Получить: https://mobile.fmcsa.dot.gov/QCDevsite/docs/apiAccess
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

// ---------------------------------------------------------------------------
// Типы
// ---------------------------------------------------------------------------

type Tier = 'format' | 'registry' | 'manual';
type Status =
  | 'verified'
  | 'mismatch'
  | 'not_found'
  | 'unavailable'
  | 'needs_review';

interface VerificationRecord {
  status: Status;
  tier: Tier;
  source: string;
  checked_at: admin.firestore.Timestamp;
  expires_at: admin.firestore.Timestamp | null;
  value: string;
  autofill: Record<string, string>;
  raw?: unknown;
}

const FMCSA_TTL_DAYS = 30;

function ts(d: Date) {
  return admin.firestore.Timestamp.fromDate(d);
}

function expiry(days: number) {
  return ts(new Date(Date.now() + days * 86400_000));
}

/** Единая точка записи результата + аудит-лог. */
async function persist(
  uid: string,
  field: string,
  record: VerificationRecord,
): Promise<void> {
  const batch = db.batch();

  batch.set(
    db.collection('users').doc(uid),
    { verification: { [field]: record } },
    { merge: true },
  );

  // Аудит: неизменяемый след каждой проверки. Нужен для разбора споров
  // и для доказательства, что бейдж выдан не произвольно.
  batch.set(db.collection('audit_logs').doc(), {
    type: 'verification',
    uid,
    field,
    status: record.status,
    source: record.source,
    value: record.value,
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  await batch.commit();
}

// ---------------------------------------------------------------------------
// 1. verifyCarrierDot — FMCSA QCMobile
// ---------------------------------------------------------------------------

interface FmcsaCarrier {
  legalName?: string;
  dbaName?: string;
  phyStreet?: string;
  phyCity?: string;
  phyState?: string;
  phyZipcode?: string;
  safetyRating?: string | null;
  allowedToOperate?: string; // 'Y' | 'N'
  totalPowerUnits?: number;
  totalDrivers?: number;
  statusCode?: string;
}

/**
 * Проверка USDOT перевозчика в реестре FMCSA.
 *
 * КРИТИЧНО: наличие записи ≠ право работать. Проверяется allowedToOperate.
 * Текущий mock verifyCarrier в проекте пропускает любой DOT (включая 12345) —
 * именно это здесь и закрывается.
 */
export const verifyCarrierDot = functions.https.onCall(
  async (data: { dotNumber?: string }, context) => {
    const uid = context.auth?.uid;
    if (!uid) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Требуется авторизация',
      );
    }

    const dot = String(data?.dotNumber ?? '').trim();
    if (!/^[1-9]\d{0,7}$/.test(dot)) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'USDOT: от 1 до 8 цифр без ведущего нуля',
      );
    }

    // Rate limit: не даём перебирать реестр через наш ключ.
    await assertRateLimit(uid, 'fmcsa', 20);

    const webKey = functions.config().fmcsa?.web_key;
    if (!webKey) {
      // Честно сообщаем «недоступно», а не выдаём фальшивый verified.
      const rec: VerificationRecord = {
        status: 'unavailable',
        tier: 'registry',
        source: 'fmcsa_qcmobile',
        checked_at: ts(new Date()),
        expires_at: null,
        value: dot,
        autofill: {},
      };
      await persist(uid, 'dot', rec);
      return { status: 'unavailable', reason: 'FMCSA web key not configured' };
    }

    const url =
      `https://mobile.fmcsa.dot.gov/qc/services/carriers/${dot}` +
      `?webKey=${encodeURIComponent(webKey)}`;

    let payload: any;
    try {
      const resp = await fetch(url, {
        signal: AbortSignal.timeout(12_000),
      });
      if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
      payload = await resp.json();
    } catch (err) {
      functions.logger.warn('FMCSA unreachable', { dot, err: String(err) });
      const rec: VerificationRecord = {
        status: 'unavailable',
        tier: 'registry',
        source: 'fmcsa_qcmobile',
        checked_at: ts(new Date()),
        expires_at: null,
        value: dot,
        autofill: {},
      };
      await persist(uid, 'dot', rec);
      return { status: 'unavailable' };
    }

    const carrier: FmcsaCarrier | undefined = payload?.content?.carrier;
    if (!carrier || !carrier.legalName) {
      const rec: VerificationRecord = {
        status: 'not_found',
        tier: 'registry',
        source: 'fmcsa_qcmobile',
        checked_at: ts(new Date()),
        expires_at: null,
        value: dot,
        autofill: {},
      };
      await persist(uid, 'dot', rec);
      return { status: 'not_found' };
    }

    const allowed = carrier.allowedToOperate === 'Y';
    const address = [
      carrier.phyStreet,
      carrier.phyCity,
      carrier.phyState,
      carrier.phyZipcode,
    ]
      .filter(Boolean)
      .join(', ');

    if (!allowed) {
      const rec: VerificationRecord = {
        status: 'mismatch',
        tier: 'registry',
        source: 'fmcsa_qcmobile',
        checked_at: ts(new Date()),
        expires_at: null,
        value: dot,
        autofill: { legal_name: carrier.legalName },
        raw: carrier,
      };
      await persist(uid, 'dot', rec);
      return {
        status: 'mismatch',
        reason: 'allowedToOperate = N',
        legalName: carrier.legalName,
      };
    }

    const rec: VerificationRecord = {
      status: 'verified',
      tier: 'registry',
      source: 'fmcsa_qcmobile',
      checked_at: ts(new Date()),
      // Авторитет и рейтинг отзываются — проверка обязана истекать.
      expires_at: expiry(FMCSA_TTL_DAYS),
      value: dot,
      autofill: {
        legal_name: carrier.legalName,
        dba_name: carrier.dbaName ?? '',
        address,
        safety_rating: carrier.safetyRating ?? 'none',
        power_units: String(carrier.totalPowerUnits ?? ''),
        drivers: String(carrier.totalDrivers ?? ''),
      },
      raw: carrier,
    };
    await persist(uid, 'dot', rec);

    return {
      status: 'verified',
      carrier: rec.autofill,
      expiresAt: rec.expires_at?.toDate().toISOString(),
    };
  },
);

// ---------------------------------------------------------------------------
// 2. decodeVin — NHTSA vPIC
// ---------------------------------------------------------------------------

const VIN_TRANSLIT: Record<string, number> = {
  A: 1, B: 2, C: 3, D: 4, E: 5, F: 6, G: 7, H: 8,
  J: 1, K: 2, L: 3, M: 4, N: 5, P: 7, R: 9,
  S: 2, T: 3, U: 4, V: 5, W: 6, X: 7, Y: 8, Z: 9,
  '0': 0, '1': 1, '2': 2, '3': 3, '4': 4,
  '5': 5, '6': 6, '7': 7, '8': 8, '9': 9,
};
const VIN_WEIGHTS = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2];

/** Контрольная цифра VIN, ISO 3779. Сверено с ответами vPIC. */
export function vinCheckDigitValid(vin: string): boolean {
  if (!/^[A-HJ-NPR-Z0-9]{17}$/.test(vin)) return false;
  let sum = 0;
  for (let i = 0; i < 17; i++) sum += VIN_TRANSLIT[vin[i]] * VIN_WEIGHTS[i];
  const r = sum % 11;
  return (r === 10 ? 'X' : String(r)) === vin[8];
}

/**
 * Декодирование VIN. vPIC открыт и CORS-friendly, поэтому клиент может
 * звать его напрямую. Серверная версия нужна там, где результат влияет
 * на данные сделки — клиенту верить нельзя.
 *
 * ЛОВУШКА (проверено вживую): для битого VIN vPIC всё равно возвращает
 * Make/Model. Решение принимается только по ErrorCode.
 */
export const decodeVin = functions.https.onCall(
  async (data: { vin?: string; dealId?: string }, context) => {
    const uid = context.auth?.uid;
    if (!uid) {
      throw new functions.https.HttpsError('unauthenticated', 'Требуется авторизация');
    }

    const vin = String(data?.vin ?? '').trim().toUpperCase();
    if (!vinCheckDigitValid(vin)) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'VIN не прошёл проверку контрольной цифры',
      );
    }

    let r: any;
    try {
      const resp = await fetch(
        `https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues/${vin}?format=json`,
        { signal: AbortSignal.timeout(12_000) },
      );
      if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
      r = (await resp.json())?.Results?.[0];
    } catch (err) {
      functions.logger.warn('vPIC unreachable', { vin, err: String(err) });
      return { status: 'unavailable' };
    }

    const codes = String(r?.ErrorCode ?? '')
      .split(',')
      .map((c: string) => c.trim())
      .filter(Boolean);

    if (codes.includes('6') || codes.includes('11')) {
      return { status: 'not_found' };
    }
    if (codes.length && !codes.includes('0')) {
      return { status: 'mismatch', errorText: r?.ErrorText };
    }

    const vehicle = {
      make: r?.Make ?? '',
      model: r?.Model ?? '',
      year: r?.ModelYear ?? '',
      body_class: r?.BodyClass ?? '',
      vehicle_type: r?.VehicleType ?? '',
      fuel: r?.FuelTypePrimary ?? '',
      plant_country: r?.PlantCountry ?? '',
      gvwr: r?.GVWR ?? '',
    };

    // Если VIN привязан к сделке — пишем подтверждённые данные в неё,
    // чтобы дилер не мог указать «Porsche» для Honda Accord.
    if (data?.dealId) {
      await db.collection('deals').doc(String(data.dealId)).set(
        {
          vin,
          vin_verified: true,
          vin_decoded: vehicle,
          vin_source: 'nhtsa_vpic',
          vin_checked_at: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true },
      );
    }

    return { status: 'verified', vehicle };
  },
);

// ---------------------------------------------------------------------------
// 3. submitDealerLicense — уровень 3, ручная модерация
// ---------------------------------------------------------------------------

/** Маски дилерских лицензий по штатам (дублируют клиентские). */
const DEALER_PATTERNS: Record<string, RegExp> = {
  CA: /^\d{5,8}$/,
  TX: /^P?\d{5,7}$/,
  FL: /^(VI|VF|VD|DA)\d{6,8}$/,
  NY: /^\d{7}$/,
  NJ: /^[A-Z]\d{5,6}$/,
  PA: /^[A-Z]{2}\d{5,6}$/,
  IL: /^\d{6,8}$/,
  OH: /^[A-Z]{2}\d{6}$/,
  GA: /^[A-Z]\d{6,7}$/,
  AZ: /^[A-Z]\d{5,7}$/,
};

/**
 * Приём дилерской лицензии на модерацию.
 * Автоматически verified СТАТЬ НЕ МОЖЕТ: федерального реестра нет,
 * подтверждает человек. Возвращает needs_review — и это честно.
 */
export const submitDealerLicense = functions.https.onCall(
  async (
    data: { licenseNumber?: string; state?: string; documentUrl?: string },
    context,
  ) => {
    const uid = context.auth?.uid;
    if (!uid) {
      throw new functions.https.HttpsError('unauthenticated', 'Требуется авторизация');
    }

    const value = String(data?.licenseNumber ?? '').trim().toUpperCase();
    const state = String(data?.state ?? '').trim().toUpperCase();
    const pattern = DEALER_PATTERNS[state];

    if (pattern && !pattern.test(value)) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `Номер не соответствует формату лицензий ${state}`,
      );
    }
    if (!data?.documentUrl) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Требуется скан документа: реестра для автопроверки не существует',
      );
    }

    const rec: VerificationRecord = {
      status: 'needs_review',
      tier: 'manual',
      source: 'admin_queue',
      checked_at: ts(new Date()),
      expires_at: null,
      value: `${state}:${value}`,
      autofill: {},
    };
    await persist(uid, 'dealer_license', rec);

    // Очередь модерации. Интерфейса под неё в admin/lib сейчас нет —
    // это и есть основной объём работ, а не интеграции с API.
    await db.collection('verification_queue').add({
      uid,
      field: 'dealer_license',
      state,
      value,
      document_url: data.documentUrl,
      status: 'pending',
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { status: 'needs_review' };
  },
);

// ---------------------------------------------------------------------------
// 4. reviewVerification — решение модератора (только админ)
// ---------------------------------------------------------------------------

export const reviewVerification = functions.https.onCall(
  async (
    data: { queueId?: string; approve?: boolean; reason?: string },
    context,
  ) => {
    if (context.auth?.token?.admin !== true) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Только администратор',
      );
    }
    const queueId = String(data?.queueId ?? '');
    const snap = await db.collection('verification_queue').doc(queueId).get();
    if (!snap.exists) {
      throw new functions.https.HttpsError('not-found', 'Заявка не найдена');
    }

    const item = snap.data()!;
    const approve = data?.approve === true;

    await db.collection('users').doc(item.uid).set(
      {
        verification: {
          [item.field]: {
            status: approve ? 'verified' : 'mismatch',
            tier: 'manual',
            source: 'admin',
            verified_by: context.auth!.uid,
            rejection_reason: approve ? null : (data?.reason ?? null),
            checked_at: admin.firestore.FieldValue.serverTimestamp(),
            // Ручная проверка тоже истекает — лицензии продлеваются ежегодно.
            expires_at: approve ? expiry(365) : null,
          },
        },
      },
      { merge: true },
    );

    await snap.ref.update({
      status: approve ? 'approved' : 'rejected',
      reviewed_by: context.auth!.uid,
      reviewed_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { ok: true };
  },
);

// ---------------------------------------------------------------------------
// 5. checkVerificationExpiry — nightly
// ---------------------------------------------------------------------------

/**
 * Проверки «гниют»: авторитет FMCSA отзывается, лицензии истекают.
 * Раз в сутки снимаем бейджи с истёкших.
 */
export const checkVerificationExpiry = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now();
    const snap = await db
      .collection('users')
      .where('verification.dot.expires_at', '<=', now)
      .limit(400)
      .get();

    const batch = db.batch();
    snap.docs.forEach((doc) => {
      batch.set(
        doc.ref,
        { verification: { dot: { status: 'expired', tier: 'registry' } } },
        { merge: true },
      );
    });
    await batch.commit();

    functions.logger.info(`Expired verifications: ${snap.size}`);
    return null;
  });

// ---------------------------------------------------------------------------
// Rate limit
// ---------------------------------------------------------------------------

async function assertRateLimit(uid: string, key: string, perDay: number) {
  const id = `${uid}_${key}_${new Date().toISOString().slice(0, 10)}`;
  const ref = db.collection('rate_limits').doc(id);

  await db.runTransaction(async (tx) => {
    const doc = await tx.get(ref);
    const count = (doc.data()?.count ?? 0) as number;
    if (count >= perDay) {
      throw new functions.https.HttpsError(
        'resource-exhausted',
        `Лимит проверок на сегодня исчерпан (${perDay})`,
      );
    }
    tx.set(
      ref,
      { count: count + 1, updated_at: admin.firestore.FieldValue.serverTimestamp() },
      { merge: true },
    );
  });
}
