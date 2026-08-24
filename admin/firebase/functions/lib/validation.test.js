"use strict";
/**
 * Unit tests for Insurance Validation Utilities
 *
 * Tests validation functions for VIN, US location, and vehicle value
 *
 * Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6
 */
Object.defineProperty(exports, "__esModule", { value: true });
const validation_1 = require("./validation");
describe('validateVIN', () => {
    describe('valid VINs', () => {
        it('should accept exactly 17 alphanumeric characters', () => {
            const result = (0, validation_1.validateVIN)('1HGBH41JXMN109186');
            expect(result.valid).toBe(true);
            expect(result.error).toBeUndefined();
        });
        it('should accept VINs with lowercase letters', () => {
            const result = (0, validation_1.validateVIN)('1hgbh41jxmn109186');
            expect(result.valid).toBe(true);
        });
        it('should accept VINs with mixed case', () => {
            const result = (0, validation_1.validateVIN)('1HgBh41JxMn109186');
            expect(result.valid).toBe(true);
        });
        it('should accept VINs without letters I, O, Q (as per standard)', () => {
            const result = (0, validation_1.validateVIN)('JH4KA8170MC000000');
            expect(result.valid).toBe(true);
        });
    });
    describe('invalid VINs', () => {
        it('should reject VIN shorter than 17 characters', () => {
            const result = (0, validation_1.validateVIN)('1HGBH41JXMN10918');
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Invalid VIN format. Must be 17 characters.');
        });
        it('should reject VIN longer than 17 characters', () => {
            const result = (0, validation_1.validateVIN)('1HGBH41JXMN1091866');
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Invalid VIN format. Must be 17 characters.');
        });
        it('should reject VIN with special characters', () => {
            const result = (0, validation_1.validateVIN)('1HGBH41JX-N109186');
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Invalid VIN format. Must be 17 characters.');
        });
        it('should reject VIN with spaces', () => {
            const result = (0, validation_1.validateVIN)('1HGBH41JX N109186');
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Invalid VIN format. Must be 17 characters.');
        });
        it('should reject empty string', () => {
            const result = (0, validation_1.validateVIN)('');
            expect(result.valid).toBe(false);
            expect(result.error).toBe('VIN is required');
        });
        it('should reject null', () => {
            const result = (0, validation_1.validateVIN)(null);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('VIN is required');
        });
        it('should reject undefined', () => {
            const result = (0, validation_1.validateVIN)(undefined);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('VIN is required');
        });
    });
});
describe('validateUSLocation', () => {
    describe('valid US locations', () => {
        it('should accept location in Los Angeles (continental US)', () => {
            const location = { latitude: 34.0522, longitude: -118.2437 };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(true);
            expect(result.error).toBeUndefined();
        });
        it('should accept location in New York City (continental US)', () => {
            const location = { latitude: 40.7128, longitude: -74.0060 };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(true);
        });
        it('should accept location in Miami (southern US)', () => {
            const location = { latitude: 25.7617, longitude: -80.1918 };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(true);
        });
        it('should accept location in Seattle (northern US)', () => {
            const location = { latitude: 47.6062, longitude: -122.3321 };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(true);
        });
        it('should accept location in Anchorage, Alaska', () => {
            const location = { latitude: 61.2181, longitude: -149.9003 };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(true);
        });
        it('should accept location in Honolulu, Hawaii', () => {
            const location = { latitude: 21.3099, longitude: -157.8581 };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(true);
        });
    });
    describe('invalid locations', () => {
        it('should reject location in Canada', () => {
            const location = { latitude: 43.6532, longitude: -79.3832 }; // Toronto
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Insurance only available for US domestic transport');
        });
        it('should reject location in Mexico', () => {
            const location = { latitude: 19.4326, longitude: -99.1332 }; // Mexico City
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Insurance only available for US domestic transport');
        });
        it('should reject location in Europe', () => {
            const location = { latitude: 51.5074, longitude: -0.1278 }; // London
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Insurance only available for US domestic transport');
        });
        it('should reject location in Asia', () => {
            const location = { latitude: 35.6762, longitude: 139.6503 }; // Tokyo
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Insurance only available for US domestic transport');
        });
        it('should reject null location', () => {
            const result = (0, validation_1.validateUSLocation)(null);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Location is required');
        });
        it('should reject undefined location', () => {
            const result = (0, validation_1.validateUSLocation)(undefined);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Location is required');
        });
        it('should reject location with non-numeric latitude', () => {
            const location = { latitude: 'invalid', longitude: -118.2437 };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Invalid location format');
        });
        it('should reject location with non-numeric longitude', () => {
            const location = { latitude: 34.0522, longitude: 'invalid' };
            const result = (0, validation_1.validateUSLocation)(location);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Invalid location format');
        });
    });
});
describe('validateVehicleValue', () => {
    describe('valid vehicle values', () => {
        it('should accept minimum value of $1,000', () => {
            const result = (0, validation_1.validateVehicleValue)(1000);
            expect(result.valid).toBe(true);
            expect(result.error).toBeUndefined();
        });
        it('should accept maximum value of $500,000', () => {
            const result = (0, validation_1.validateVehicleValue)(500000);
            expect(result.valid).toBe(true);
        });
        it('should accept mid-range value of $25,000', () => {
            const result = (0, validation_1.validateVehicleValue)(25000);
            expect(result.valid).toBe(true);
        });
        it('should accept value with decimals', () => {
            const result = (0, validation_1.validateVehicleValue)(25000.50);
            expect(result.valid).toBe(true);
        });
    });
    describe('invalid vehicle values', () => {
        it('should reject value below $1,000', () => {
            const result = (0, validation_1.validateVehicleValue)(999);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value must be between $1,000 and $500,000');
        });
        it('should reject value above $500,000', () => {
            const result = (0, validation_1.validateVehicleValue)(500001);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value must be between $1,000 and $500,000');
        });
        it('should reject zero value', () => {
            const result = (0, validation_1.validateVehicleValue)(0);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value must be between $1,000 and $500,000');
        });
        it('should reject negative value', () => {
            const result = (0, validation_1.validateVehicleValue)(-5000);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value must be between $1,000 and $500,000');
        });
        it('should reject null', () => {
            const result = (0, validation_1.validateVehicleValue)(null);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value is required');
        });
        it('should reject undefined', () => {
            const result = (0, validation_1.validateVehicleValue)(undefined);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value is required');
        });
        it('should reject NaN', () => {
            const result = (0, validation_1.validateVehicleValue)(NaN);
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value must be a valid number');
        });
        it('should reject string instead of number', () => {
            const result = (0, validation_1.validateVehicleValue)('25000');
            expect(result.valid).toBe(false);
            expect(result.error).toBe('Vehicle value must be a valid number');
        });
    });
});
describe('validateQuoteInputs', () => {
    const validVIN = '1HGBH41JXMN109186';
    const validPickup = { latitude: 34.0522, longitude: -118.2437 }; // LA
    const validDelivery = { latitude: 40.7128, longitude: -74.0060 }; // NYC
    const validValue = 25000;
    it('should accept all valid inputs', () => {
        const result = (0, validation_1.validateQuoteInputs)(validVIN, validPickup, validDelivery, validValue);
        expect(result.valid).toBe(true);
        expect(result.error).toBeUndefined();
    });
    it('should reject invalid VIN', () => {
        const result = (0, validation_1.validateQuoteInputs)('INVALID', validPickup, validDelivery, validValue);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('Invalid VIN format. Must be 17 characters.');
    });
    it('should reject invalid pickup location', () => {
        const invalidPickup = { latitude: 51.5074, longitude: -0.1278 }; // London
        const result = (0, validation_1.validateQuoteInputs)(validVIN, invalidPickup, validDelivery, validValue);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('Pickup location: Insurance only available for US domestic transport');
    });
    it('should reject invalid delivery location', () => {
        const invalidDelivery = { latitude: 43.6532, longitude: -79.3832 }; // Toronto
        const result = (0, validation_1.validateQuoteInputs)(validVIN, validPickup, invalidDelivery, validValue);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('Delivery location: Insurance only available for US domestic transport');
    });
    it('should reject invalid vehicle value', () => {
        const result = (0, validation_1.validateQuoteInputs)(validVIN, validPickup, validDelivery, 500);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('Vehicle value must be between $1,000 and $500,000');
    });
    it('should reject when VIN is missing', () => {
        const result = (0, validation_1.validateQuoteInputs)(null, validPickup, validDelivery, validValue);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('VIN is required');
    });
    it('should reject when pickup location is missing', () => {
        const result = (0, validation_1.validateQuoteInputs)(validVIN, null, validDelivery, validValue);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('Pickup location: Location is required');
    });
    it('should reject when delivery location is missing', () => {
        const result = (0, validation_1.validateQuoteInputs)(validVIN, validPickup, null, validValue);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('Delivery location: Location is required');
    });
    it('should reject when vehicle value is missing', () => {
        const result = (0, validation_1.validateQuoteInputs)(validVIN, validPickup, validDelivery, null);
        expect(result.valid).toBe(false);
        expect(result.error).toBe('Vehicle value is required');
    });
    it('should return first error when multiple validations fail', () => {
        const result = (0, validation_1.validateQuoteInputs)('INVALID', null, null, null);
        expect(result.valid).toBe(false);
        // Should fail on VIN first
        expect(result.error).toBe('Invalid VIN format. Must be 17 characters.');
    });
});
//# sourceMappingURL=validation.test.js.map