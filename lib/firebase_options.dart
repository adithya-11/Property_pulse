import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FcmTokenApp());
}

/// APP ROOT
class FcmTokenApp extends StatelessWidget {
  const FcmTokenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FCM Token Viewer',

      // 🌸 Modern PINK Theme
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A0F1F), // deep purple-pink
        primaryColor: const Color(0xFFFF4FA8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF4FA8),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          elevation: 8,
          shadowColor: Color(0xFFFF4FA8),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFFFFC8E2), // soft pink text
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(Color(0xFFFF4FA8)),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            elevation: MaterialStatePropertyAll(6),
          ),
        ),
      ),

      home: const TokenScreen(),
    );
  }
}

/// TOKEN SCREEN
class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  String? _fcmToken = "Fetching device token...";

  @override
  void initState() {
    super.initState();
    _getFcmToken();
  }

  Future<void> _getFcmToken() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    print('🔔 Notification permission: ${settings.authorizationStatus}');

    String? token = await FirebaseMessaging.instance.getToken();

    setState(() {
      _fcmToken = token ?? "Unable to fetch token. Check Firebase setup.";
    });

    print('📌 FCM Token: $_fcmToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Messaging Token")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1830),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  color: Color(0x66FF4FA8),
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: SelectableText(
              _fcmToken ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                height: 1.5,
                color: Color(0xFFFFD7EA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}