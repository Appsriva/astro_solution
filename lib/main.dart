import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb चेक करने के लिए
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart'; // 🌟 Firebase Core इम्पोर्ट किया गया
import 'notification_service.dart'; // 🌟 नोटिफिकेशन सर्विस इम्पोर्ट की गई
import 'package:firebase_messaging/firebase_messaging.dart';

// 🌐 वेब पर iframe और व्यू फैक्ट्री रजिस्टर करने के लिए (Flutter Web Only)
import 'dart:ui_web' as ui_web; 
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// Apni nayi splash screen wali file ko import kiya
import 'screens/splash_screen.dart';

// ग्लोबल नेविगेटर की ताकि बैकग्राउंड या टर्मिनेटेड स्टेट से सीधे नेविगेट किया जा सके
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌟 1. Firebase को इनिशियलाइज करें (डुप्लीकेट क्रैश से सुरक्षित चेक के साथ)
  try {
    if (Firebase.apps.isEmpty) {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyAKcsTikyo_GhUZBWVf3uc918iS3QnQNdQ",
            appId: "1:924726132588:web:080e16fb3568f0fdd5bd49",
            messagingSenderId: "924726132588",
            projectId: "astro-solutions-545de",
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
    }
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  // 🌟 2. नोटिफिकेशन सर्विस शुरू करें (FCM टोकन और लिसनर सेटअप)
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint("NotificationService initialization error: $e");
  }

  // 🌟 3. बैकग्राउंड और टर्मिनेटेड स्टेट में डीप-लिंक क्लिक लिसनर सेटअप
  setupFirebaseBackgroundHandlers();

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
      navigatorKey: navigatorKey, // नेविगेटर की अटैच की गई
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

// 🔔 बैकग्राउंड और टर्मिनेटेड नोटिफिकेशन्स के लिए डीप-लिंक रीडायरेक्शन हैंडलर
void setupFirebaseBackgroundHandlers() {
  // जब ऐप बैकग्राउंड में हो और यूजर नोटिफिकेशन पर क्लिक करे
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    String? deepLink = message.data['deep_link'];
    executeDeepLinkRedirection(deepLink);
  });

  // जब ऐप पूरी तरह बंद (Terminated) हो और नोटिफिकेशन पर क्लिक करके खोली जाए
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      String? deepLink = message.data['deep_link'];
      executeDeepLinkRedirection(deepLink);
    }
  });
}

// 🚀 स्क्रीन रीडायरेक्शन लॉजिक
void executeDeepLinkRedirection(String? deepLink) {
  if (deepLink == null) return;
  
  final context = navigatorKey.currentContext;
  if (context == null) return;

  switch (deepLink) {
    case 'chat':
      break;
    case 'call':
      break;
    case 'live':
      break;
    case 'wallet':
      break;
    case 'pooja':
      break;
    default:
      break;
  }
}