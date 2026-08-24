"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.InsurancePurchaseError = exports.InsuranceQuoteError = void 0;
/**
 * Error types for insurance operations
 *
 * These custom errors allow business logic to handle different failure scenarios
 * with appropriate user messages and retry strategies.
 */
class InsuranceQuoteError extends Error {
    constructor(message, code, details) {
        super(message);
        this.code = code;
        this.details = details;
        this.name = 'InsuranceQuoteError';
    }
}
exports.InsuranceQuoteError = InsuranceQuoteError;
class InsurancePurchaseError extends Error {
    constructor(message, code, details) {
        super(message);
        this.code = code;
        this.details = details;
        this.name = 'InsurancePurchaseError';
    }
}
exports.InsurancePurchaseError = InsurancePurchaseError;
//# sourceMappingURL=provider-interface.js.map