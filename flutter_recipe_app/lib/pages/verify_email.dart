import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyEmailPage extends StatefulWidget {
  final String? token;

  const VerifyEmailPage({Key? key, this.token}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isLoading = true;
  bool _isSuccess = false;
  String _message = 'Verifying your email...';

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      _verifyEmail(widget.token!);
    } else {
      setState(() {
        _isLoading = false;
        _message = 'Invalid verification link';
      });
    }
  }

  Future<void> _verifyEmail(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/auth/verify-email?token=$token'),
      );

      final data = jsonDecode(response.body);

      setState(() {
        _isLoading = false;
        _isSuccess = data['success'] == true;
        _message = data['message'] ?? 'Verification completed';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Error verifying email: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Email')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isLoading
                    ? Icons.email
                    : _isSuccess
                    ? Icons.verified
                    : Icons.error,
                size: 80,
                color: _isLoading
                    ? Colors.orange
                    : _isSuccess
                    ? Colors.green
                    : Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                _isLoading
                    ? 'Verifying...'
                    : _isSuccess
                    ? 'Email Verified!'
                    : 'Verification Failed',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isLoading
                      ? Colors.orange
                      : _isSuccess
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              SizedBox(height: 30),
              if (!_isLoading)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Go to Login'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
