import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillboost/screens/account/edit_account_screen.dart';
import 'package:skillboost/screens/account/creator_screen.dart';
import 'package:skillboost/screens/account/help_screen.dart';
import 'package:skillboost/screens/sign/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _nickname = "User";
  String _profileImage = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// 📌 **Obține datele utilizatorului din Firestore**
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      setState(() {
        _nickname = userDoc['nickname'] ?? "User";
        _profileImage = userDoc['profilePic'] ?? "assets/home/male.png";
      });
    }
  }

  /// 🚪 **Deconectează utilizatorul**
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Account',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Imaginea de profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage.startsWith('http')
                        ? NetworkImage(_profileImage) as ImageProvider
                        : AssetImage(_profileImage) as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _nickname,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 Lista de opțiuni
            _buildOptionItem("Edit Account", Icons.edit, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditAccountScreen()));
            }),
            _buildOptionItem("Creator", Icons.upload_file, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatorScreen()));
            }),
            _buildOptionItem("Help", Icons.help_outline, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreen()));
            }),

            // 🚪 Logout
            const Spacer(),
            TextButton(
              onPressed: _logout,
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 **Construiește elementele din listă**
  Widget _buildOptionItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
