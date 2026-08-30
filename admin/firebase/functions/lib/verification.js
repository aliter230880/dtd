"use strict";
/**
 * DTD — Cloud Functions верификации документов (перенесено из «доработки 28,08»).
 *
 * ГЛАВНЫЙ ПРИНЦИП: флаг verified пишется ТОЛЬКО отсюда.
 * Клиент не может установить его сам — иначе бейдж «Проверен» подделывается
 * одним вызовом Firestore API.
 *
 * В firestore.rules поля верификации закрыты от клиентской записи:
 *   verification, balance, carrier_total_earning, free_response_count, type
 *
 * Ключ FMCSA берётся из конфига и НИКОГДА не уходит в клиент:
 *   firebase functions:config:set fmcsa.web_key="..."
 * Получить: https://mobile.fmcsa.dot.gov/QCDevsite/docs/apiAccess
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkDotVerificationExpiry = exports.reviewVerification = exports.submitDealerLicense = exports.decodeVin = exports.vinCheckDigitValid = exports.verifyCarrierDot = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const axios_1 = __importDefault(require("axios"));
if (!admin.apps.length)
    admin.initializeApp();
const db = admin.firestore();
const FMCSA_TTL_DAYS = 30;
function ts(d) {
    return admin.firestore.Timestamp.fromDate(d);
}
function expiry(days) {
    return ts(new Date(Date.now() + days * 86400000));
}
/** Единая точка записи результата + аудит-лог. */
async function persist(uid, field, record) {
    const batch = db.batch();
    batch.set(db.collection('users').doc(uid), { verification: { [field]: record } }, { merge: true });
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
/**
 * Проверка USDOT перевозчика в реестре FMCSA.
 *
 * КРИТИЧНО: наличие записи ≠ право работать. Проверяется allowedToOperate.
 * Mock verifyCarrier пропускает любой DOT (включая 12345) —
 * именно это здесь и закрывается.
 */
exports.verifyCarrierDot = functions.https.onCall(async (data, context) => {
    var _a, _b, _c, _d, _e, _f, _g, _h, _j;
    const uid = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid;
    if (!uid) {
        throw new functions.https.HttpsError('unauthenticated', 'Требуется авторизация');
    }
    const dot = String((_b = data === null || data === void 0 ? void 0 : data.dotNumber) !== null && _b !== void 0 ? _b : '').trim();
    if (!/^[1-9]\d{0,7}$/.test(dot)) {
        throw new functions.https.HttpsError('invalid-argument', 'USDOT: от 1 до 8 цифр без ведущего нуля');
    }
    // Rate limit: не даём перебирать реестр через наш ключ.
    await assertRateLimit(uid, 'fmcsa', 20);
    const webKey = (_c = functions.config().fmcsa) === null || _c === void 0 ? void 0 : _c.web_key;
    if (!webKey) {
        // Честно сообщаем «недоступно», а не выдаём фальшивый verified.
        const rec = {
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
    const url = `https://mobile.fmcsa.dot.gov/qc/services/carriers/${dot}` +
        `?webKey=${encodeURIComponent(webKey)}`;
    let payload;
    try {
        const resp = await axios_1.default.get(url, { timeout: 12000 });
        payload = resp.data;
    }
    catch (err) {
        functions.logger.warn('FMCSA unreachable', { dot, err: String(err) });
        const rec = {
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
    const carrier = (_d = payload === null || payload === void 0 ? void 0 : payload.content) === null || _d === void 0 ? void 0 : _d.carrier;
    if (!carrier || !carrier.legalName) {
        const rec = {
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
        const rec = {
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
    const rec = {
        status: 'verified',
        tier: 'registry',
        source: 'fmcsa_qcmobile',
        checked_at: ts(new Date()),
        // Авторитет и рейтинг отзываются — проверка обязана истекать.
        expires_at: expiry(FMCSA_TTL_DAYS),
        value: dot,
        autofill: {
            legal_name: carrier.legalName,
            dba_name: (_e = carrier.dbaName) !== null && _e !== void 0 ? _e : '',
            address,
            safety_rating: (_f = carrier.safetyRating) !== null && _f !== void 0 ? _f : 'none',
            power_units: String((_g = carrier.totalPowerUnits) !== null && _g !== void 0 ? _g : ''),
            drivers: String((_h = carrier.totalDrivers) !== null && _h !== void 0 ? _h : ''),
        },
        raw: carrier,
    };
    await persist(uid, 'dot', rec);
    return {
        status: 'verified',
        carrier: rec.autofill,
        expiresAt: (_j = rec.expires_at) === null || _j === void 0 ? void 0 : _j.toDate().toISOString(),
    };
});
// ---------------------------------------------------------------------------
// 2. decodeVin — NHTSA vPIC
// ---------------------------------------------------------------------------
const VIN_TRANSLIT = {
    A: 1, B: 2, C: 3, D: 4, E: 5, F: 6, G: 7, H: 8,
    J: 1, K: 2, L: 3, M: 4, N: 5, P: 7, R: 9,
    S: 2, T: 3, U: 4, V: 5, W: 6, X: 7, Y: 8, Z: 9,
    '0': 0, '1': 1, '2': 2, '3': 3, '4': 4,
    '5': 5, '6': 6, '7': 7, '8': 8, '9': 9,
};
const VIN_WEIGHTS = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2];
/** Контрольная цифра VIN, ISO 3779. Сверено с ответами vPIC. */
function vinCheckDigitValid(vin) {
    if (!/^[A-HJ-NPR-Z0-9]{17}$/.test(vin))
        return false;
    let sum = 0;
    for (let i = 0; i < 17; i++)
        sum += VIN_TRANSLIT[vin[i]] * VIN_WEIGHTS[i];
    const r = sum % 11;
    return (r === 10 ? 'X' : String(r)) === vin[8];
}
exports.vinCheckDigitValid = vinCheckDigitValid;
/**
 * Декодирование VIN. vPIC открыт и CORS-friendly, поэтому клиент может
 * звать его напрямую. Серверная версия нужна там, где результат влияет
 * на данные сделки — клиенту верить нельзя.
 *
 * ЛОВУШКА (проверено вживую): для битого VIN vPIC всё равно возвращает
 * Make/Model. Решение принимается только по ErrorCode.
 */
exports.decodeVin = functions.https.onCall(async (data, context) => {
    var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o;
    const uid = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid;
    if (!uid) {
        throw new functions.https.HttpsError('unauthenticated', 'Требуется авторизация');
    }
    const vin = String((_b = data === null || data === void 0 ? void 0 : data.vin) !== null && _b !== void 0 ? _b : '').trim().toUpperCase();
    if (!vinCheckDigitValid(vin)) {
        throw new functions.https.HttpsError('invalid-argument', 'VIN не прошёл проверку контрольной цифры');
    }
    let r;
    try {
        const resp = await axios_1.default.get(`https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues/${vin}?format=json`, { timeout: 12000 });
        r = (_d = (_c = resp.data) === null || _c === void 0 ? void 0 : _c.Results) === null || _d === void 0 ? void 0 : _d[0];
    }
    catch (err) {
        functions.logger.warn('vPIC unreachable', { vin, err: String(err) });
        return { status: 'unavailable' };
    }
    const codes = String((_e = r === null || r === void 0 ? void 0 : r.ErrorCode) !== null && _e !== void 0 ? _e : '')
        .split(',')
        .map((c) => c.trim())
        .filter(Boolean);
    if (codes.includes('6') || codes.includes('11')) {
        return { status: 'not_found' };
    }
    if (codes.length && !codes.includes('0')) {
        return { status: 'mismatch', errorText: r === null || r === void 0 ? void 0 : r.ErrorText };
    }
    const vehicle = {
        make: (_f = r === null || r === void 0 ? void 0 : r.Make) !== null && _f !== void 0 ? _f : '',
        model: (_g = r === null || r === void 0 ? void 0 : r.Model) !== null && _g !== void 0 ? _g : '',
        year: (_h = r === null || r === void 0 ? void 0 : r.ModelYear) !== null && _h !== void 0 ? _h : '',
        body_class: (_j = r === null || r === void 0 ? void 0 : r.BodyClass) !== null && _j !== void 0 ? _j : '',
        vehicle_type: (_k = r === null || r === void 0 ? void 0 : r.VehicleType) !== null && _k !== void 0 ? _k : '',
        fuel: (_l = r === null || r === void 0 ? void 0 : r.FuelTypePrimary) !== null && _l !== void 0 ? _l : '',
        plant_country: (_m = r === null || r === void 0 ? void 0 : r.PlantCountry) !== null && _m !== void 0 ? _m : '',
        gvwr: (_o = r === null || r === void 0 ? void 0 : r.GVWR) !== null && _o !== void 0 ? _o : '',
    };
    // Если VIN привязан к сделке — пишем подтверждённые данные в неё,
    // чтобы дилер не мог указать «Porsche» для Honda Accord.
    if (data === null || data === void 0 ? void 0 : data.dealId) {
        await db.collection('deals').doc(String(data.dealId)).set({
            vin,
            vin_verified: true,
            vin_decoded: vehicle,
            vin_source: 'nhtsa_vpic',
            vin_checked_at: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
    }
    return { status: 'verified', vehicle };
});
// ---------------------------------------------------------------------------
// 3. submitDealerLicense — уровень 3, ручная модерация
// ---------------------------------------------------------------------------
/** Маски дилерских лицензий по штатам (дублируют клиентские). */
const DEALER_PATTERNS = {
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
exports.submitDealerLicense = functions.https.onCall(async (data, context) => {
    var _a, _b, _c;
    const uid = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid;
    if (!uid) {
        throw new functions.https.HttpsError('unauthenticated', 'Требуется авторизация');
    }
    const value = String((_b = data === null || data === void 0 ? void 0 : data.licenseNumber) !== null && _b !== void 0 ? _b : '').trim().toUpperCase();
    const state = String((_c = data === null || data === void 0 ? void 0 : data.state) !== null && _c !== void 0 ? _c : '').trim().toUpperCase();
    const pattern = DEALER_PATTERNS[state];
    if (pattern && !pattern.test(value)) {
        throw new functions.https.HttpsError('invalid-argument', `Номер не соответствует формату лицензий ${state}`);
    }
    if (!(data === null || data === void 0 ? void 0 : data.documentUrl)) {
        throw new functions.https.HttpsError('invalid-argument', 'Требуется скан документа: реестра для автопроверки не существует');
    }
    const rec = {
        status: 'needs_review',
        tier: 'manual',
        source: 'admin_queue',
        checked_at: ts(new Date()),
        expires_at: null,
        value: `${state}:${value}`,
        autofill: {},
    };
    await persist(uid, 'dealer_license', rec);
    // Очередь модерации для админ-панели.
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
});
// ---------------------------------------------------------------------------
// 4. reviewVerification — решение модератора (только админ)
// ---------------------------------------------------------------------------
exports.reviewVerification = functions.https.onCall(async (data, context) => {
    var _a, _b, _c, _d;
    if (((_b = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.token) === null || _b === void 0 ? void 0 : _b.admin) !== true) {
        throw new functions.https.HttpsError('permission-denied', 'Только администратор');
    }
    const queueId = String((_c = data === null || data === void 0 ? void 0 : data.queueId) !== null && _c !== void 0 ? _c : '');
    const snap = await db.collection('verification_queue').doc(queueId).get();
    if (!snap.exists) {
        throw new functions.https.HttpsError('not-found', 'Заявка не найдена');
    }
    const item = snap.data();
    const approve = (data === null || data === void 0 ? void 0 : data.approve) === true;
    await db.collection('users').doc(item.uid).set({
        verification: {
            [item.field]: {
                status: approve ? 'verified' : 'mismatch',
                tier: 'manual',
                source: 'admin',
                verified_by: context.auth.uid,
                rejection_reason: approve ? null : ((_d = data === null || data === void 0 ? void 0 : data.reason) !== null && _d !== void 0 ? _d : null),
                checked_at: admin.firestore.FieldValue.serverTimestamp(),
                // Ручная проверка тоже истекает — лицензии продлеваются ежегодно.
                expires_at: approve ? expiry(365) : null,
            },
        },
    }, { merge: true });
    await snap.ref.update({
        status: approve ? 'approved' : 'rejected',
        reviewed_by: context.auth.uid,
        reviewed_at: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { ok: true };
});
// ---------------------------------------------------------------------------
// 5. checkDotVerificationExpiry — nightly
//    (имя отличается от существующей kyc/checkVerificationExpiry,
//     чтобы не конфликтовать при экспорте)
// ---------------------------------------------------------------------------
/**
 * Проверки «гниют»: авторитет FMCSA отзывается, лицензии истекают.
 * Раз в сутки снимаем бейджи с истёкших.
 */
exports.checkDotVerificationExpiry = functions.pubsub
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
        batch.set(doc.ref, { verification: { dot: { status: 'expired', tier: 'registry' } } }, { merge: true });
    });
    await batch.commit();
    functions.logger.info(`Expired verifications: ${snap.size}`);
    return null;
});
// ---------------------------------------------------------------------------
// Rate limit
// ---------------------------------------------------------------------------
async function assertRateLimit(uid, key, perDay) {
    const id = `${uid}_${key}_${new Date().toISOString().slice(0, 10)}`;
    const ref = db.collection('rate_limits').doc(id);
    await db.runTransaction(async (tx) => {
        var _a, _b;
        const doc = await tx.get(ref);
        const count = ((_b = (_a = doc.data()) === null || _a === void 0 ? void 0 : _a.count) !== null && _b !== void 0 ? _b : 0);
        if (count >= perDay) {
            throw new functions.https.HttpsError('resource-exhausted', `Лимит проверок на сегодня исчерпан (${perDay})`);
        }
        tx.set(ref, { count: count + 1, updated_at: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
    });
}
//# sourceMappingURL=verification.js.map