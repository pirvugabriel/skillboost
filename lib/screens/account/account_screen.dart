import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF29548A),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF76FFFF),
              child: Image.asset(
                'assets/images/profile_icon.png', // Replace with your profile image
                fit: BoxFit.cover,
                width: 70,
                height: 70,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gabriel Pîrvu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF29548A),
              ),
            ),
            const SizedBox(height: 32),

            // List of settings
            Expanded(
              child: ListView(
                children: [
                  _buildAccountOption(
                      context, 'Favourite', Icons.favorite_outline),
                  _buildAccountOption(
                      context, 'Edit Account', Icons.edit_outlined),
                  _buildAccountOption(
                      context, 'Settings and Privacy', Icons.settings_outlined),
                  _buildAccountOption(context, 'Help', Icons.help_outline),
                  const Divider(),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF29548A),
        unselectedItemColor: Colors.grey,
        currentIndex: 4,
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
            // Current screen
              break;
          }
        },
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

  Widget _buildAccountOption(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF29548A)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF29548A),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        // Navigate to corresponding pages or functions if required
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        'Logout',
        style: TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
      ),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}
