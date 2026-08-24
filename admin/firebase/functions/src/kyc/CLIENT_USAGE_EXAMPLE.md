# Client-Side Usage Examples for Carrier Verification

This document provides examples of how to use the `verifyCarrier` Cloud Function from the Flutter/Dart client.

---

## Flutter/Dart Integration

### 1. Add Cloud Functions to Dependencies

In `pubspec.yaml`:
```yaml
dependencies:
  cloud_functions: ^4.0.0
```

### 2. Initialize Cloud Functions

```dart
import 'package:cloud_functions/cloud_functions.dart';

// Get Cloud Functions instance
final functions = FirebaseFunctions.instance;
```

### 3. Verify Carrier with DOT Number

```dart
Future<Map<String, dynamic>> verifyCarrierWithDOT(
  String dotNumber,
  String userId,
) async {
  try {
    final callable = functions.httpsCallable('verifyCarrier');
    
    final result = await callable.call({
      'dotNumber': dotNumber,
      'userId': userId,
    });
    
    final data = result.data as Map<String, dynamic>;
    
    if (data['success'] == true) {
      print('Verification successful!');
      print('Company: ${data['data']['companyLegalName']}');
      print('Safety Rating: ${data['data']['safetyRating']}');
      print('Authority Status: ${data['data']['authorityStatus']}');
      return data;
    } else {
      print('Verification failed: ${data['error']}');
      throw Exception(data['error']);
    }
  } on FirebaseFunctionsException catch (e) {
    print('Firebase Functions Error: ${e.code} - ${e.message}');
    rethrow;
  } catch (e) {
    print('Unexpected error: $e');
    rethrow;
  }
}
```

### 4. Verify Carrier with MC Number

```dart
Future<Map<String, dynamic>> verifyCarrierWithMC(
  String mcNumber,
  String userId,
) async {
  try {
    final callable = functions.httpsCallable('verifyCarrier');
    
    final result = await callable.call({
      'mcNumber': mcNumber,
      'userId': userId,
    });
    
    final data = result.data as Map<String, dynamic>;
    
    if (data['success'] == true) {
      print('Verification successful!');
      return data;
    } else {
      throw Exception(data['error']);
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
```

### 5. Complete Verification UI Example

```dart
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarrierVerificationPage extends StatefulWidget {
  @override
  _CarrierVerificationPageState createState() =>
      _CarrierVerificationPageState();
}

class _CarrierVerificationPageState extends State<CarrierVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _dotController = TextEditingController();
  final _mcController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _verificationResult;

  Future<void> _verifyCarrier() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Must have either DOT or MC number
    if (_dotController.text.isEmpty && _mcController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter either DOT or MC number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _verificationResult = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('verifyCarrier');

      final payload = <String, dynamic>{
        'userId': user.uid,
      };

      if (_dotController.text.isNotEmpty) {
        payload['dotNumber'] = _dotController.text;
      }
      if (_mcController.text.isNotEmpty) {
        payload['mcNumber'] = _mcController.text;
      }

      final result = await callable.call(payload);
      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        setState(() {
          _verificationResult = data['data'];
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification successful!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _errorMessage = data['error'] ?? 'Verification failed';
        });
      }
    } on FirebaseFunctionsException catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrier Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Verify your carrier credentials',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              
              // DOT Number field
              TextFormField(
                controller: _dotController,
                decoration: InputDecoration(
                  labelText: 'DOT Number',
                  hintText: 'e.g., 12345',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^\d{1,8}$').hasMatch(value)) {
                      return 'DOT number must be 1-8 digits';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // MC Number field
              TextFormField(
                controller: _mcController,
                decoration: InputDecoration(
                  labelText: 'MC Number',
                  hintText: 'e.g., 111111',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^\d{1,7}$').hasMatch(value)) {
                      return 'MC number must be 1-7 digits';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              
              // Verify button
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyCarrier,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Verify'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              
              // Error message
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ],
              
              // Verification result
              if (_verificationResult != null) ...[
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification Successful',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildResultRow('Company:', _verificationResult!['companyLegalName']),
                        _buildResultRow('Safety Rating:', _verificationResult!['safetyRating']),
                        _buildResultRow('Authority Status:', _verificationResult!['authorityStatus']),
                        _buildResultRow('Address:', _verificationResult!['address']),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dotController.dispose();
    _mcController.dispose();
    super.dispose();
  }
}
```

---

## Error Handling

### Common Error Codes

```dart
void handleVerificationError(FirebaseFunctionsException error) {
  switch (error.code) {
    case 'unauthenticated':
      // User not logged in
      print('Please log in to verify your carrier credentials');
      break;
    case 'invalid-argument':
      // Invalid DOT/MC number or missing userId
      print('Invalid verification data: ${error.message}');
      break;
    case 'permission-denied':
      // User trying to verify someone else's account
      print('You can only verify your own account');
      break;
    case 'not-found':
      // User not found in database
      print('User account not found');
      break;
    case 'failed-precondition':
      // User is not a Carrier
      print('Only Carrier accounts can be verified');
      break;
    case 'internal':
      // Server error
      print('Server error occurred. Please try again later.');
      break;
    default:
      print('Unknown error: ${error.code}');
  }
}
```

---

## Displaying Verification Status

### Check if User is Verified

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isCarrierVerified(String userId) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();
  
  final data = doc.data();
  if (data == null) return false;
  
  final verified = data['verified'] as bool? ?? false;
  final expired = data['verificationExpired'] as bool? ?? false;
  
  return verified && !expired;
}
```

### Display Verification Badge

```dart
Widget buildVerificationBadge(Map<String, dynamic> userData) {
  final verified = userData['verified'] as bool? ?? false;
  final expired = userData['verificationExpired'] as bool? ?? false;
  
  if (!verified) {
    return SizedBox.shrink();
  }
  
  if (expired) {
    return Chip(
      label: Text('Verification Expired'),
      backgroundColor: Colors.orange,
      avatar: Icon(Icons.warning, color: Colors.white),
    );
  }
  
  return Chip(
    label: Text('Verified Carrier'),
    backgroundColor: Colors.green,
    avatar: Icon(Icons.verified, color: Colors.white),
  );
}
```

---

## Testing with Mock Data

Use these test DOT/MC numbers with the Mock FMCSA Provider:

```dart
// Test data
final testCarriers = [
  {
    'dotNumber': '12345',
    'mcNumber': '111111',
    'expected': 'Test Trucking LLC',
    'safetyRating': 'Satisfactory',
  },
  {
    'dotNumber': '67890',
    'mcNumber': '222222',
    'expected': 'Fast Freight Inc',
    'safetyRating': 'Conditional',
  },
  {
    'dotNumber': '99999',
    'mcNumber': '333333',
    'expected': 'Old Transport Co',
    'safetyRating': 'Unsatisfactory',
  },
];

// Invalid test cases
final invalidTests = [
  {'dotNumber': 'ABC123', 'expectedError': 'Invalid format'},
  {'dotNumber': '88888', 'expectedError': 'Not found'},
  {'mcNumber': 'XYZ999', 'expectedError': 'Invalid format'},
];
```

---

## Best Practices

1. **Validate input on client side** before calling the function to reduce unnecessary calls
2. **Show loading indicator** during verification (can take 1-2 seconds)
3. **Handle all error cases** gracefully with user-friendly messages
4. **Cache verification status** from Firestore to avoid repeated function calls
5. **Prompt re-verification** when status shows expired
6. **Use StreamBuilder** to listen to real-time verification status changes:

```dart
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    
    final data = snapshot.data!.data() as Map<String, dynamic>?;
    final verified = data?['verified'] as bool? ?? false;
    final expired = data?['verificationExpired'] as bool? ?? false;
    
    return buildVerificationBadge(verified, expired);
  },
)
```

---

## Security Notes

- Users can only verify their own accounts
- Admin users can verify any account (for support purposes)
- Only "Carrier" type users can be verified
- All calls require authentication
- Verification data is stored securely in Firestore with proper security rules
