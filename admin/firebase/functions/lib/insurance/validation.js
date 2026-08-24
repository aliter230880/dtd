"use strict";
/**
 * Insurance Validation Utilities
 *
 * Provides validation functions for insurance-related data inputs including
 * VIN validation, US location validation, and vehicle value validation.
 *
 * Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateQuoteInputs = exports.validateVehicleValue = exports.validateUSLocation = exports.validateVIN = void 0;
/**
 * Validates a Vehicle Identification Number (VIN)
 *
 * Requirements: 7.1, 7.2
 *
 * @param vin - The VIN string to validate
 * @returns ValidationResult with valid=true if VIN is exactly 17 alphanumeric characters
 */
function validateVIN(vin) {
    if (!vin) {
        return {
            valid: false,
            error: 'VIN is required',
        };
    }
    // VIN must be exactly 17 alphanumeric characters
    const vinRegex = /^[A-HJ-NPR-Z0-9]{17}$/i;
    if (!vinRegex.test(vin)) {
        return {
            valid: false,
            error: 'Invalid VIN format. Must be 17 characters.',
        };
    }
    return { valid: true };
}
exports.validateVIN = validateVIN;
/**
 * Validates that a geographic location is within United States boundaries
 *
 * Requirements: 7.3, 7.4
 *
 * Approximate US boundaries:
 * - Continental US: Latitude 24.4° N to 49.0° N, Longitude -125.0° W to -66.9° W
 * - Alaska: Latitude 51.2° N to 71.5° N, Longitude -179.0° W to -129.0° W
 * - Hawaii: Latitude 18.9° N to 22.2° N, Longitude -160.0° W to -154.8° W
 *
 * Note: This is a simplified bounding box check. For production use with real API,
 * consider using a geocoding service or more precise polygon-based validation.
 *
 * @param location - Location object with latitude and longitude
 * @returns ValidationResult with valid=true if location is within US boundaries
 */
function validateUSLocation(location) {
    if (!location) {
        return {
            valid: false,
            error: 'Location is required',
        };
    }
    const { latitude, longitude } = location;
    // Validate latitude and longitude are numbers
    if (typeof latitude !== 'number' || typeof longitude !== 'number') {
        return {
            valid: false,
            error: 'Invalid location format',
        };
    }
    // Check if location is within continental US
    // Adjusted northern boundary to 49.0° to better separate from Canada
    // Note: Simple bounding box validation may include some Canadian border cities
    // For production with real insurance API, use geocoding service for precise validation
    const isContinentalUS = latitude >= 24.396308 && latitude <= 49.0 &&
        longitude >= -125.0 && longitude <= -66.93457;
    // Check if location is within Alaska
    const isAlaska = latitude >= 51.2 && latitude <= 71.5 &&
        longitude >= -179.0 && longitude <= -129.0;
    // Check if location is within Hawaii
    const isHawaii = latitude >= 18.9 && latitude <= 22.2 &&
        longitude >= -160.0 && longitude <= -154.8;
    if (isContinentalUS || isAlaska || isHawaii) {
        return { valid: true };
    }
    return {
        valid: false,
        error: 'Insurance only available for US domestic transport',
    };
}
exports.validateUSLocation = validateUSLocation;
/**
 * Validates that a vehicle value is within acceptable range
 *
 * Requirements: 7.5, 7.6
 *
 * @param vehicleValue - Vehicle value in dollars
 * @returns ValidationResult with valid=true if value is between $1,000 and $500,000 (inclusive)
 */
function validateVehicleValue(vehicleValue) {
    if (vehicleValue === null || vehicleValue === undefined) {
        return {
            valid: false,
            error: 'Vehicle value is required',
        };
    }
    // Validate it's a number
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
exports.validateVehicleValue = validateVehicleValue;
/**
 * Validates all insurance quote inputs together
 *
 * @param vin - Vehicle Identification Number
 * @param pickupLocation - Pickup location coordinates
 * @param deliveryLocation - Delivery location coordinates
 * @param vehicleValue - Vehicle value in dollars
 * @returns ValidationResult with valid=true if all inputs are valid
 */
function validateQuoteInputs(vin, pickupLocation, deliveryLocation, vehicleValue) {
    // Validate VIN
    const vinResult = validateVIN(vin);
    if (!vinResult.valid) {
        return vinResult;
    }
    // Validate pickup location
    const pickupResult = validateUSLocation(pickupLocation);
    if (!pickupResult.valid) {
        return {
            valid: false,
            error: `Pickup location: ${pickupResult.error}`,
        };
    }
    // Validate delivery location
    const deliveryResult = validateUSLocation(deliveryLocation);
    if (!deliveryResult.valid) {
        return {
            valid: false,
            error: `Delivery location: ${deliveryResult.error}`,
        };
    }
    // Validate vehicle value
    const valueResult = validateVehicleValue(vehicleValue);
    if (!valueResult.valid) {
        return valueResult;
    }
    return { valid: true };
}
exports.validateQuoteInputs = validateQuoteInputs;
//# sourceMappingURL=validation.js.map