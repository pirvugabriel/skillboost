import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Help", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Frequently Asked Questions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("• How do I purchase a course?", style: TextStyle(fontSize: 16)),
            Text("→ Go to the catalog and press 'Buy Now'."),
            SizedBox(height: 10),
            Text("• How do I edit my account?", style: TextStyle(fontSize: 16)),
            Text("→ Go to 'Edit Account' in the account section."),
            SizedBox(height: 10),
            Text("• Need further support?", style: TextStyle(fontSize: 16)),
            Text("→ Contact us at support@skillboost.com."),
          ],
        ),
      ),
    );
  }
}
