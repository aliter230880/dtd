/**
 * Manual Test Script for Mock FMCSA Provider
 * 
 * Quick way to test the mock FMCSA provider without running full test suite.
 * Run with: node manual-test.js (from the kyc directory)
 * 
 * Note: This script uses compiled .js files from lib/ directory.
 * Run `npm run build` in functions/ directory first if needed.
 */

const { MockFmcsaProvider } = require('../../lib/kyc/mock-fmcsa-provider');

async function testMockFmcsaProvider() {
  console.log('='.repeat(60));
  console.log('Mock FMCSA Provider - Manual Test');
  console.log('='.repeat(60));
  console.log();

  const provider = new MockFmcsaProvider();
  console.log(`Provider: ${provider.getName()}`);
  console.log();

  // Test 1: Valid DOT number - Satisfactory/Active
  console.log('Test 1: Verify DOT 12345 (Test Trucking LLC - Should be Satisfactory/Active)');
  console.log('-'.repeat(60));
  try {
    const result1 = await provider.verifyDOT('12345');
    console.log('Result:', JSON.stringify(result1, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
  console.log();

  // Test 2: Valid DOT number - Conditional/Active
  console.log('Test 2: Verify DOT 67890 (Fast Freight Inc - Should be Conditional/Active)');
  console.log('-'.repeat(60));
  try {
    const result2 = await provider.verifyDOT('67890');
    console.log('Result:', JSON.stringify(result2, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
  console.log();

  // Test 3: Valid DOT number - Unsatisfactory/Inactive
  console.log('Test 3: Verify DOT 99999 (Old Transport Co - Should be Unsatisfactory/Inactive)');
  console.log('-'.repeat(60));
  try {
    const result3 = await provider.verifyDOT('99999');
    console.log('Result:', JSON.stringify(result3, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
  console.log();

  // Test 4: Non-existent DOT number
  console.log('Test 4: Verify DOT 00000 (Should not be found)');
  console.log('-'.repeat(60));
  try {
    const result4 = await provider.verifyDOT('00000');
    console.log('Result:', JSON.stringify(result4, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
  console.log();

  // Test 5: Invalid DOT number format
  console.log('Test 5: Verify DOT "ABC123" (Should fail format validation)');
  console.log('-'.repeat(60));
  try {
    const result5 = await provider.verifyDOT('ABC123');
    console.log('Result:', JSON.stringify(result5, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
  console.log();

  // Test 6: Valid MC number
  console.log('Test 6: Verify MC 222222 (Fast Freight Inc - Via MC number)');
  console.log('-'.repeat(60));
  try {
    const result6 = await provider.verifyMC('222222');
    console.log('Result:', JSON.stringify(result6, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
  console.log();

  // Test 7: Non-existent MC number
  console.log('Test 7: Verify MC 999999 (Should not be found)');
  console.log('-'.repeat(60));
  try {
    const result7 = await provider.verifyMC('999999');
    console.log('Result:', JSON.stringify(result7, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
  console.log();

  console.log('='.repeat(60));
  console.log('All tests completed!');
  console.log('='.repeat(60));
}

// Run tests
testMockFmcsaProvider().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
