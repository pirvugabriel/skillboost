import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF), // Turcoaz
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF742A), // Portocaliu vibrant
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hi, Gabriel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ready to boost your skills today?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(Icons.person, color: Color(0xFFFF742A)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Learners Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Top 100 Learners',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF29548A), // Albastru închis
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Robertson Connie'),
                  Text('2. Nguyen Shane'),
                  Text('3. Bert Pullman'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Learning Plan Section
            const Text(
              'Learning Plan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF29548A),
              ),
            ),
            const SizedBox(height: 16),

            // Cards for courses
            Column(
              children: [
                _buildLearningCard(
                  context: context,
                  title: 'Packaging Design',
                  progress: '40/48',
                  color: const Color(0xFFFF742A),
                ),
                const SizedBox(height: 16),
                _buildLearningCard(
                  context: context,
                  title: 'Product Design',
                  progress: '6/24',
                  color: const Color(0xFF76FFFF),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFFF742A),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home'); // Navigare la Home
              break;
            case 1:
              Navigator.pushNamed(context, '/catalog'); // Navigare la Courses
              break;
            case 2:
              Navigator.pushNamed(context, '/search'); // Navigare la Search (creați această pagină)
              break;
            case 3:
              Navigator.pushNamed(context, '/messages'); // Navigare la Messages (creați această pagină)
              break;
            case 4:
              Navigator.pushNamed(context, '/account'); // Navigare la Account (creați această pagină)
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  // Widget pentru cardurile de learning
  Widget _buildLearningCard({
    required BuildContext context,
    required String title,
    required String progress,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/catalog'); // Poți schimba destinația dacă ai altă pagină specifică
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF29548A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  progress,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
