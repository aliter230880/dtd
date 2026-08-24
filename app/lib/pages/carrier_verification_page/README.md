# Carrier Verification Page

## Overview
This page allows carriers to verify their status by entering their DOT (Department of Transportation) or MC (Motor Carrier) numbers.

## Files
- `carrier_verification_page_widget.dart` - Main UI widget
- `carrier_verification_page_model.dart` - State management model
- `carrier_verification_page.dart` - Export file

## Features
1. **DOT Number Input** - Text field for 8-digit DOT number (numeric only)
2. **MC Number Input** - Text field for 7-digit MC number (numeric only)
3. **Validation** - At least one field must be filled
4. **Cloud Function Integration** - Calls `verifyCarrier` Cloud Function
5. **Loading State** - Shows spinner while verifying
6. **Success/Error Messages** - User feedback via SnackBar
7. **Auto-navigation** - Returns to previous screen on success

## Usage

### Navigation
To navigate to this page from another widget:
```dart
context.pushNamed('CarrierVerificationPage');
```

Or programmatically:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CarrierVerificationPageWidget(),
  ),
);
```

### Cloud Function Expected Format
The page calls the Cloud Function with the following payload:
```javascript
{
  dotNumber: "12345678" | null,  // Optional, max 8 digits
  mcNumber: "1234567" | null,     // Optional, max 7 digits
  userId: "user-firebase-uid"     // Current user's UID
}
```

At least one of `dotNumber` or `mcNumber` must be provided.

## Localization Keys
Add these keys to your localization files:

```
carrier_verification_title: "Верификация перевозчика"
carrier_verification_desc: "Введите DOT или MC номер для верификации вашего статуса перевозчика. Необходимо заполнить хотя бы одно поле."
dot_number_label: "DOT номер"
dot_number_hint: "Например: 12345678"
mc_number_label: "MC номер"
mc_number_hint: "Например: 1234567"
verify_button: "Проверить"
verifying_text: "Проверка..."
validation_error: "Необходимо заполнить хотя бы одно поле"
verification_success: "Верификация успешна! ✓"
verification_error: "Ошибка верификации. Проверьте введенные данные."
```

## Styling
The page uses FlutterFlow theme system:
- `FlutterFlowTheme.of(context).primaryBackground` - Background color
- `FlutterFlowTheme.of(context).secondaryBackground` - Card/input background
- `FlutterFlowTheme.of(context).primary` - Primary button color
- `FlutterFlowTheme.of(context).error` - Error color
- Inter font family (project default)

## Dependencies
- `cloud_functions: 4.6.7` - Already in pubspec.yaml
- Firebase Authentication - For `currentUserUid`
- FlutterFlow utilities - For theme and navigation

## Notes
- Input fields accept only numeric characters
- DOT: max 8 digits
- MC: max 7 digits
- Character counter shown below input fields
- Follows FlutterFlow/DTD project conventions
