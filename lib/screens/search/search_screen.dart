import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  /// 🔍 **Funcție pentru căutare în Firestore**
  Future<void> _searchCourses(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('global_search')
        .where('search_tags', arrayContains: query.toLowerCase()) // 🔎 Căutare în `search_tags`
        .get();

    setState(() {
      _searchResults = snapshot.docs.map((doc) => doc.data()).toList();
      _isLoading = false;
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
          'Search',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Bara de căutare
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _searchCourses,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Results",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),

            // 🔄 Afișăm rezultatele sau un mesaj corespunzător
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // 🔄 Loading
                  : _searchResults.isEmpty
                  ? const Center(child: Text("No results found", style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final course = _searchResults[index];
                  return _buildCourseCard(course);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 **Card pentru fiecare rezultat**
  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            image: course['image_url'] != null && course['image_url'].isNotEmpty
                ? DecorationImage(image: NetworkImage(course['image_url']), fit: BoxFit.cover)
                : null,
          ),
        ),
        title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(course['instructor'], style: const TextStyle(color: Colors.grey)),
        trailing: Text("\$${course['price']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
        onTap: () {
          // 🔹 Navigare la pagina cursului
          Navigator.pushNamed(context, '/course', arguments: course['course_id']);
        },
      ),
    );
  }
}
