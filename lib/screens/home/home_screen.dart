import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Loading...";
  String profilePic = "assets/home/male.png"; // Default profile pic path
  List<Map<String, dynamic>> topLearners = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchTopLearners();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? "User";
          profilePic = userDoc['profilePic'] ?? "assets/home/male.png";
        });
      }
    }
  }

  Future<void> _fetchTopLearners() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('points', descending: true)
        .limit(3)
        .get();

    setState(() {
      topLearners = querySnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'points': doc['points'],
          'badge': doc['badge'],
        };
      }).toList();
    });
  }

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
              children: [
                Text(
                  'Hi, $userName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Ready to boost your skills today?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              backgroundImage: AssetImage(profilePic),
              radius: 20,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Learners Section
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
                children: [
                  const Text(
                    'Top 100 Learners',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF29548A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...topLearners.map((learner) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        learner['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text(
                            '${learner['points']} pts',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            learner['badge'] == 'Gold'
                                ? Icons.star
                                : learner['badge'] == 'Silver'
                                ? Icons.star_half
                                : Icons.star_outline,
                            color: learner['badge'] == 'Gold'
                                ? Colors.amber
                                : learner['badge'] == 'Silver'
                                ? Colors.grey
                                : Colors.brown,
                          )
                        ],
                      ),
                    ],
                  ))
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
            _buildLearningCard('Packaging Design', '40/48'),
            const SizedBox(height: 16),
            _buildLearningCard('Product Design', '6/24'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFFF742A),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
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
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/catalog');
              break;
            case 2:
              Navigator.pushNamed(context, '/search');
              break;
            case 3:
              Navigator.pushNamed(context, '/messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/account');
              break;
          }
        },
      ),
    );
  }

  Widget _buildLearningCard(String title, String progress) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/course', arguments: {'courseTitle': title});
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF742A),
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFFF742A),
            ),
          ],
        ),
      ),
    );
  }
}
