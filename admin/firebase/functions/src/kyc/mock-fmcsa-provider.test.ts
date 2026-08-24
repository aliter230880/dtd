/**
 * Mock FMCSA Provider Tests
 * 
 * Tests for the mock FMCSA provider implementation.
 * Verifies that DOT/MC verification works correctly with test data.
 */

import { MockFmcsaProvider } from './mock-fmcsa-provider';
import { FmcsaResult } from './fmcsa-interface';

describe('MockFmcsaProvider', () => {
  let provider: MockFmcsaProvider;

  beforeEach(() => {
    provider = new MockFmcsaProvider();
  });

  describe('verifyDOT', () => {
    it('should verify valid DOT number 12345 (Test Trucking LLC)', async () => {
      const result: FmcsaResult = await provider.verifyDOT('12345');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Test Trucking LLC');
      expect(result.safetyRating).toBe('Satisfactory');
      expect(result.authorityStatus).toBe('Active');
      expect(result.address).toBe('123 Main St, Chicago, IL 60601');
      expect(result.metadata?.dotNumber).toBe('12345');
      expect(result.metadata?.mcNumber).toBe('111111');
    });

    it('should verify valid DOT number 67890 (Fast Freight Inc)', async () => {
      const result: FmcsaResult = await provider.verifyDOT('67890');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Fast Freight Inc');
      expect(result.safetyRating).toBe('Conditional');
      expect(result.authorityStatus).toBe('Active');
      expect(result.address).toBe('456 Commerce Blvd, Dallas, TX 75201');
    });

    it('should verify valid DOT number 99999 (Old Transport Co - Unsatisfactory/Inactive)', async () => {
      const result: FmcsaResult = await provider.verifyDOT('99999');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Old Transport Co');
      expect(result.safetyRating).toBe('Unsatisfactory');
      expect(result.authorityStatus).toBe('Inactive');
      expect(result.address).toBe('789 Industrial Ave, Detroit, MI 48201');
    });

    it('should return error for non-existent DOT number', async () => {
      const result: FmcsaResult = await provider.verifyDOT('00000');

      expect(result.success).toBe(false);
      expect(result.error).toBe('DOT number not found in FMCSA database.');
      expect(result.companyLegalName).toBeUndefined();
    });

    it('should return error for invalid DOT number format (non-numeric)', async () => {
      const result: FmcsaResult = await provider.verifyDOT('ABC123');

      expect(result.success).toBe(false);
      expect(result.error).toBe('Invalid DOT number format. Must be numeric.');
    });

    it('should return error for invalid DOT number format (too long)', async () => {
      const result: FmcsaResult = await provider.verifyDOT('123456789');

      expect(result.success).toBe(false);
      expect(result.error).toBe('Invalid DOT number format. Must be numeric.');
    });

    it('should include verification timestamp in metadata', async () => {
      const before = new Date();
      const result: FmcsaResult = await provider.verifyDOT('12345');
      const after = new Date();

      expect(result.metadata?.verifiedAt).toBeDefined();
      const verifiedAt = new Date(result.metadata!.verifiedAt);
      expect(verifiedAt.getTime()).toBeGreaterThanOrEqual(before.getTime());
      expect(verifiedAt.getTime()).toBeLessThanOrEqual(after.getTime());
    });
  });

  describe('verifyMC', () => {
    it('should verify valid MC number 111111 (Test Trucking LLC)', async () => {
      const result: FmcsaResult = await provider.verifyMC('111111');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Test Trucking LLC');
      expect(result.safetyRating).toBe('Satisfactory');
      expect(result.authorityStatus).toBe('Active');
      expect(result.metadata?.dotNumber).toBe('12345');
      expect(result.metadata?.mcNumber).toBe('111111');
    });

    it('should verify valid MC number 222222 (Fast Freight Inc)', async () => {
      const result: FmcsaResult = await provider.verifyMC('222222');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Fast Freight Inc');
      expect(result.safetyRating).toBe('Conditional');
      expect(result.authorityStatus).toBe('Active');
    });

    it('should verify valid MC number 333333 (Old Transport Co - Inactive)', async () => {
      const result: FmcsaResult = await provider.verifyMC('333333');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Old Transport Co');
      expect(result.authorityStatus).toBe('Inactive');
    });

    it('should return error for non-existent MC number', async () => {
      const result: FmcsaResult = await provider.verifyMC('999999');

      expect(result.success).toBe(false);
      expect(result.error).toBe('MC number not found in FMCSA database.');
    });

    it('should return error for invalid MC number format (non-numeric)', async () => {
      const result: FmcsaResult = await provider.verifyMC('MC-123');

      expect(result.success).toBe(false);
      expect(result.error).toBe('Invalid MC number format. Must be numeric.');
    });

    it('should return error for invalid MC number format (too long)', async () => {
      const result: FmcsaResult = await provider.verifyMC('12345678');

      expect(result.success).toBe(false);
      expect(result.error).toBe('Invalid MC number format. Must be numeric.');
    });
  });

  describe('getName', () => {
    it('should return provider name', () => {
      expect(provider.getName()).toBe('Mock FMCSA');
    });
  });

  describe('Realistic delay simulation', () => {
    it('should take at least 1 second to verify DOT', async () => {
      const start = Date.now();
      await provider.verifyDOT('12345');
      const duration = Date.now() - start;

      expect(duration).toBeGreaterThanOrEqual(1000);
      expect(duration).toBeLessThan(3000); // Should be under 3 seconds
    });

    it('should take at least 1 second to verify MC', async () => {
      const start = Date.now();
      await provider.verifyMC('111111');
      const duration = Date.now() - start;

      expect(duration).toBeGreaterThanOrEqual(1000);
      expect(duration).toBeLessThan(3000);
    });
  });
});
