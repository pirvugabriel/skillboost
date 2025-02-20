import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Pentru citirea fișierelor din assets
import 'package:path_provider/path_provider.dart'; // Pentru salvare locală
import 'package:open_file/open_file.dart'; // Pentru deschiderea fișierelor

class CourseScreen extends StatefulWidget {
  final String courseId; // 🔹 ID-ul cursului

  const CourseScreen({super.key, required this.courseId});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<DocumentSnapshot> _courseFuture;
  bool _isPurchased = false;

  @override
  void initState() {
    super.initState();
    _courseFuture = FirebaseFirestore.instance.collection('courses').doc(widget.courseId).get();
    _checkIfPurchased();
  }

  /// 🛒 **Verifică dacă utilizatorul a cumpărat cursul**
  Future<void> _checkIfPurchased() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    List<String> purchasedCourses = List<String>.from(userDoc['purchased_courses'] ?? []);

    setState(() {
      _isPurchased = purchasedCourses.contains(widget.courseId);
    });
  }

  /// 🛒 **Cumpără cursul și îl adaugă în Firestore**
  Future<void> _buyCourse() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userRef.update({
      'purchased_courses': FieldValue.arrayUnion([widget.courseId]) // 🔹 Adăugăm cursul în Firestore
    });

    setState(() {
      _isPurchased = true; // ✅ Ascundem butonul "Buy Now"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Course Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Course not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  image: data['image_url'].isNotEmpty
                      ? DecorationImage(image: AssetImage(data['image_url']), fit: BoxFit.cover)
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['title'],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${data['price']}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "${data['duration']} hours · ${data['course/product-design'].length} Lessons",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("About this course", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(data['description'], style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 16),



              if (!_isPurchased)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _buyCourse,
                    child: const Text("Buy Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLessonList(List<dynamic> lessons) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        String lessonTitle = lessons[index]['title'];
        String lessonDuration = lessons[index]['duration'];
        String lessonFile = lessons[index]['file'];

        bool isLocked = !_isPurchased && index > 0;

        return ListTile(
          leading: Text(
            (index + 1).toString().padLeft(2, '0'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isLocked ? Colors.grey : Colors.black),
          ),
          title: Text(lessonTitle, style: TextStyle(fontSize: 16, color: isLocked ? Colors.grey : Colors.black)),
          subtitle: Row(
            children: [
              Text("$lessonDuration mins", style: TextStyle(color: isLocked ? Colors.grey : Colors.orange)),
              if (!isLocked) const Icon(Icons.check_circle, color: Colors.orange, size: 16),
            ],
          ),
          trailing: isLocked
              ? const Icon(Icons.lock, color: Colors.grey)
              : IconButton(
            icon: const Icon(Icons.play_circle_fill, color: Colors.orange),
            onPressed: () async {
              _openLessonFile(lessonFile);
            },
          ),
        );
      },
    );
  }

  void _openLessonFile(String fileName) async {
    final ByteData data = await rootBundle.load('assets/catalog/$fileName');
    final List<int> bytes = data.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);

    OpenFile.open(file.path);
  }
}
