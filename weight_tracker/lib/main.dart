import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_functions/cloud_functions.dart';
import 'screens/home_screen.dart';
import 'screens/fbauth_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print(
        "API Key loaded: ${dotenv.env['OPENAI_API_KEY']?.substring(0, 10)}...");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    // Remove emulator for production
    // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WMF',
      theme: ThemeData(primarySwatch: Colors.red),
      home: AuthWrapper(), // Decides whether to show AuthScreen or HomeScreen
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading
        }
        if (snapshot.hasData) {
          return HomeScreen(); // If user is logged in, go to HomeScreen
        }
        return AuthScreen(); // Otherwise, go to AuthScreen
      },
    );
  }
}
