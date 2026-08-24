/**
 * Simple test to verify calculateQuote function structure
 * Run with: node test-calculateQuote.js
 */

console.log('Testing calculateInsuranceQuote Cloud Function...\n');

// Verify the function file exists and can be required
try {
  const fs = require('fs');
  const path = require('path');
  
  const functionPath = path.join(__dirname, 'src', 'insurance', 'calculateQuote.ts');
  
  if (fs.existsSync(functionPath)) {
    console.log('✓ Function file exists at:', functionPath);
    
    // Read and verify basic structure
    const content = fs.readFileSync(functionPath, 'utf8');
    
    const checks = [
      { name: 'Export declaration', pattern: /export const calculateInsuranceQuote/ },
      { name: 'functions.https.onCall', pattern: /functions\.https\.onCall/ },
      { name: 'Authentication check', pattern: /context\.auth/ },
      { name: 'dealId validation', pattern: /data\.dealId/ },
      { name: 'Firestore access', pattern: /admin\.firestore\(\)/ },
      { name: 'MockInsuranceProvider import', pattern: /import.*MockInsuranceProvider/ },
      { name: 'getQuote call', pattern: /provider\.getQuote/ },
      { name: 'Error handling', pattern: /catch.*error/ },
    ];
    
    console.log('\nStructure checks:');
    let passed = 0;
    checks.forEach(check => {
      if (check.pattern.test(content)) {
        console.log(`  ✓ ${check.name}`);
        passed++;
      } else {
        console.log(`  ✗ ${check.name}`);
      }
    });
    
    console.log(`\nPassed: ${passed}/${checks.length} checks`);
    
    if (passed === checks.length) {
      console.log('\n✓ All structure checks passed!');
      console.log('\nNext steps:');
      console.log('1. Compile TypeScript: npx tsc');
      console.log('2. Deploy to Firebase: firebase deploy --only functions:calculateInsuranceQuote');
      console.log('3. Test from client app');
      process.exit(0);
    } else {
      console.log('\n✗ Some structure checks failed');
      process.exit(1);
    }
    
  } else {
    console.log('✗ Function file not found at:', functionPath);
    process.exit(1);
  }
  
} catch (error) {
  console.error('✗ Error during test:', error.message);
  process.exit(1);
}
