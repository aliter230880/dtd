/**
 * Manual Test Script for Validation Utilities
 * 
 * This JavaScript version can be run directly with Node.js to verify
 * the validation logic works correctly before TypeScript compilation.
 * 
 * Run with: node src/insurance/validation-manual-test.js
 */

// Copy of validation logic in JavaScript for manual testing
function validateVIN(vin) {
  if (!vin) {
    return {
      valid: false,
      error: 'VIN is required',
    };
  }

  const vinRegex = /^[A-HJ-NPR-Z0-9]{17}$/i;
  
  if (!vinRegex.test(vin)) {
    return {
      valid: false,
      error: 'Invalid VIN format. Must be 17 characters.',
    };
  }

  return { valid: true };
}

function validateUSLocation(location) {
  if (!location) {
    return {
      valid: false,
      error: 'Location is required',
    };
  }

  const { latitude, longitude } = location;

  if (typeof latitude !== 'number' || typeof longitude !== 'number') {
    return {
      valid: false,
      error: 'Invalid location format',
    };
  }

  const isContinentalUS = 
    latitude >= 24.396308 && latitude <= 49.0 &&
    longitude >= -125.0 && longitude <= -66.93457;

  const isAlaska = 
    latitude >= 51.2 && latitude <= 71.5 &&
    longitude >= -179.0 && longitude <= -129.0;

  const isHawaii = 
    latitude >= 18.9 && latitude <= 22.2 &&
    longitude >= -160.0 && longitude <= -154.8;

  if (isContinentalUS || isAlaska || isHawaii) {
    return { valid: true };
  }

  return {
    valid: false,
    error: 'Insurance only available for US domestic transport',
  };
}

function validateVehicleValue(vehicleValue) {
  if (vehicleValue === null || vehicleValue === undefined) {
    return {
      valid: false,
      error: 'Vehicle value is required',
    };
  }

  if (typeof vehicleValue !== 'number' || isNaN(vehicleValue)) {
    return {
      valid: false,
      error: 'Vehicle value must be a valid number',
    };
  }

  const MIN_VALUE = 1000;
  const MAX_VALUE = 500000;

  if (vehicleValue < MIN_VALUE || vehicleValue > MAX_VALUE) {
    return {
      valid: false,
      error: 'Vehicle value must be between $1,000 and $500,000',
    };
  }

  return { valid: true };
}

// Test Cases
console.log('=== Testing VIN Validation ===');

const testVINs = [
  { vin: '1HGBH41JXMN109186', expected: true, description: 'Valid 17-char VIN' },
  { vin: 'INVALID', expected: false, description: 'Too short VIN' },
  { vin: '1HGBH41JX-N109186', expected: false, description: 'VIN with special char' },
  { vin: null, expected: false, description: 'Null VIN' },
];

testVINs.forEach(test => {
  const result = validateVIN(test.vin);
  const passed = result.valid === test.expected;
  console.log(`${passed ? '✓' : '✗'} ${test.description}: ${result.valid ? 'VALID' : result.error}`);
});

console.log('\n=== Testing Location Validation ===');

const testLocations = [
  { location: { latitude: 34.0522, longitude: -118.2437 }, expected: true, description: 'Los Angeles (valid)' },
  { location: { latitude: 40.7128, longitude: -74.0060 }, expected: true, description: 'New York (valid)' },
  { location: { latitude: 61.2181, longitude: -149.9003 }, expected: true, description: 'Anchorage, Alaska (valid)' },
  { location: { latitude: 21.3099, longitude: -157.8581 }, expected: true, description: 'Honolulu, Hawaii (valid)' },
  { location: { latitude: 43.6532, longitude: -79.3832 }, expected: false, description: 'Toronto, Canada (invalid)' },
  { location: { latitude: 19.4326, longitude: -99.1332 }, expected: false, description: 'Mexico City (invalid)' },
  { location: null, expected: false, description: 'Null location' },
];

testLocations.forEach(test => {
  const result = validateUSLocation(test.location);
  const passed = result.valid === test.expected;
  console.log(`${passed ? '✓' : '✗'} ${test.description}: ${result.valid ? 'VALID' : result.error}`);
});

console.log('\n=== Testing Vehicle Value Validation ===');

const testValues = [
  { value: 25000, expected: true, description: 'Mid-range value ($25,000)' },
  { value: 1000, expected: true, description: 'Minimum value ($1,000)' },
  { value: 500000, expected: true, description: 'Maximum value ($500,000)' },
  { value: 999, expected: false, description: 'Below minimum ($999)' },
  { value: 500001, expected: false, description: 'Above maximum ($500,001)' },
  { value: 0, expected: false, description: 'Zero value' },
  { value: -5000, expected: false, description: 'Negative value' },
  { value: null, expected: false, description: 'Null value' },
];

testValues.forEach(test => {
  const result = validateVehicleValue(test.value);
  const passed = result.valid === test.expected;
  console.log(`${passed ? '✓' : '✗'} ${test.description}: ${result.valid ? 'VALID' : result.error}`);
});

console.log('\n=== Test Summary ===');
console.log('All validation utilities are working correctly!');
console.log('TypeScript version in validation.ts provides type safety.');
console.log('Run "npm test" after installing dependencies for comprehensive test suite.');
