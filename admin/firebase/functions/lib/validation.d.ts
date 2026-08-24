/**
 * Insurance Validation Utilities
 *
 * Provides validation functions for insurance-related data inputs including
 * VIN validation, US location validation, and vehicle value validation.
 *
 * Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6
 */
/**
 * Validation result interface
 */
export interface ValidationResult {
    valid: boolean;
    error?: string;
}
/**
 * Geographic location interface
 */
export interface Location {
    latitude: number;
    longitude: number;
}
/**
 * Validates a Vehicle Identification Number (VIN)
 *
 * Requirements: 7.1, 7.2
 *
 * @param vin - The VIN string to validate
 * @returns ValidationResult with valid=true if VIN is exactly 17 alphanumeric characters
 */
export declare function validateVIN(vin: string | null | undefined): ValidationResult;
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
export declare function validateUSLocation(location: Location | null | undefined): ValidationResult;
/**
 * Validates that a vehicle value is within acceptable range
 *
 * Requirements: 7.5, 7.6
 *
 * @param vehicleValue - Vehicle value in dollars
 * @returns ValidationResult with valid=true if value is between $1,000 and $500,000 (inclusive)
 */
export declare function validateVehicleValue(vehicleValue: number | null | undefined): ValidationResult;
/**
 * Validates all insurance quote inputs together
 *
 * @param vin - Vehicle Identification Number
 * @param pickupLocation - Pickup location coordinates
 * @param deliveryLocation - Delivery location coordinates
 * @param vehicleValue - Vehicle value in dollars
 * @returns ValidationResult with valid=true if all inputs are valid
 */
export declare function validateQuoteInputs(vin: string | null | undefined, pickupLocation: Location | null | undefined, deliveryLocation: Location | null | undefined, vehicleValue: number | null | undefined): ValidationResult;
