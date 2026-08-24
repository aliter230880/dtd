# KYC (Know Your Customer) Module

## Overview

This module handles carrier verification using FMCSA (Federal Motor Carrier Safety Administration) data as part of the KYC process for DTD platform.

## Purpose

Verify carrier legitimacy and safety ratings before allowing them to participate on the platform. This includes:
- DOT number verification
- MC number verification
- Safety rating checks
- Authority status validation

## Architecture

### Provider Interface Pattern

Similar to the insurance module, this uses the **provider interface pattern** to support both mock and real implementations:

```
IFmcsaProvider (interface)
├── MockFmcsaProvider (for testing)
└── RealFmcsaProvider (future: real FMCSA API)
```

### Benefits
- **Mock-first development**: Build and test without API dependencies
- **Easy testing**: Predictable mock data for unit and integration tests
- **Seamless migration**: Switch to real API by swapping provider implementation
- **Provider-agnostic**: Business logic doesn't depend on specific implementation

## Files

### `fmcsa-interface.ts`
Defines the core abstractions:
- `IFmcsaProvider`: Interface all providers must implement
- `FmcsaResult`: Verification result type
- `SafetyRating`: Type for FMCSA safety ratings
- `AuthorityStatus`: Type for carrier authority status
- `FmcsaVerificationError`: Custom error class

### `mock-fmcsa-provider.ts`
Mock implementation for MVP testing:
- Instant verification (1-2 second simulated delay)
- Predefined test data for known DOT/MC numbers
- No external API dependencies

## Mock Test Data

The mock provider includes the following test carriers:

| DOT Number | MC Number | Company Name | Safety Rating | Authority Status | Location |
|------------|-----------|--------------|---------------|------------------|----------|
| 12345 | 111111 | Test Trucking LLC | Satisfactory | Active | Chicago, IL |
| 67890 | 222222 | Fast Freight Inc | Conditional | Active | Dallas, TX |
| 99999 | 333333 | Old Transport Co | Unsatisfactory | Inactive | Detroit, MI |

## Usage Examples

### Verify by DOT Number

```typescript
import { MockFmcsaProvider } from './mock-fmcsa-provider';

const provider = new MockFmcsaProvider();

// Successful verification
const result = await provider.verifyDOT('12345');
console.log(result);
// {
//   success: true,
//   companyLegalName: 'Test Trucking LLC',
//   safetyRating: 'Satisfactory',
//   authorityStatus: 'Active',
//   address: '123 Main St, Chicago, IL 60601',
//   metadata: { dotNumber: '12345', mcNumber: '111111', ... }
// }

// Not found
const notFound = await provider.verifyDOT('00000');
console.log(notFound);
// {
//   success: false,
//   error: 'DOT number not found in FMCSA database.'
// }
```

### Verify by MC Number

```typescript
import { MockFmcsaProvider } from './mock-fmcsa-provider';

const provider = new MockFmcsaProvider();

const result = await provider.verifyMC('222222');
console.log(result);
// {
//   success: true,
//   companyLegalName: 'Fast Freight Inc',
//   safetyRating: 'Conditional',
//   authorityStatus: 'Active',
//   address: '456 Commerce Blvd, Dallas, TX 75201',
//   metadata: { dotNumber: '67890', mcNumber: '222222', ... }
// }
```

## Integration Scenarios

### Carrier Registration Flow

1. Carrier provides DOT/MC number during registration
2. System calls `provider.verifyDOT(dotNumber)` or `provider.verifyMC(mcNumber)`
3. Check result:
   - If `success === false`: Reject registration with error message
   - If `authorityStatus === 'Inactive'`: Warn carrier or reject
   - If `safetyRating === 'Unsatisfactory'`: Flag for manual review or reject
   - If `safetyRating === 'Satisfactory'` or `'Conditional'` and `authorityStatus === 'Active'`: Allow registration

### Business Rules (Examples)

These are suggested rules - adjust based on business requirements:

**Auto-approve:**
- Safety Rating: Satisfactory
- Authority Status: Active

**Manual review:**
- Safety Rating: Conditional
- Authority Status: Active

**Auto-reject:**
- Safety Rating: Unsatisfactory
- Authority Status: Inactive
- DOT/MC not found

## Future Enhancements

### Real FMCSA Integration

When ready to integrate with real FMCSA API:

1. Create `real-fmcsa-provider.ts` implementing `IFmcsaProvider`
2. Use FMCSA SAFER API (https://safer.fmcsa.dot.gov/)
3. Handle rate limiting and caching
4. Swap provider in factory/dependency injection

### Additional Verifications

Future enhancements could include:
- Insurance verification (cross-check with insurance module)
- Operating authority dates
- Out-of-service status checks
- Crash and inspection history
- Safety score calculations

## Testing

### Unit Tests

Test the mock provider behavior:
- Valid DOT/MC numbers return correct data
- Invalid numbers return errors
- Format validation works correctly

### Integration Tests

Test KYC flow with mock provider:
- Registration with valid carrier
- Registration with invalid carrier
- Registration with inactive carrier
- Registration with unsatisfactory rating

## Related Modules

- **Insurance Module** (`../insurance/`): Provides insurance quotes and policy purchase
- **KYC Service** (future): Orchestrates carrier verification flow

## References

- [FMCSA SAFER System](https://safer.fmcsa.dot.gov/)
- [FMCSA Safety Ratings](https://www.fmcsa.dot.gov/safety/carrier-safety-fitness)
