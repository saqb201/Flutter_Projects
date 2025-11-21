import axios from 'axios';

const API_URL = 'https://recipebackend-five.vercel.app';

// Test data
const testUser = {
  name: 'Minhal',
  email: 'valijej371@aikunkun.com', // Change this to your test email
  password: 'testPassword123'
};

async function testEmailSending() {
  try {
    console.log('🧪 Starting Email Test...\n');
    
    // Test 1: Check if API is running
    console.log('1️⃣  Testing API Health...');
    const healthCheck = await axios.get(`${API_URL}/api/health`);
    console.log('✅ API is running:', healthCheck.data);
    console.log('');

    // Test 2: Register a new user (which should trigger email)
    console.log('2️⃣  Registering new user to trigger verification email...');
    console.log(`📧 Sending to: ${testUser.email}`);
    
    const registerResponse = await axios.post(`${API_URL}/api/auth/register`, {
      name: testUser.name,
      email: testUser.email,
      password: testUser.password
    });

    console.log('✅ User registered successfully!');
    console.log('Response:', registerResponse.data);
    console.log('');

    // Test 3: Display OTP
    console.log('3️⃣  OTP Verification');
    console.log('🔐 Your OTP:', registerResponse.data.otp);
    console.log('⏱️  OTP expires in 10 minutes');
    console.log('');
    
    // Test 4: Check if email was sent
    console.log('4️⃣  Email Verification Status');
    console.log('📧 Check your email inbox for OTP email');
    console.log('⏱️  Email should arrive within 30 seconds');
    console.log('');
    
    console.log('✨ Test completed!');
    console.log('');
    console.log('📝 Next Steps:');
    console.log('   1. Check your email inbox for the OTP');
    console.log('   2. Use the OTP to verify your account');
    console.log('   3. If email doesn\'t arrive:');
    console.log('      - Check spam/junk folder');
    console.log('      - Verify environment variables are set in Vercel dashboard');
    console.log('      - Check Vercel logs for email sending errors');

  } catch (error) {
    console.error('❌ Test failed!');
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Error:', error.response.data);
      console.error('Full Response:', JSON.stringify(error.response.data, null, 2));
    } else if (error.request) {
      console.error('No response received:', error.request);
    } else {
      console.error('Error:', error.message);
    }
  }
}

// Run the test
testEmailSending();
