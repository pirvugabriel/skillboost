import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skillboost/screens/catalog/catalog_screen.dart';
import 'package:skillboost/screens/search/search_screen.dart';
import 'package:skillboost/screens/messages/messages_screen.dart';
import 'package:skillboost/screens/account/account_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/catalog': (context) => const CatalogScreen(),
        '/search': (context) => const SearchScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/account': (context) => const AccountScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const CatalogScreen(),
    const SearchScreen(),
    const MessagesScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF742A),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  late Future<List<Map<String, dynamic>>> topLearnersFuture;
  List<Map<String, dynamic>> learningPlans = [];

  @override
  void initState() {
    super.initState();
    topLearnersFuture = _fetchTopLearners();
    _fetchLearningPlans();
  }

  Future<List<Map<String, dynamic>>> _fetchTopLearners() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('points', descending: true)
        .limit(100)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'nickname': doc['nickname'],
        'points': doc['points'],
      };
    }).toList();
  }

  Future<void> _fetchLearningPlans() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchased_courses')
          .get();

      setState(() {
        learningPlans = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id, // ✅ Stocăm ID-ul cursului pentru acces ulterior
            'title': doc['title'],
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Text('Error loading user');
            }

            if (snapshot.hasData && snapshot.data!.exists) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final userName = userData['nickname'] ?? "Guest";
              final profilePic = userData['profilePic'] ?? "assets/home/male.png";

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, $userName',
                        style: const TextStyle(
                          color: Color(0xFF29548A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Ready to boost your skills today?',
                        style: TextStyle(color: Color(0xFF29548A), fontSize: 14),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: profilePic.startsWith('http')
                        ? NetworkImage(profilePic)
                        : AssetImage(profilePic) as ImageProvider,
                    radius: 20,
                  ),
                ],
              );
            }

            return const Text('No user data');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: topLearnersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data!.isNotEmpty) {
                  return _buildTopLearnersSection(snapshot.data!);
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 24),
            _buildLearningPlanSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLearnersSection(List<Map<String, dynamic>> learners) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top 100 Learners',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF29548A)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 5, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: learners.asMap().entries.map((entry) {
              int index = entry.key + 1;
              Map<String, dynamic> learner = entry.value;
              return ListTile(
                leading: Text('$index.', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                title: Text(learner['nickname'], style: const TextStyle(fontSize: 16)),
                trailing: Text('${learner['points']} pts', style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLearningPlanSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: learningPlans.isNotEmpty
            ? learningPlans.map((course) => Text(course['title'], style: const TextStyle(fontSize: 16))).toList()
            : [const Text('No courses available yet', style: TextStyle(fontSize: 16, color: Colors.grey))],
      ),
    );
  }
}
