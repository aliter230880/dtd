# calculateInsuranceQuote Cloud Function

## Overview

The `calculateInsuranceQuote` Cloud Function is a Firebase Callable Function that calculates insurance quotes for vehicle transport deals. It retrieves deal data from Firestore and uses the MockInsuranceProvider to generate quotes for MVP.

## Location

- **File**: `E:\AI\AI_folder\dtd\admin\firebase\functions\src\insurance\calculateQuote.ts`
- **Export**: Exported in `index.js` as `calculateInsuranceQuote`

## Function Signature

```typescript
exports.calculateInsuranceQuote = functions.https.onCall(
  async (data: CalculateQuoteRequest, context: CallableContext): Promise<CalculateQuoteResponse>
)
```

## Request Format

```typescript
interface CalculateQuoteRequest {
  dealId: string;  // Firestore document ID from 'deals' collection
}
```

### Example Request
```javascript
const result = await firebase.functions().httpsCallable('calculateInsuranceQuote')({
  dealId: 'abc123xyz'
});
```

## Response Format

```typescript
interface CalculateQuoteResponse {
  quoteId: string;        // Unique quote identifier (e.g., "MOCK-QTE-1234567890-abc")
  quoteCost: number;      // Quote cost in cents (e.g., 2500 = $25.00)
  expiresAt: string;      // ISO 8601 timestamp (e.g., "2026-08-24T12:00:00.000Z")
  provider: string;       // Provider name (e.g., "Mock Insurance Co.")
}
```

### Example Response
```json
{
  "quoteId": "MOCK-QTE-1692883200000-k3j2h1g9f",
  "quoteCost": 2500,
  "expiresAt": "2026-08-24T12:00:00.000Z",
  "provider": "Mock Insurance Co."
}
```

## Deal Data Requirements

The function expects the following fields in the Firestore `deals` collection document:

### Required Fields

| Field | Type | Description | Used As |
|-------|------|-------------|---------|
| `car_name` | string | Vehicle name | VIN (for MVP) |
| `price` | number | Vehicle price in dollars | Vehicle value |
| `pickup_lat` | number | Pickup latitude | Pickup location |
| `pickup_lng` | number | Pickup longitude | Pickup location |
| `delivery_lat` | number | Delivery latitude | Delivery location |
| `delivery_lng` | number | Delivery longitude | Delivery location |

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `pickup_location` | string | Human-readable pickup address |
| `delivery_location` | string | Human-readable delivery address |

## Authentication

The function requires the user to be authenticated. If `context.auth` is not present, the function returns:

```json
{
  "code": "unauthenticated",
  "message": "User must be authenticated to calculate insurance quotes."
}
```

## Error Handling

### Invalid Argument Errors

**Missing dealId**:
```json
{
  "code": "invalid-argument",
  "message": "dealId is required and must be a string."
}
```

**Invalid VIN (from InsuranceQuoteError)**:
```json
{
  "code": "invalid-argument",
  "message": "Invalid VIN. Must be 17 alphanumeric characters.",
  "details": {
    "code": "validation",
    "details": { "vin": "invalid-vin" }
  }
}
```

### Not Found Errors

**Deal not found**:
```json
{
  "code": "not-found",
  "message": "Deal with ID abc123xyz not found."
}
```

### Failed Precondition Errors

**Missing car_name**:
```json
{
  "code": "failed-precondition",
  "message": "Deal is missing car_name (used as VIN for MVP)."
}
```

**Missing or invalid price**:
```json
{
  "code": "failed-precondition",
  "message": "Deal is missing valid price (vehicle value)."
}
```

**Missing pickup coordinates**:
```json
{
  "code": "failed-precondition",
  "message": "Deal is missing pickup location coordinates (pickup_lat, pickup_lng)."
}
```

**Missing delivery coordinates**:
```json
{
  "code": "failed-precondition",
  "message": "Deal is missing delivery location coordinates (delivery_lat, delivery_lng)."
}
```

### Internal Errors

**Unexpected errors**:
```json
{
  "code": "internal",
  "message": "An unexpected error occurred while calculating the insurance quote.",
  "details": {
    "error": "Error message details"
  }
}
```

## Quote Calculation Formula

The MockInsuranceProvider uses the following formula:

```
baseCost = ($0.02 per mile × distance) + (0.5% × vehicle value)
quoteCost = baseCost (in cents)
```

Distance is calculated using the Haversine formula from pickup/delivery coordinates.

## Quote Expiration

Quotes expire **24 hours** after generation. The `expiresAt` field contains the ISO 8601 timestamp.

## Deployment

### 1. Compile TypeScript

```bash
cd E:\AI\AI_folder\dtd\admin\firebase\functions
npx tsc
```

### 2. Deploy to Firebase

Deploy only this function:
```bash
firebase deploy --only functions:calculateInsuranceQuote
```

Or deploy all functions:
```bash
firebase deploy --only functions
```

### 3. Verify Deployment

Check Firebase Console → Functions to confirm deployment status.

## Testing

### Manual Test from Client

```javascript
// Flutter (Dart)
final callable = FirebaseFunctions.instance.httpsCallable('calculateInsuranceQuote');
final result = await callable.call({
  'dealId': 'test-deal-id-123'
});

print('Quote ID: ${result.data['quoteId']}');
print('Quote Cost: \$${result.data['quoteCost'] / 100}');
print('Expires At: ${result.data['expiresAt']}');
print('Provider: ${result.data['provider']}');
```

```javascript
// JavaScript (Web)
const calculateQuote = firebase.functions().httpsCallable('calculateInsuranceQuote');
const result = await calculateQuote({ dealId: 'test-deal-id-123' });

console.log('Quote ID:', result.data.quoteId);
console.log('Quote Cost: $' + (result.data.quoteCost / 100).toFixed(2));
console.log('Expires At:', result.data.expiresAt);
console.log('Provider:', result.data.provider);
```

### Test Deal Data

Create a test deal in Firestore with:

```json
{
  "car_name": "1HGBH41JXMN109186",
  "price": 25000,
  "pickup_lat": 34.0522,
  "pickup_lng": -118.2437,
  "pickup_location": "Los Angeles, CA",
  "delivery_lat": 40.7128,
  "delivery_lng": -74.0060,
  "delivery_location": "New York, NY"
}
```

Expected quote cost: ~$27.66 (distance ~2,800 miles, vehicle value $25,000)

## Integration with Other Functions

This function is part of the insurance workflow:

1. **calculateInsuranceQuote** (this function) - Get quote
2. **purchaseInsurance** (future) - Purchase policy using quote ID
3. **getInsurancePolicy** (future) - Retrieve policy details

## MVP Notes

- Uses `car_name` as VIN (not a real VIN format for MVP)
- Uses MockInsuranceProvider for instant quotes (no external API)
- Quote validation and purchase flow will be implemented in separate functions

## Requirements Covered

- **3.3**: calculateInsuranceQuote Cloud Function implementation
- **2.2**: Mock provider integration for MVP testing
- **3.2**: Provider interface abstraction

## Next Steps

1. Implement `purchaseInsurance` Cloud Function (Task 4.1)
2. Add Flutter UI to display quotes
3. Replace MockInsuranceProvider with real insurance API provider
4. Add quote history and management features
