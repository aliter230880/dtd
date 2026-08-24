/**
 * FMCSA Provider Interface
 *
 * This file defines the core abstractions for FMCSA (Federal Motor Carrier Safety Administration)
 * integration for carrier verification during KYC (Know Your Customer) process.
 *
 * It supports both mock implementations (for MVP testing) and real FMCSA API integration
 * without changing the business logic.
 *
 * Design Philosophy:
 * - Mock-first approach: Start with simulated providers, add real integration incrementally
 * - Provider-agnostic: Business logic doesn't depend on specific implementation
 * - Type-safe: All provider interactions are strongly typed
 *
 * Requirements covered: Carrier KYC verification
 */
/**
 * Safety rating categories from FMCSA
 */
export type SafetyRating = 'Satisfactory' | 'Conditional' | 'Unsatisfactory';
/**
 * Authority status from FMCSA
 */
export type AuthorityStatus = 'Active' | 'Inactive';
/**
 * FMCSA verification result
 */
export interface FmcsaResult {
    /** Whether the verification was successful */
    success: boolean;
    /** Company legal name (if found) */
    companyLegalName?: string;
    /** Safety rating from FMCSA (if found) */
    safetyRating?: SafetyRating;
    /** Authority status (if found) */
    authorityStatus?: AuthorityStatus;
    /** Company address (if found) */
    address?: string;
    /** Error message (if verification failed) */
    error?: string;
    /** Additional metadata from provider (optional) */
    metadata?: Record<string, any>;
}
/**
 * Main FMCSA Provider interface
 *
 * All FMCSA providers (mock or real) must implement this interface.
 * This enables seamless switching between providers via factory pattern.
 *
 * Implementation examples:
 * - MockFmcsaProvider: Test data for known DOT/MC numbers
 * - RealFmcsaProvider: Real API integration with FMCSA SAFER system
 */
export interface IFmcsaProvider {
    /**
     * Verify a carrier using DOT number
     *
     * @param dotNumber DOT number to verify (e.g., "12345")
     * @returns Promise resolving to FmcsaResult with carrier data or error
     */
    verifyDOT(dotNumber: string): Promise<FmcsaResult>;
    /**
     * Verify a carrier using MC number
     *
     * @param mcNumber MC number to verify (e.g., "67890")
     * @returns Promise resolving to FmcsaResult with carrier data or error
     */
    verifyMC(mcNumber: string): Promise<FmcsaResult>;
    /**
     * Get provider name for display and logging
     *
     * @returns Human-readable provider name (e.g., "Mock FMCSA", "FMCSA SAFER API")
     */
    getName(): string;
}
/**
 * Error types for FMCSA operations
 *
 * These custom errors allow business logic to handle different failure scenarios
 * with appropriate user messages and retry strategies.
 */
export declare class FmcsaVerificationError extends Error {
    code: 'validation' | 'not_found' | 'timeout' | 'unavailable' | 'unknown';
    details?: any;
    constructor(message: string, code: 'validation' | 'not_found' | 'timeout' | 'unavailable' | 'unknown', details?: any);
}
