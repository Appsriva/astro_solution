import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb चेक करने के लिए
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart'; // 🌟 Firebase Core इम्पोर्ट किया गया
import 'notification_service.dart'; // 🌟 नोटिफिकेशन सर्विस इम्पोर्ट की गई

// 🌐 वेब पर iframe और व्यू फैक्ट्री रजिस्टर करने के लिए (Flutter Web Only)
import 'dart:ui_web' as ui_web; 
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// Apni nayi splash screen wali file ko import kiya
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌟 1. Firebase को इनिशियलाइज करें (मोबाइल और वेब दोनों के लिए जरूरी)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  // 🌟 2. नोटिफिकेशन सर्विस शुरू करें (FCM टोकन और लिसनर सेटअप)
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint("NotificationService initialization error: $e");
  }

  // 🌟 Flutter Web के लिए YouTube Iframe View Factory रजिस्टर करना अनिवार्य है
  if (kIsWeb) {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'iframe-element-matcher',
      (int viewId) => html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%',
    );
  }

  // Supabase Database Connection
  await Supabase.initialize(
    url: 'https://kcabjqvjgnonuhplepkq.supabase.co',
    anonKey: 'sb_publishable_MjE4ZgaohdZf8D-Qj9FJWQ_0dth6FtG',
  );

  runApp(const MyApp());
}

// Global Supabase Client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Kone ka 'Debug' banner hatane ke liye
      title: 'Astro Soluation',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      // App khulte hi sabse pehle SplashScreen show hogi
      home: const SplashScreen(),
    );
  }
}