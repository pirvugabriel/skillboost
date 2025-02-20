import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  File? _selectedFile;
  bool _isUploading = false;

  /// 📂 **Selectează un fișier**
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() => _selectedFile = File(result.files.single.path!));
    }
  }

  /// 📤 **Încarcă fișierul în Firebase Storage**
  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() => _isUploading = true);

    try {
      String fileName = _selectedFile!.path.split('/').last;
      Reference storageRef = FirebaseStorage.instance.ref().child("creator_uploads/$fileName");
      await storageRef.putFile(_selectedFile!);

      if (mounted) { // ✅ Verificăm dacă widget-ul este montat înainte de a folosi context
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload successful!")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload failed!")));
      }
    }

    setState(() => _isUploading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Creator", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Choose File", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null) Text("Selected: ${_selectedFile!.path.split('/').last}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upload", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
