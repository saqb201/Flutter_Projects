import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Send OTP to phone number
  Future<void> sendPhoneOTP(String phone) async {
    try {
      await supabase.auth.signInWithOtp(phone: phone);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  // Verify the received OTP
  Future<void> verifyOTP({required String phone, required String otp}) async {
    try {
      await supabase.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
