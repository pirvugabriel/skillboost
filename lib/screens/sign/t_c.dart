import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFFF742A); // Portocaliu vibrant
    final headerColor = const Color(0xFF29548A); // Albastru
    final backgroundColor = const Color(0xFF76FFFF); // Turcoaz
    final textStyle = const TextStyle(fontSize: 16, color: Colors.black87);
    final titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: headerColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SkillBoost Terms & Conditions', style: titleStyle),
              const SizedBox(height: 16),
              _buildSection('1. **General Information**',
                  'SkillBoost is an educational platform designed to provide interactive and engaging courses. By using our platform, you agree to these terms.', textStyle),
              _buildSection('2. **User Accounts**',
                  '- Users must provide accurate information during registration.\n- The platform reserves the right to suspend accounts that violate policies.', textStyle),
              _buildSection('3. **Content & Courses**',
                  '- Courses uploaded by creators must comply with quality standards.\n- Any inappropriate content will be removed.\n- Users retain ownership of the content they create.', textStyle),
              _buildSection('4. **Payments & Monetization**',
                  '- Purchases are processed via Stripe.\n- The platform takes a 5% commission on course sales.\n- Refunds are subject to individual course policies.', textStyle),
              _buildSection('5. **User Conduct**',
                  '- Users must engage respectfully with instructors and other learners.\n- Any form of harassment or abuse will result in account suspension.', textStyle),
              _buildSection('6. **Privacy Policy**',
                  '- Personal data is securely stored and not shared with third parties without consent.\n- Users can request data deletion at any time.', textStyle),
              _buildSection('7. **Changes to Terms**',
                  'SkillBoost reserves the right to update these terms at any time. Users will be notified of major changes.', textStyle),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, TextStyle textStyle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(content, style: textStyle),
        ],
      ),
    );
  }
}
