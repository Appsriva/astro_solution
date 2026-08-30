import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Fast2SmsService {
  static const String _apiKey =
      "tjsgE0FMaP9fiX2l3bLKyuSNvA8I6CGmoD5RBZcqrVzhkHwQxpMjBNpAxrCUPTFlkdZLnigoQWc9ztRO";

  // 6-digit random OTP बनाकर SMS भेजेगा
  static Future<String?> sendOtp(String mobileNumber) async {
    // 6-digit OTP जनरेट करें
    final otp = (Random().nextInt(900000) + 100000).toString();

    // Fast2SMS Quick OTP URL
    final url = Uri.parse(
      "https://www.fast2sms.com/dev/bulkV2?authorization=$_apiKey&variables_values=$otp&route=otp&numbers=$mobileNumber",
    );

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['return'] == true) {
        return otp; // OTP सफ़लतापूर्वक चला गया
      } else {
        print("Fast2SMS Error: ${data['message']}");
        return null;
      }
    } catch (e) {
      print("Network Error: $e");
      return null;
    }
  }
}