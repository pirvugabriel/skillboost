import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skillboost/screens/signup_screen.dart';
import 'package:skillboost/screens/home_screen.dart';
import 'package:skillboost/screens/login_screen.dart';
import 'package:skillboost/screens/catalog_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inițializează Firebase
  runApp(SkillBoostApp());
}

class SkillBoostApp extends StatelessWidget {
  const SkillBoostApp({super.key});
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
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/catalog': (context) => CatalogScreen(),
      },
    );
  }
}
