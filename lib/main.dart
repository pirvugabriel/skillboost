import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:skillboost/screens/sign/discover.dart';
import 'package:skillboost/screens/sign/signup_screen.dart';
import 'package:skillboost/screens/sign/login_screen.dart';
import 'package:skillboost/screens/home/home_screen.dart';
import 'package:skillboost/screens/catalog/catalog_screen.dart';
import 'package:skillboost/screens/search/search_screen.dart';
import 'package:skillboost/screens/messages/messages_screen.dart';
import 'package:skillboost/screens/account/account_screen.dart';
import 'package:skillboost/screens/catalog/course_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Inițializează Firebase
  runApp(const SkillBoostApp());
}

class SkillBoostApp extends StatelessWidget {
  const SkillBoostApp({super.key});
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillBoost',
      theme: ThemeData(
        primaryColor: const Color(0xFF76FFFF),  // Turcoaz
        scaffoldBackgroundColor: Colors.white,  // Alb
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF76FFFF),  // Turcoaz
          secondary: const Color(0xFFFF742A),  // Portocaliu vibrant
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF29548A)),  // Echivalent pentru headline1
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF29548A)),  // Echivalent pentru headline2
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),  // Echivalent pentru bodyText1
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),  // Echivalent pentru bodyText2
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),  // Echivalent pentru button
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF742A),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      navigatorObservers: [observer],
      initialRoute: '/',
      routes: {
        '/discover': (context) => const DiscoverScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/catalog': (context) => const CatalogScreen(),
        '/search': (context) => const SearchScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/account': (context) => const AccountScreen(),
        '/course': (context) => const CourseScreen(),
      },
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const DiscoverScreen();  // Dacă utilizatorul nu e logat, se întoarce la prima pagină
          } else {
            return const HomeScreen();  // Navigăm la Home dacă e autentificat
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
