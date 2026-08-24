/**
 * Mock FMCSA Provider
 *
 * Simple test implementation of IFmcsaProvider for MVP development and testing.
 * Provides instant carrier verification without external API dependencies.
 *
 * Mock data includes:
 * - DOT 12345: Test Trucking LLC (Satisfactory, Active, Chicago IL)
 * - DOT 67890: Fast Freight Inc (Conditional, Active, Dallas TX)
 * - DOT 99999: Old Transport Co (Unsatisfactory, Inactive, Detroit MI)
 *
 * Simulates realistic API delay (1-2 seconds).
 *
 * Requirements covered: Carrier KYC verification (MVP testing)
 */
import { IFmcsaProvider, FmcsaResult } from './fmcsa-interface';
export declare class MockFmcsaProvider implements IFmcsaProvider {
    /**
     * Mock database of carrier information
     * In production, this would be replaced with real FMCSA API calls
     */
    private readonly mockCarriers;
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
     * @param mcNumber MC number to verify (e.g., "111111")
     * @returns Promise resolving to FmcsaResult with carrier data or error
     */
    verifyMC(mcNumber: string): Promise<FmcsaResult>;
    /**
     * Get provider name
     *
     * @returns Provider name for display and logging
     */
    getName(): string;
    /**
     * Validate DOT number format
     * DOT numbers are numeric and typically 1-8 digits
     *
     * @param dotNumber DOT number to validate
     * @returns true if valid, false otherwise
     */
    private isValidDotNumber;
    /**
     * Validate MC number format
     * MC numbers are numeric and typically 1-7 digits
     *
     * @param mcNumber MC number to validate
     * @returns true if valid, false otherwise
     */
    private isValidMcNumber;
    /**
     * Add realistic delay to simulate API call
     *
     * @param ms Milliseconds to delay
     * @returns Promise that resolves after delay
     */
    private delay;
}
