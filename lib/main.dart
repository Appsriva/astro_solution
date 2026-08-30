import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Apni nayi splash screen wali file ko import kiya
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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