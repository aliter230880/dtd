"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.FmcsaVerificationError = void 0;
/**
 * Error types for FMCSA operations
 *
 * These custom errors allow business logic to handle different failure scenarios
 * with appropriate user messages and retry strategies.
 */
class FmcsaVerificationError extends Error {
    constructor(message, code, details) {
        super(message);
        this.code = code;
        this.details = details;
        this.name = 'FmcsaVerificationError';
    }
}
exports.FmcsaVerificationError = FmcsaVerificationError;
//# sourceMappingURL=fmcsa-interface.js.map