/**
 * Tests for verifyCarrier Cloud Function
 */

import { MockFmcsaProvider } from './mock-fmcsa-provider';

describe('verifyCarrier Cloud Function', () => {
  let provider: MockFmcsaProvider;

  beforeEach(() => {
    provider = new MockFmcsaProvider();
  });

  describe('DOT number verification', () => {
    it('should verify valid DOT number', async () => {
      const result = await provider.verifyDOT('12345');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Test Trucking LLC');
      expect(result.safetyRating).toBe('Satisfactory');
      expect(result.authorityStatus).toBe('Active');
      expect(result.address).toBe('123 Main St, Chicago, IL 60601');
      expect(result.metadata).toBeDefined();
      expect(result.metadata?.dotNumber).toBe('12345');
      expect(result.metadata?.mcNumber).toBe('111111');
    });

    it('should return error for invalid DOT format', async () => {
      const result = await provider.verifyDOT('ABC123');

      expect(result.success).toBe(false);
      expect(result.error).toBe('Invalid DOT number format. Must be numeric.');
    });

    it('should return error for non-existent DOT', async () => {
      const result = await provider.verifyDOT('88888');

      expect(result.success).toBe(false);
      expect(result.error).toBe('DOT number not found in FMCSA database.');
    });

    it('should verify DOT with Conditional rating', async () => {
      const result = await provider.verifyDOT('67890');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Fast Freight Inc');
      expect(result.safetyRating).toBe('Conditional');
      expect(result.authorityStatus).toBe('Active');
    });

    it('should verify DOT with Inactive status', async () => {
      const result = await provider.verifyDOT('99999');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Old Transport Co');
      expect(result.safetyRating).toBe('Unsatisfactory');
      expect(result.authorityStatus).toBe('Inactive');
    });
  });

  describe('MC number verification', () => {
    it('should verify valid MC number', async () => {
      const result = await provider.verifyMC('111111');

      expect(result.success).toBe(true);
      expect(result.companyLegalName).toBe('Test Trucking LLC');
      expect(result.safetyRating).toBe('Satisfactory');
      expect(result.authorityStatus).toBe('Active');
      expect(result.metadata).toBeDefined();
      expect(result.metadata?.mcNumber).toBe('111111');
      expect(result.metadata?.dotNumber).toBe('12345');
    });

    it('should return error for invalid MC format', async () => {
      const result = await provider.verifyMC('XYZ999');

      expect(result.success).toBe(false);
      expect(result.error).toBe('Invalid MC number format. Must be numeric.');
    });

    it('should return error for non-existent MC', async () => {
      const result = await provider.verifyMC('999999');

      expect(result.success).toBe(false);
      expect(result.error).toBe('MC number not found in FMCSA database.');
    });
  });

  describe('Response time simulation', () => {
    it('should simulate realistic API delay', async () => {
      const start = Date.now();
      await provider.verifyDOT('12345');
      const duration = Date.now() - start;

      // Should take between 1-2 seconds
      expect(duration).toBeGreaterThanOrEqual(1000);
      expect(duration).toBeLessThan(2500);
    });
  });

  describe('Provider name', () => {
    it('should return correct provider name', () => {
      expect(provider.getName()).toBe('Mock FMCSA');
    });
  });
});
