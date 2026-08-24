/**
 * Insurance Provider Interface
 *
 * This file defines the core abstractions for insurance provider integration.
 * It supports both mock implementations (for MVP) and real insurance provider APIs
 * (Progressive, Nationwide, etc.) without changing the business logic.
 *
 * Design Philosophy:
 * - Mock-first approach: Start with simulated providers, add real ones incrementally
 * - Provider-agnostic: Business logic doesn't depend on specific provider implementation
 * - Type-safe: All provider interactions are strongly typed
 *
 * Requirements covered: 2.2, 3.2
 */
/**
 * Geographic location with latitude and longitude coordinates
 */
export interface Location {
    latitude: number;
    longitude: number;
    address?: string;
}
/**
 * Parameters required to calculate an insurance quote
 */
export interface QuoteParams {
    /** Vehicle Identification Number (17 alphanumeric characters) */
    vin: string;
    /** Pickup location for the vehicle transport */
    pickupLocation: Location;
    /** Delivery destination for the vehicle transport */
    deliveryLocation: Location;
    /** Declared value of the vehicle in USD */
    vehicleValue: number;
    /** Distance between pickup and delivery in miles (pre-calculated) */
    distance?: number;
}
/**
 * Insurance quote response from provider
 */
export interface Quote {
    /** Unique identifier for this quote (used for purchase) */
    quoteId?: string;
    /** Premium cost in cents (integer to avoid floating point issues) */
    quoteCost: number;
    /** Timestamp when this quote expires */
    expiresAt: Date;
    /** Name of the insurance provider */
    provider: string;
    /** Additional metadata from provider (optional) */
    metadata?: Record<string, any>;
}
/**
 * Parameters required to purchase an insurance policy
 */
export interface PurchaseParams {
    /** Quote ID from previous getQuote() call */
    quoteId: string;
    /** Payment token or reference (for real providers) */
    paymentToken?: string;
    /** Deal ID for context and audit trail */
    dealId: string;
    /** Vehicle and route information (for policy document generation) */
    vehicleInfo?: {
        vin: string;
        make?: string;
        model?: string;
        year?: number;
    };
    routeInfo?: {
        origin: string;
        destination: string;
    };
}
/**
 * Insurance policy response after successful purchase
 */
export interface Policy {
    /** Unique policy number from insurance provider */
    policyId: string;
    /** Name of the insurance provider */
    provider: string;
    /** URL to the policy document (PDF) */
    documentUrl: string;
    /** Effective date of the policy */
    effectiveDate?: Date;
    /** Expiration date of the policy */
    expirationDate?: Date;
    /** Coverage amount in USD */
    coverageAmount?: number;
    /** Additional policy metadata */
    metadata?: Record<string, any>;
}
/**
 * Main Insurance Provider interface
 *
 * All insurance providers (mock or real) must implement this interface.
 * This enables seamless switching between providers via factory pattern.
 *
 * Implementation examples:
 * - MockInsuranceProvider: Formula-based quotes, generated policy documents
 * - ProgressiveInsuranceProvider: Real API integration with Progressive Commercial Auto
 * - NationwideInsuranceProvider: Real API integration with Nationwide
 */
export interface InsuranceProvider {
    /**
     * Get insurance quote for a vehicle transport
     *
     * @param params Quote parameters including VIN, locations, and vehicle value
     * @returns Promise resolving to Quote with cost and expiration
     * @throws Error if quote calculation fails (network, validation, etc.)
     */
    getQuote(params: QuoteParams): Promise<Quote>;
    /**
     * Purchase insurance policy using a previously obtained quote
     *
     * @param params Purchase parameters including quote ID and payment info
     * @returns Promise resolving to Policy with policy ID and document URL
     * @throws Error if purchase fails (expired quote, payment failure, etc.)
     */
    purchasePolicy(params: PurchaseParams): Promise<Policy>;
    /**
     * Get provider name for display and logging
     *
     * @returns Human-readable provider name (e.g., "Mock Insurance Co.", "Progressive Commercial Auto")
     */
    getName(): string;
}
/**
 * Error types for insurance operations
 *
 * These custom errors allow business logic to handle different failure scenarios
 * with appropriate user messages and retry strategies.
 */
export declare class InsuranceQuoteError extends Error {
    code: 'validation' | 'timeout' | 'unavailable' | 'unknown';
    details?: any;
    constructor(message: string, code: 'validation' | 'timeout' | 'unavailable' | 'unknown', details?: any);
}
export declare class InsurancePurchaseError extends Error {
    code: 'expired_quote' | 'payment_failed' | 'unavailable' | 'unknown';
    details?: any;
    constructor(message: string, code: 'expired_quote' | 'payment_failed' | 'unavailable' | 'unknown', details?: any);
}
