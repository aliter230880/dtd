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
import { InsuranceProvider, QuoteParams, Quote, PurchaseParams, Policy } from './provider-interface';
export declare class MockInsuranceProvider implements InsuranceProvider {
    private quotes;
    /**
     * Calculate insurance quote using simple formula
     *
     * @param params Quote parameters including VIN, locations, and vehicle value
     * @returns Quote with cost and 24-hour expiration
     */
    getQuote(params: QuoteParams): Promise<Quote>;
    /**
     * Purchase insurance policy using a quote
     *
     * @param params Purchase parameters including quote ID
     * @returns Policy with mock policy ID and document URL
     */
    purchasePolicy(params: PurchaseParams): Promise<Policy>;
    /**
     * Get provider name
     *
     * @returns Provider name for display and logging
     */
    getName(): string;
    /**
     * Validate quote parameters
     *
     * @param params Quote parameters to validate
     * @throws InsuranceQuoteError if validation fails
     */
    private validateQuoteParams;
    /**
     * Calculate distance between two locations using Haversine formula
     *
     * @param from Starting location
     * @param to Ending location
     * @returns Distance in miles
     */
    private calculateDistance;
    /**
     * Convert degrees to radians
     */
    private toRadians;
    /**
     * Generate unique quote ID
     */
    private generateQuoteId;
    /**
     * Generate unique policy ID
     */
    private generatePolicyId;
    /**
     * Add realistic delay to simulate API call
     */
    private delay;
}
