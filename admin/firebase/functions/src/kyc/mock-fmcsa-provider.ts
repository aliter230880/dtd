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

import {
  IFmcsaProvider,
  FmcsaResult,
  SafetyRating,
  AuthorityStatus,
} from './fmcsa-interface';

/**
 * Mock carrier data structure
 */
interface MockCarrierData {
  dotNumber: string;
  mcNumber: string;
  companyLegalName: string;
  safetyRating: SafetyRating;
  authorityStatus: AuthorityStatus;
  address: string;
}

export class MockFmcsaProvider implements IFmcsaProvider {
  /**
   * Mock database of carrier information
   * In production, this would be replaced with real FMCSA API calls
   */
  private readonly mockCarriers: MockCarrierData[] = [
    {
      dotNumber: '12345',
      mcNumber: '111111',
      companyLegalName: 'Test Trucking LLC',
      safetyRating: 'Satisfactory',
      authorityStatus: 'Active',
      address: '123 Main St, Chicago, IL 60601',
    },
    {
      dotNumber: '67890',
      mcNumber: '222222',
      companyLegalName: 'Fast Freight Inc',
      safetyRating: 'Conditional',
      authorityStatus: 'Active',
      address: '456 Commerce Blvd, Dallas, TX 75201',
    },
    {
      dotNumber: '99999',
      mcNumber: '333333',
      companyLegalName: 'Old Transport Co',
      safetyRating: 'Unsatisfactory',
      authorityStatus: 'Inactive',
      address: '789 Industrial Ave, Detroit, MI 48201',
    },
  ];

  /**
   * Verify a carrier using DOT number
   * 
   * @param dotNumber DOT number to verify (e.g., "12345")
   * @returns Promise resolving to FmcsaResult with carrier data or error
   */
  async verifyDOT(dotNumber: string): Promise<FmcsaResult> {
    // Add realistic delay (1-2 seconds) to simulate API call
    await this.delay(1000 + Math.random() * 1000);

    // Validate DOT number format (must be numeric)
    if (!this.isValidDotNumber(dotNumber)) {
      return {
        success: false,
        error: 'Invalid DOT number format. Must be numeric.',
      };
    }

    // Search for carrier by DOT number
    const carrier = this.mockCarriers.find(c => c.dotNumber === dotNumber);

    if (!carrier) {
      return {
        success: false,
        error: 'DOT number not found in FMCSA database.',
      };
    }

    // Return carrier data
    return {
      success: true,
      companyLegalName: carrier.companyLegalName,
      safetyRating: carrier.safetyRating,
      authorityStatus: carrier.authorityStatus,
      address: carrier.address,
      metadata: {
        dotNumber: carrier.dotNumber,
        mcNumber: carrier.mcNumber,
        verifiedAt: new Date().toISOString(),
        provider: this.getName(),
      },
    };
  }

  /**
   * Verify a carrier using MC number
   * 
   * @param mcNumber MC number to verify (e.g., "111111")
   * @returns Promise resolving to FmcsaResult with carrier data or error
   */
  async verifyMC(mcNumber: string): Promise<FmcsaResult> {
    // Add realistic delay (1-2 seconds) to simulate API call
    await this.delay(1000 + Math.random() * 1000);

    // Validate MC number format (must be numeric)
    if (!this.isValidMcNumber(mcNumber)) {
      return {
        success: false,
        error: 'Invalid MC number format. Must be numeric.',
      };
    }

    // Search for carrier by MC number
    const carrier = this.mockCarriers.find(c => c.mcNumber === mcNumber);

    if (!carrier) {
      return {
        success: false,
        error: 'MC number not found in FMCSA database.',
      };
    }

    // Return carrier data
    return {
      success: true,
      companyLegalName: carrier.companyLegalName,
      safetyRating: carrier.safetyRating,
      authorityStatus: carrier.authorityStatus,
      address: carrier.address,
      metadata: {
        dotNumber: carrier.dotNumber,
        mcNumber: carrier.mcNumber,
        verifiedAt: new Date().toISOString(),
        provider: this.getName(),
      },
    };
  }

  /**
   * Get provider name
   * 
   * @returns Provider name for display and logging
   */
  getName(): string {
    return 'Mock FMCSA';
  }

  /**
   * Validate DOT number format
   * DOT numbers are numeric and typically 1-8 digits
   * 
   * @param dotNumber DOT number to validate
   * @returns true if valid, false otherwise
   */
  private isValidDotNumber(dotNumber: string): boolean {
    return /^\d{1,8}$/.test(dotNumber);
  }

  /**
   * Validate MC number format
   * MC numbers are numeric and typically 1-7 digits
   * 
   * @param mcNumber MC number to validate
   * @returns true if valid, false otherwise
   */
  private isValidMcNumber(mcNumber: string): boolean {
    return /^\d{1,7}$/.test(mcNumber);
  }

  /**
   * Add realistic delay to simulate API call
   * 
   * @param ms Milliseconds to delay
   * @returns Promise that resolves after delay
   */
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
