# Insurance Integration Utilities

This directory contains the insurance integration functionality for the DTD marketplace.

## Files

### validation.ts
Insurance data validation utilities including:

- **validateVIN(vin)**: Validates Vehicle Identification Numbers (17 alphanumeric characters)
- **validateUSLocation(location)**: Validates coordinates are within US boundaries (continental US, Alaska, Hawaii)
- **validateVehicleValue(vehicleValue)**: Validates vehicle value is between $1,000 and $500,000
- **validateQuoteInputs(vin, pickupLocation, deliveryLocation, vehicleValue)**: Validates all quote inputs together

### validation.test.ts
Comprehensive unit tests for validation utilities with 100+ test cases covering:
- Valid and invalid VINs
- US and non-US locations
- Valid and invalid vehicle values
- Combined validation scenarios

## Requirements Satisfied

- **7.1**: VIN must be exactly 17 alphanumeric characters
- **7.2**: Error message "Invalid VIN format. Must be 17 characters."
- **7.3**: Pickup and delivery locations must be within United States boundaries
- **7.4**: Error message "Insurance only available for US domestic transport"
- **7.5**: Vehicle value must be between $1,000 and $500,000 (inclusive)
- **7.6**: Error message "Vehicle value must be between $1,000 and $500,000"

## Installation

From the `functions` directory:

```bash
npm install
```

## Running Tests

```bash
npm test
```

## Usage Example

```typescript
import { validateVIN, validateUSLocation, validateVehicleValue } from './insurance/validation';

// Validate VIN
const vinResult = validateVIN('1HGBH41JXMN109186');
if (!vinResult.valid) {
  console.error(vinResult.error);
}

// Validate location
const locationResult = validateUSLocation({
  latitude: 34.0522,
  longitude: -118.2437
});

// Validate vehicle value
const valueResult = validateVehicleValue(25000);

// Or validate all at once
import { validateQuoteInputs } from './insurance/validation';

const result = validateQuoteInputs(
  '1HGBH41JXMN109186',
  { latitude: 34.0522, longitude: -118.2437 },
  { latitude: 40.7128, longitude: -74.0060 },
  25000
);

if (!result.valid) {
  throw new Error(result.error);
}
```

## Next Steps

These validation utilities will be integrated into:
1. Cloud Function `calculateInsuranceQuote` (task 3.3)
2. Cloud Function `purchaseInsurance` (task 4.1)
3. Flutter UI validation (task 7.x)
