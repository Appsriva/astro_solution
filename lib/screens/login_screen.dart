import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    setState(() => _isLoading = true);

    try {
      // Supabase Phone OTP Trigger (+91 Country Code)
      await supabase.auth.signInWithOtp(
        phone: '+91$phone',
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(phoneNumber: phone),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("त्रुटि: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF8F00).withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.phone_android_rounded,
                      size: 48,
                      color: Color(0xFFFF8F00),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Enter your Phone Number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF212121),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We will send you a 6-digit OTP code to verify your account.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Text(
                            '🇮🇳 +91',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText: 'Enter 10 digit number',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.trim().length != 10) {
                              return 'Enter a valid 10-digit number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8F00),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'GET OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By continuing, you agree to our ',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      children: const [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Color(0xFFFF8F00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFFFF8F00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}