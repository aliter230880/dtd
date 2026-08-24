"use strict";
/**
 * Insurance Provider Interface - Type Tests
 *
 * This file contains compile-time type tests to ensure the interfaces
 * are correctly defined and can be implemented.
 *
 * Note: These are TypeScript type tests, not runtime tests.
 * They verify the interface contracts at compile time.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.testProviderPolymorphism = exports.testPolicy = exports.testQuote = exports.testLocation = exports.testErrors = exports.TestMockProvider = void 0;
const provider_interface_1 = require("./provider-interface");
/**
 * Mock implementation for compile-time verification
 */
class TestMockProvider {
    async getQuote(params) {
        // Verify QuoteParams structure
        const _vin = params.vin;
        const _pickup = params.pickupLocation;
        const _delivery = params.deliveryLocation;
        const _value = params.vehicleValue;
        const _distance = params.distance;
        // Return valid Quote
        return {
            quoteCost: 5000,
            expiresAt: new Date(),
            provider: 'Test Provider'
        };
    }
    async purchasePolicy(params) {
        // Verify PurchaseParams structure
        const _quoteId = params.quoteId;
        const _dealId = params.dealId;
        const _payment = params.paymentToken;
        const _vehicle = params.vehicleInfo;
        const _route = params.routeInfo;
        // Return valid Policy
        return {
            policyId: 'TEST-123',
            provider: 'Test Provider',
            documentUrl: 'https://example.com/policy.pdf'
        };
    }
    getName() {
        return 'Test Mock Provider';
    }
}
exports.TestMockProvider = TestMockProvider;
/**
 * Test error types
 */
function testErrors() {
    // InsuranceQuoteError
    const quoteError = new provider_interface_1.InsuranceQuoteError('Quote failed', 'validation', { field: 'vin' });
    const _message = quoteError.message;
    const _code = quoteError.code;
    const _details = quoteError.details;
    // InsurancePurchaseError
    const purchaseError = new provider_interface_1.InsurancePurchaseError('Purchase failed', 'expired_quote');
    const _purchaseCode = purchaseError.code;
}
exports.testErrors = testErrors;
/**
 * Test Location interface
 */
function testLocation() {
    const location = {
        latitude: 34.0522,
        longitude: -118.2437,
        address: 'Los Angeles, CA'
    };
    const _lat = location.latitude;
    const _lng = location.longitude;
    const _addr = location.address;
}
exports.testLocation = testLocation;
/**
 * Test Quote interface with all optional fields
 */
function testQuote() {
    const fullQuote = {
        quoteId: 'Q123',
        quoteCost: 5000,
        expiresAt: new Date(),
        provider: 'Test Provider',
        metadata: { distance: 100 }
    };
    const minimalQuote = {
        quoteCost: 5000,
        expiresAt: new Date(),
        provider: 'Test Provider'
    };
}
exports.testQuote = testQuote;
/**
 * Test Policy interface with all optional fields
 */
function testPolicy() {
    const fullPolicy = {
        policyId: 'P123',
        provider: 'Test Provider',
        documentUrl: 'https://example.com/policy.pdf',
        effectiveDate: new Date(),
        expirationDate: new Date(),
        coverageAmount: 50000,
        metadata: { claim_phone: '1-800-123-4567' }
    };
    const minimalPolicy = {
        policyId: 'P123',
        provider: 'Test Provider',
        documentUrl: 'https://example.com/policy.pdf'
    };
}
exports.testPolicy = testPolicy;
/**
 * Verify the provider can be used polymorphically
 */
async function testProviderPolymorphism() {
    const provider = new TestMockProvider();
    const quoteParams = {
        vin: 'ABC12345678901234',
        pickupLocation: { latitude: 34.0522, longitude: -118.2437 },
        deliveryLocation: { latitude: 40.7128, longitude: -74.0060 },
        vehicleValue: 25000
    };
    const quote = await provider.getQuote(quoteParams);
    const purchaseParams = {
        quoteId: quote.quoteId || 'default',
        dealId: 'deal123'
    };
    const policy = await provider.purchasePolicy(purchaseParams);
    console.log(`Provider: ${provider.getName()}`);
    console.log(`Policy: ${policy.policyId}`);
}
exports.testProviderPolymorphism = testProviderPolymorphism;
//# sourceMappingURL=provider-interface.test.js.map