import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:skillboost/screens/sign/signup_screen.dart';
import 'package:skillboost/screens/home/home_screen.dart';
import 'package:skillboost/screens/sign/login_screen.dart';
import 'package:skillboost/screens/catalog/catalog_screen.dart';
import 'package:skillboost/screens/search/search_screen.dart';
import 'package:skillboost/screens/messages/messages_screen.dart';
import 'package:skillboost/screens/account/account_screen.dart';
import 'package:skillboost/screens/catalog/course_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inițializează Firebase
  runApp(SkillBoostApp());
}

class SkillBoostApp extends StatelessWidget {
  const SkillBoostApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillBoost',
      theme: ThemeData(
        primaryColor: Color(0xFF76FFFF), // Turcoaz
        scaffoldBackgroundColor: Colors.white, // Alb
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF76FFFF), // Turcoaz
          secondary: Color(0xFFFF742A), // Portocaliu vibrant
        ),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/catalog': (context) => CatalogScreen(),
        '/search': (context) => SearchScreen(),
        '/messages': (context) => MessagesScreen(),
        '/account': (context) => AccountScreen(),
        '/course': (context) => CourseScreen(),
      },
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          } else {
            return HomeScreen();
          }
        } else {
          // Ecran de încărcare
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
