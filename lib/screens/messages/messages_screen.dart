import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF742A), // Portocaliu vibrant
        title: const Text('Messages'),
      ),
      body: const Center(
        child: Text(
          'Your messages will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}