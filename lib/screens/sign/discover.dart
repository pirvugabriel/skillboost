import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  DiscoverScreenState createState() => DiscoverScreenState();
}

class DiscoverScreenState extends State<DiscoverScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76FFFF), // Turcoaz
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Skip Button (ascuns pe ultima pagină)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _currentPage < 2
                        ? TextButton(
                      onPressed: () {
                        _pageController.jumpToPage(2); // Sare direct la ultima pagină
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF29548A), // Albastru închis
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : const SizedBox(
                      height: 50, // Înlocuiește înălțimea butonului de Skip
                    ),
                  ),
                ),

                // PageView for swipe functionality
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      _buildPage(
                        context,
                        imagePath: 'assets/sign/discover.png', // Placeholder image
                        title: 'Discover New Courses',
                        description:
                        'Access interactive lessons and build essential skills for your future.',
                        signUpRoute: '/signup',
                        loginRoute: '/login',
                      ),
                      _buildPage(
                        context,
                        imagePath: 'assets/sign/creator.png', // Placeholder for second page
                        title: 'Become a Creator',
                        description:
                        'Create interactive courses, share knowledge, and expand your impact globally.',
                        signUpRoute: '/signup',
                        loginRoute: '/login',
                      ),
                      _buildPage(
                        context,
                        imagePath: 'assets/sign/teamwork.png', // Placeholder for third page
                        title: 'Learn Together',
                        description:
                        'Learn from experts, teach others, and grow together.',
                        signUpRoute: '/signup',
                        loginRoute: '/login',
                      ),
                    ],
                  ),
                ),

                // Page Indicators
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIndicator(active: _currentPage == 0),
                      _buildIndicator(active: _currentPage == 1),
                      _buildIndicator(active: _currentPage == 2),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Page Indicator Widget
  Widget _buildIndicator({required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: active ? 16 : 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF29548A) : Colors.white, // Albastru pentru activ, alb altfel
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Build Each Page
  Widget _buildPage(
      BuildContext context, {
        required String imagePath,
        required String title,
        required String description,
        required String signUpRoute,
        required String loginRoute,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 250,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: const Color(0xFF29548A), // Albastru închis
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, signUpRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF742A), // Portocaliu vibrant
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, loginRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(color: Color(0xFF29548A), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
