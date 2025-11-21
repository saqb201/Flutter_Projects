import dotenv from 'dotenv';

dotenv.config();

console.log('🔍 Environment Variables Check:\n');
console.log('MONGODB_URI:', process.env.MONGODB_URI ? '✅ Set' : '❌ Not set');
console.log('JWT_SECRET:', process.env.JWT_SECRET ? '✅ Set' : '❌ Not set');
console.log('EMAIL_USER:', process.env.EMAIL_USER ? '✅ Set' : '❌ Not set');
console.log('EMAIL_PASS:', process.env.EMAIL_PASS ? '✅ Set' : '❌ Not set');
console.log('CLIENT_URL:', process.env.CLIENT_URL ? '✅ Set' : '❌ Not set');
console.log('PORT:', process.env.PORT ? '✅ Set' : '❌ Not set');
console.log('\n📝 Values:');
console.log('MONGODB_URI:', process.env.MONGODB_URI);
console.log('EMAIL_USER:', process.env.EMAIL_USER);
console.log('CLIENT_URL:', process.env.CLIENT_URL);
