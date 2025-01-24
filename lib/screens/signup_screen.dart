import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isChecked = false;

  void _createAccount() {
    final email = _emailController.text.trim();

    // Validare: Verificăm dacă checkbox-ul este bifat
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to the Terms & Conditions.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validare: Verificăm dacă email-ul conține @yahoo sau @gmail
    if (!email.contains('@yahoo') && !email.contains('@gmail')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please use a valid email ending with @yahoo or @gmail.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Dacă toate validările sunt trecute, afișăm succes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF), // Turcoaz
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titlu
            Text(
              'Welcome to SkillBoost',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF29548A), // Albastru închis
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock a world of skills and opportunities.\nCreate your account today.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 32),

            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Create Account Button
            ElevatedButton(
              onPressed: _createAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF742A), // Portocaliu vibrant
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Create account',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // Checkbox and Terms
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  activeColor: const Color(0xFFFF742A),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'By signing up, you agree to our Terms & Conditions.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Already have an account?
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF29548A),
                        fontWeight: FontWeight.bold,
                      ),
                      // Adaugă acțiune la Log in
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/login');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
