import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillboost/screens/catalog/course_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedFilter = "All"; // 🔹 Filtru activ
  String _searchQuery = ""; // 🔹 Textul introdus în căutare

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Course',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/home/male.png"),
            // 🔹 Poza de profil (de modificat dacă e nevoie)
            radius: 20,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildFilterButtons(),
            const SizedBox(height: 16),
            Expanded(child: _buildCourseList()), // 🔹 Lista cursurilor
          ],
        ),
      ),
    );
  }

  /// 🔍 **Bară de căutare**
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Find Course',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
    );
  }

  /// 🎯 **Buton de filtrare**
  Widget _buildFilterButtons() {
    List<String> filters = ["All", "My Courses", "Price", "Popular"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: filters.map((filter) {
        bool isSelected = _selectedFilter == filter;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFilter = filter;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              filter,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 📚 **Listă de cursuri filtrată din Firestore**
  Widget _buildCourseList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      // 🔹 Ascultă cursurile live
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // 🔄 Loading indicator
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No courses available")); // 🔹 Dacă nu sunt cursuri
        }

        List<QueryDocumentSnapshot> courses = snapshot.data!.docs;

        // 🔹 Dacă filtrul activ este "My Courses", încărcăm purchased_courses
        List<String> myCourses = [];
        if (_selectedFilter == "My Courses") {
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get()
              .then((userDoc) {
            if (userDoc.exists) {
              myCourses = List<String>.from(userDoc['purchased_courses'] ?? []);
            }
          });
        }

        // 🔎 Aplicăm filtrul și căutarea
        courses = courses.where((course) {
          final data = course.data() as Map<String, dynamic>;
          final title = data['title'].toString().toLowerCase();
          final searchTags = List<String>.from(data['search_tags'] ?? []);
          final matchesSearch = title.contains(_searchQuery) ||
              searchTags.any((tag) => tag.contains(_searchQuery));

          if (_selectedFilter == "My Courses") {
            return myCourses.contains(course.id);
          }
          if (_selectedFilter == "Price") return true; // Sortăm mai jos
          if (_selectedFilter == "Popular") return true; // Sortăm mai jos

          return matchesSearch;
        }).toList();

        // 🔄 Sortare dacă e cazul
        if (_selectedFilter == "Price") {
          courses.sort((a, b) =>
              (a['price'] as num).compareTo(b['price'] as num));
        } else if (_selectedFilter == "Popular") {
          courses.sort((a, b) =>
              (b['popularity'] as num).compareTo(a['popularity'] as num));
        }

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final data = courses[index].data() as Map<String, dynamic>;
            return _buildCourseCard(
              courseId: courses[index].id,
              title: data['title'],
              author: data['author'],
              price: data['price'],
              duration: data['duration'],
              imageUrl: data['image_url'],
            );
          },
        );
      },
    );
  }

  /// 📌 **Card pentru un curs individual**
  Widget _buildCourseCard({
    required String courseId, // 🔹 ID-ul documentului din Firestore
    required String title,
    required String author,
    required num price,
    required num duration,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseScreen(courseId: courseId), // 🔹 Trimitem ID-ul cursului
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: imageUrl.isNotEmpty ? Image.asset(
                  imageUrl, fit: BoxFit.cover) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 14),
                      Text(" $author",
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("\$$price", style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("$duration hours",
                            style: const TextStyle(fontSize: 12, color: Colors
                                .orange)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
