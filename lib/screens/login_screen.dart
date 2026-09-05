import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';
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

  // Fast2SMS API Key
  static const String _fast2SmsApiKey =
      "tjsgE0FMaP9fiX2l3bLKyuSNvA8I6CGmoD5RBZcqrVzhkHwQxpMjBNpAxrCUPTFlkdZLnigoQWc9ztRO";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Fast2SMS OTP फ़ंक्शन (डेवलपमेंट/टेस्टिंग बाईपास मोड)
  Future<String?> _sendFast2Sms(String phone) async {
    // 💡 फ़्री टेस्टिंग OTP - Fast2SMS का बैलेंस खर्च नहीं होगा
    const freeTestOtp = "123456";
    debugPrint("Development OTP: $freeTestOtp");
    return freeTestOtp;

    /*
    // असली लाइव लॉन्च के समय नीचे वाला कोड इस्तेमाल करें:
    final generatedOtp = (Random().nextInt(900000) + 100000).toString();
    final messageText = "AstroSolution verification code is: $generatedOtp";
    final url = Uri.parse(
      "https://www.fast2sms.com/dev/bulkV2?authorization=$_fast2SmsApiKey&route=q&message=${Uri.encodeComponent(messageText)}&language=english&flash=0&numbers=$phone",
    );

    try {
      final response = await http.get(url);
      debugPrint("Fast2SMS Status: ${response.statusCode}");
      debugPrint("Fast2SMS Response: ${response.body}");

      final data = jsonDecode(response.body);
      if (data['return'] == true) {
        return generatedOtp;
      } else {
        return generatedOtp;
      }
    } catch (e) {
      return generatedOtp;
    }
    */
  }

  // पुराने यूज़र के लिए MPIN डायलॉग
  void _showPinDialog(String phone, String correctPin, String userName) {
    final TextEditingController pinInputController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome Back, $userName!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your 4-digit security PIN for +91 $phone',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: pinInputController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••',
                  hintStyle: const TextStyle(letterSpacing: 10, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFFF8F00), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (pinInputController.text.trim() == correctPin) {
                      Navigator.pop(context); // क्लोज डायलॉग
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(userName: userName),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Incorrect PIN! Please try again.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8F00),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    setState(() => _isLoading = true);

    try {
      // 1. Supabase में चेक करें कि क्या यूज़र का प्रोफाइल और PIN मौजूद है
      final existingUser = await supabase
          .from('profiles')
          .select('name, mpin, dob, status')
          .eq('phone', phone)
          .maybeSingle();

      setState(() => _isLoading = false);

      // 🚫 2. अगर यूज़र डेटाबेस में मिला है, तो उसका BAN STATUS चेक करें
      if (existingUser != null) {
        final userStatus = existingUser['status'] ?? 'Active';

        if (userStatus == 'Permanently Banned') {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your account has been permanently banned by Admin! 🚫'),
              backgroundColor: Colors.red,
            ),
          );
          return; // यहीं रोक दें, आगे लॉगिन नहीं होने देगा
        }

        if (userStatus == 'Temporarily Banned') {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your account is temporarily suspended. Please contact support.'),
              backgroundColor: Colors.orange,
            ),
          );
          return; // यहीं रोक दें
        }
      }

      // 3. अगर पुराना यूज़र है और उसका PIN सेट है -> डायलॉग खोलें
      if (existingUser != null &&
          existingUser['mpin'] != null &&
          existingUser['mpin'].toString().isNotEmpty) {
        final userName = existingUser['name'] ?? 'User';
        _showPinDialog(phone, existingUser['mpin'].toString(), userName);
        return;
      }

      // 4. नया यूज़र है तो OTP जनरेट करें
      setState(() => _isLoading = true);
      final sentOtp = await _sendFast2Sms(phone);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (sentOtp == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SMS भेजने में समस्या आई।"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP: 123456 दर्ज करें (Test Mode)"),
          backgroundColor: Colors.green,
        ),
      );

      // 5. OTP Screen पर नेविगेट करें
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phoneNumber: phone,
            serverOtp: sentOtp,
          ),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 24),
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
                  'We will verify your number or login instantly with PIN.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
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
                            'CONTINUE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 24),

                // ✨ यहाँ आपकी सुंदर रथ वाली इमेज जोड़ी गई है (नीचे की तरफ)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/chariot_bg.png', // यहाँ अपनी इमेज का पाथ दें
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}