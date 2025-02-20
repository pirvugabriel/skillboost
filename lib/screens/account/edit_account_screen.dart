import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentNickname();
  }

  /// 📌 **Încărcăm nickname-ul curent din Firestore**
  Future<void> _loadCurrentNickname() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      _nicknameController.text = userDoc['nickname'] ?? "";
    }
  }

  /// 💾 **Salvăm noul nickname în Firestore**
  Future<void> _saveNickname() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _nicknameController.text.isEmpty) return;

    setState(() => _isSaving = true);

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'nickname': _nicknameController.text,
    });

    setState(() => _isSaving = false);

    if (mounted) { // ✅ Verificăm dacă widget-ul este montat înainte de a folosi context
      Navigator.pop(context); // 🔙 Înapoi la pagina Account
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Edit Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: "Enter new nickname"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveNickname,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
