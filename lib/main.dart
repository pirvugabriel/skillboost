import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:skillboost/screens/signup_screen.dart';
import 'package:skillboost/screens/home_screen.dart';
import 'package:skillboost/screens/login_screen.dart';
import 'package:skillboost/screens/catalog_screen.dart';
import 'package:skillboost/screens/search_screen.dart';
import 'package:skillboost/screens/messages_screen.dart';
import 'package:skillboost/screens/account_screen.dart';
import 'package:skillboost/screens/course_screen.dart';
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
      navigatorObservers: [observer], // Adăugat pentru Firebase Analytics
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/catalog': (context) => CatalogScreen(),
        '/search': (context) => SearchScreen(),
        '/messages': (context) => MessagesScreen(),
        '/account': (context) => AccountScreen(),
        '/course': (context) => CourseScreen()
      },
    );
  }
}
