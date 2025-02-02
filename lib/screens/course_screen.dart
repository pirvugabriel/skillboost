import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F0), // Roz pal pentru fundal
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF29548A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF29548A)),
            onPressed: () {
              // Notificări
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner imagine și titlu
            Center(
              child: Image.asset(
                'assets/images/product_design.png',
                width: 180,
                height: 180,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Product Design v1.0',
                style: TextStyle(
                  color: const Color(0xFF29548A),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '\$74.00',
                style: TextStyle(
                  color: const Color(0xFFFF742A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Despre curs
            const Text(
              'About this course',
              style: TextStyle(
                color: Color(0xFF29548A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Lecții
            const Text(
              'Lessons',
              style: TextStyle(
                color: Color(0xFF29548A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildLessonTile('01', 'Welcome to the Course', '6:10 mins', true),
            _buildLessonTile('02', 'Process Overview', '6:10 mins', true),
            _buildLessonTile('03', 'Discovery', '6:10 mins', false),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.star_border, color: Color(0xFFFF742A)),
              onPressed: () {
                // Acțiune pentru favorite
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Acțiune pentru cumpărare
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF742A), // Portocaliu vibrant
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonTile(String number, String title, String duration, bool unlocked) {
    return ListTile(
      leading: Text(
        number,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF29548A),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        duration,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: Icon(
        unlocked ? Icons.play_circle_fill : Icons.lock,
        color: unlocked ? const Color(0xFF29548A) : Colors.grey,
      ),
      onTap: unlocked
          ? () {
        // Navighează la lecție
      }
          : null,
    );
  }
}
