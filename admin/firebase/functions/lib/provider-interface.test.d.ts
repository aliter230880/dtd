/**
 * Insurance Provider Interface - Type Tests
 *
 * This file contains compile-time type tests to ensure the interfaces
 * are correctly defined and can be implemented.
 *
 * Note: These are TypeScript type tests, not runtime tests.
 * They verify the interface contracts at compile time.
 */
import { InsuranceProvider, QuoteParams, Quote, PurchaseParams, Policy } from './provider-interface';
/**
 * Mock implementation for compile-time verification
 */
declare class TestMockProvider implements InsuranceProvider {
    getQuote(params: QuoteParams): Promise<Quote>;
    purchasePolicy(params: PurchaseParams): Promise<Policy>;
    getName(): string;
}
/**
 * Test error types
 */
declare function testErrors(): void;
/**
 * Test Location interface
 */
declare function testLocation(): void;
/**
 * Test Quote interface with all optional fields
 */
declare function testQuote(): void;
/**
 * Test Policy interface with all optional fields
 */
declare function testPolicy(): void;
/**
 * Verify the provider can be used polymorphically
 */
declare function testProviderPolymorphism(): Promise<void>;
export { TestMockProvider, testErrors, testLocation, testQuote, testPolicy, testProviderPolymorphism };
