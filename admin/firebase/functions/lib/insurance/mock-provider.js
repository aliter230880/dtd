"use strict";
/**
 * Mock Insurance Provider
 *
 * Simple test implementation of InsuranceProvider for MVP development and testing.
 * Provides instant quotes and policy generation without external API dependencies.
 *
 * Formula: baseCost = $0.02/mile × distance + 0.5% of vehicle value
 * Quote validity: 24 hours
 *
 * Requirements covered: 2.2 (MVP testing), 3.2 (provider interface)
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockInsuranceProvider = void 0;
const provider_interface_1 = require("./provider-interface");
class MockInsuranceProvider {
    constructor() {
        this.quotes = new Map();
    }
    /**
     * Calculate insurance quote using simple formula
     *
     * @param params Quote parameters including VIN, locations, and vehicle value
     * @returns Quote with cost and 24-hour expiration
     */
    async getQuote(params) {
        var _a;
        // Add realistic delay (1-2 seconds)
        await this.delay(1000 + Math.random() * 1000);
        // Validate parameters
        this.validateQuoteParams(params);
        // Calculate distance if not provided
        const distance = (_a = params.distance) !== null && _a !== void 0 ? _a : this.calculateDistance(params.pickupLocation, params.deliveryLocation);
        // Formula: $0.02 per mile + 0.5% of vehicle value
        const distanceCost = distance * 0.02; // $0.02 per mile
        const valueCost = params.vehicleValue * 0.005; // 0.5% of vehicle value
        const totalCostDollars = distanceCost + valueCost;
        // Convert to cents (integer to avoid floating point issues)
        const quoteCost = Math.round(totalCostDollars * 100);
        // Generate quote ID and expiration (24 hours)
        const quoteId = this.generateQuoteId();
        const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours
        // Store quote for later validation during purchase
        this.quotes.set(quoteId, {
            quoteId,
            quoteCost,
            expiresAt,
            params,
        });
        return {
            quoteId,
            quoteCost,
            expiresAt,
            provider: this.getName(),
            metadata: {
                distance,
                distanceCost: Math.round(distanceCost * 100),
                valueCost: Math.round(valueCost * 100),
                formula: 'baseCost = $0.02/mile × distance + 0.5% × vehicleValue',
            },
        };
    }
    /**
     * Purchase insurance policy using a quote
     *
     * @param params Purchase parameters including quote ID
     * @returns Policy with mock policy ID and document URL
     */
    async purchasePolicy(params) {
        // Add realistic delay (1-2 seconds)
        await this.delay(1000 + Math.random() * 1000);
        // Retrieve stored quote
        const storedQuote = this.quotes.get(params.quoteId);
        if (!storedQuote) {
            throw new provider_interface_1.InsurancePurchaseError('Quote not found. Please request a new quote.', 'expired_quote');
        }
        // Check if quote has expired
        if (new Date() > storedQuote.expiresAt) {
            this.quotes.delete(params.quoteId);
            throw new provider_interface_1.InsurancePurchaseError('Quote has expired. Please request a new quote.', 'expired_quote');
        }
        // Generate mock policy ID
        const policyId = this.generatePolicyId();
        // Generate mock document URL (in production, this would be a real PDF)
        const documentUrl = `https://mock-insurance.example.com/policies/${policyId}.pdf`;
        // Calculate policy dates (effective immediately, valid for 30 days)
        const effectiveDate = new Date();
        const expirationDate = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 days
        // Clean up used quote
        this.quotes.delete(params.quoteId);
        return {
            policyId,
            provider: this.getName(),
            documentUrl,
            effectiveDate,
            expirationDate,
            coverageAmount: storedQuote.params.vehicleValue,
            metadata: {
                dealId: params.dealId,
                quoteId: params.quoteId,
                quoteCost: storedQuote.quoteCost,
                vehicleInfo: params.vehicleInfo,
                routeInfo: params.routeInfo,
            },
        };
    }
    /**
     * Get provider name
     *
     * @returns Provider name for display and logging
     */
    getName() {
        return 'Mock Insurance Co.';
    }
    /**
     * Validate quote parameters
     *
     * @param params Quote parameters to validate
     * @throws InsuranceQuoteError if validation fails
     */
    validateQuoteParams(params) {
        if (!params.vin || params.vin.length !== 17) {
            throw new provider_interface_1.InsuranceQuoteError('Invalid VIN. Must be 17 alphanumeric characters.', 'validation', { vin: params.vin });
        }
        if (params.vehicleValue <= 0) {
            throw new provider_interface_1.InsuranceQuoteError('Vehicle value must be greater than zero.', 'validation', { vehicleValue: params.vehicleValue });
        }
        if (!params.pickupLocation || !params.deliveryLocation) {
            throw new provider_interface_1.InsuranceQuoteError('Both pickup and delivery locations are required.', 'validation');
        }
    }
    /**
     * Calculate distance between two locations using Haversine formula
     *
     * @param from Starting location
     * @param to Ending location
     * @returns Distance in miles
     */
    calculateDistance(from, to) {
        const R = 3959; // Earth's radius in miles
        const dLat = this.toRadians(to.latitude - from.latitude);
        const dLon = this.toRadians(to.longitude - from.longitude);
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(this.toRadians(from.latitude)) *
                Math.cos(this.toRadians(to.latitude)) *
                Math.sin(dLon / 2) *
                Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        const distance = R * c;
        return Math.round(distance * 10) / 10; // Round to 1 decimal place
    }
    /**
     * Convert degrees to radians
     */
    toRadians(degrees) {
        return degrees * (Math.PI / 180);
    }
    /**
     * Generate unique quote ID
     */
    generateQuoteId() {
        return `MOCK-QTE-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    }
    /**
     * Generate unique policy ID
     */
    generatePolicyId() {
        return `MOCK-POL-${Date.now()}`;
    }
    /**
     * Add realistic delay to simulate API call
     */
    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}
exports.MockInsuranceProvider = MockInsuranceProvider;
//# sourceMappingURL=mock-provider.js.map