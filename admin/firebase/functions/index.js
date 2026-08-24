const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("admins/" + user.uid);
});

// Insurance Cloud Functions
const { calculateInsuranceQuote } = require("./lib/insurance/calculateQuote");
exports.calculateInsuranceQuote = calculateInsuranceQuote;

// KYC Cloud Functions
const { verifyCarrier } = require("./lib/kyc/verifyCarrier");
const { checkVerificationExpiry } = require("./lib/kyc/checkVerificationExpiry");
exports.verifyCarrier = verifyCarrier;
exports.checkVerificationExpiry = checkVerificationExpiry;

// Payments (Stripe Checkout): начисление баланса делает только вебхук
const { createCheckoutSession } = require("./lib/payments/createCheckoutSession");
const { stripeWebhook } = require("./lib/payments/stripeWebhook");
exports.createCheckoutSession = createCheckoutSession;
exports.stripeWebhook = stripeWebhook;
