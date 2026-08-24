"use strict";
/**
 * calculateInsuranceQuote Cloud Function
 *
 * Callable Cloud Function that calculates insurance quotes for deals.
 * Retrieves deal data from Firestore and uses MockInsuranceProvider for MVP.
 *
 * Requirements covered: 3.3 (calculateInsuranceQuote Cloud Function)
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateInsuranceQuote = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const mock_provider_1 = require("./mock-provider");
const provider_interface_1 = require("./provider-interface");
/**
 * Calculate insurance quote for a deal
 *
 * @param data Request data containing dealId
 * @param context Call context with authentication info
 * @returns Quote with cost, expiration, and provider info
 */
exports.calculateInsuranceQuote = functions.https.onCall(async (data, context) => {
    // Authenticate user
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated to calculate insurance quotes.');
    }
    // Validate input
    if (!data.dealId || typeof data.dealId !== 'string') {
        throw new functions.https.HttpsError('invalid-argument', 'dealId is required and must be a string.');
    }
    try {
        // Get deal data from Firestore
        const firestore = admin.firestore();
        const dealRef = firestore.collection('deals').doc(data.dealId);
        const dealDoc = await dealRef.get();
        if (!dealDoc.exists) {
            throw new functions.https.HttpsError('not-found', `Deal with ID ${data.dealId} not found.`);
        }
        const dealData = dealDoc.data();
        // Extract and validate required fields
        const vin = dealData.car_name;
        const vehicleValue = dealData.price;
        if (!vin) {
            throw new functions.https.HttpsError('failed-precondition', 'Deal is missing car_name (used as VIN for MVP).');
        }
        if (!vehicleValue || vehicleValue <= 0) {
            throw new functions.https.HttpsError('failed-precondition', 'Deal is missing valid price (vehicle value).');
        }
        // Extract pickup location
        const pickupLat = dealData.pickup_lat;
        const pickupLng = dealData.pickup_lng;
        if (pickupLat === undefined || pickupLng === undefined) {
            throw new functions.https.HttpsError('failed-precondition', 'Deal is missing pickup location coordinates (pickup_lat, pickup_lng).');
        }
        // Extract delivery location
        const deliveryLat = dealData.delivery_lat;
        const deliveryLng = dealData.delivery_lng;
        if (deliveryLat === undefined || deliveryLng === undefined) {
            throw new functions.https.HttpsError('failed-precondition', 'Deal is missing delivery location coordinates (delivery_lat, delivery_lng).');
        }
        // Call MockInsuranceProvider to get quote
        const provider = new mock_provider_1.MockInsuranceProvider();
        const quote = await provider.getQuote({
            vin: vin,
            vehicleValue: vehicleValue,
            pickupLocation: {
                latitude: pickupLat,
                longitude: pickupLng,
                address: dealData.pickup_location,
            },
            deliveryLocation: {
                latitude: deliveryLat,
                longitude: deliveryLng,
                address: dealData.delivery_location,
            },
        });
        // Return formatted response
        return {
            quoteId: quote.quoteId,
            quoteCost: quote.quoteCost,
            expiresAt: quote.expiresAt.toISOString(),
            provider: quote.provider,
        };
    }
    catch (error) {
        // Handle InsuranceQuoteError
        if (error instanceof provider_interface_1.InsuranceQuoteError) {
            throw new functions.https.HttpsError('invalid-argument', error.message, { code: error.code, details: error.details });
        }
        // Handle Firebase HttpsError (re-throw as-is)
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        // Handle unexpected errors
        console.error('Unexpected error in calculateInsuranceQuote:', error);
        throw new functions.https.HttpsError('internal', 'An unexpected error occurred while calculating the insurance quote.', { error: error instanceof Error ? error.message : String(error) });
    }
});
//# sourceMappingURL=calculateQuote.js.map