import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      // 1. नोटिफिकेशन की परमिशन मांगना (iOS और Web के लिए)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notification permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }

      // 2. FCM टोकन जनरेट करना (वेब के लिए vapidKey और मोबाइल के लिए नॉर्मल getToken)
      String? token;
      if (kIsWeb) {
        token = await _firebaseMessaging.getToken(
          vapidKey: "YOUR_WEB_VAPID_KEY_HERE_IF_REQUIRED",
        );
      } else {
        token = await _firebaseMessaging.getToken();
      }

      debugPrint("FCM Registration Token: $token");

      if (token != null) {
        await _saveTokenToSupabase(token);
      }

      // 3. टोकन रिफ्रेश होने पर ऑटोमैटिक अपडेट करना
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _saveTokenToSupabase(newToken);
      });

      // 4. Foreground में मैसेज रिसीव होने पर सुनना
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        if (message.notification != null) {
          debugPrint('Message Title: ${message.notification?.title}');
          debugPrint('Message Body: ${message.notification?.body}');
          
          // यहाँ चाहें तो आप लोकल नोटिफिकेशन शो करने का या स्टेट रिफ्रेश करने का लॉजिक जोड़ सकते हैं
        }
      });

    } catch (e) {
      debugPrint("Error initializing NotificationService: $e");
    }
  }

  Future<void> _saveTokenToSupabase(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;

      // device_tokens टेबल में टोकन सेव या अपडेट करना
      await supabase.from('device_tokens').upsert({
        'fcm_token': token,
        'user_id': currentUser?.id,
        'role': 'user',
        'app_type': 'user_app',
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'fcm_token');

      debugPrint("FCM Token successfully saved to Supabase!");
    } catch (e) {
      debugPrint("Error saving FCM token to Supabase: $e");
    }
  }
}