import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';
import 'profile_setup_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 6-digit OTP'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Supabase OTP Verification
      final AuthResponse res = await supabase.auth.verifyOTP(
        phone: '+91${widget.phoneNumber}',
        token: otp,
        type: OtpType.sms,
      );

      final user = res.user;

      if (user != null) {
        // 2. Check if Profile already exists and has a custom name
        final existingProfile = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (existingProfile != null &&
            existingProfile['name'] != null &&
            existingProfile['name'] != 'यजमान' &&
            existingProfile['dob'] != null) {
          // Existing user with completed profile -> Direct Home Screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(userName: existingProfile['name']),
            ),
            (route) => false,
          );
        } else {
          // First time user or incomplete profile -> Profile Setup Screen
          if (existingProfile == null) {
            await supabase.from('profiles').insert({
              'id': user.id,
              'phone': widget.phoneNumber,
              'wallet_balance': 50.00,
            });
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfileSetupScreen(phoneNumber: widget.phoneNumber),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification Failed: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    try {
      await supabase.auth.signInWithOtp(
        phone: '+91${widget.phoneNumber}',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New OTP sent!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF8F00).withValues(alpha: 0.12),
                  ),
                  child: const Icon(
                    Icons.mark_email_read_rounded,
                    size: 46,
                    color: Color(0xFFFF8F00),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Verify Phone Number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: 'Enter the 6-digit OTP code sent to ',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                  children: [
                    TextSpan(
                      text: '+91 ${widget.phoneNumber}',
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 46,
                    height: 54,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF8F00),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (index == 5 && value.isNotEmpty) {
                          _verifyOtp();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
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
                          'SUBMIT & CONTINUE',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: _resendOtp,
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        color: Color(0xFFFF8F00),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}