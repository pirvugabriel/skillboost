import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF742A), // Portocaliu vibrant
        title: const Text('Account'),
      ),
      body: const Center(
        child: Text(
          'Your account information will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
