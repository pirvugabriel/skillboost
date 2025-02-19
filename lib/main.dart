import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:skillboost/screens/sign/discover.dart';
import 'package:skillboost/screens/sign/signup_screen.dart';
import 'package:skillboost/screens/sign/t_c.dart';
import 'package:skillboost/screens/sign/login_screen.dart';
import 'package:skillboost/screens/home/home_screen.dart';
import 'package:skillboost/screens/catalog/catalog_screen.dart';
import 'package:skillboost/screens/search/search_screen.dart';
import 'package:skillboost/screens/messages/messages_screen.dart';
import 'package:skillboost/screens/account/account_screen.dart';
import 'package:skillboost/screens/catalog/course_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SkillBoostApp());
}

class SkillBoostApp extends StatelessWidget {
  const SkillBoostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillBoost',
      theme: ThemeData(
        primaryColor: const Color(0xFF76FFFF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF76FFFF),
          secondary: const Color(0xFFFF742A),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF29548A)),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF29548A)),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
      home: const AuthenticationWrapper(),
      routes: {
        '/discover': (context) => const DiscoverScreen(),
        '/signup': (context) => const SignupScreen(),
        '/terms': (context) => const TermsConditionsScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/catalog': (context) => const CatalogScreen(),
        '/search': (context) => const SearchScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/account': (context) => const AccountScreen(),
        '/course': (context) => const CourseScreen(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  Future<void> _addUserToFirestore(User user) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot userDoc = await userRef.get();
    if (!userDoc.exists) {
      await userRef.set({
        'email': user.email,
        'nickname': user.displayName ?? "New User",
        'points': 0,
        'purchased_courses': [],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final User? user = snapshot.data;

        if (user != null) {
          // Mutăm adăugarea utilizatorului aici pentru a nu afecta rebuild-ul
          Future.microtask(() => _addUserToFirestore(user));
          return const HomeScreen();
        } else {
          return const DiscoverScreen();
        }
      },
    );
  }
}
