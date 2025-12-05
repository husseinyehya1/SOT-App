import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'events_page.dart';
import 'team_page.dart';
import 'profile_page.dart';
import '../widgets/bottom_navigation.dart';
import '../services/local_user_profile_service.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final LocalUserProfileService _profileService = LocalUserProfileService();

  // Pages for navigation
  final List<Widget> _pages = [
    const DashboardPage(),
    const EventsPage(),
    const TeamPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserProfile();
  }

  Future<void> _initializeUserProfile() async {
    try {
      await _profileService.initializeUserProfile();
    } catch (e) {
      // Silently handle initialization errors
      debugPrint('Failed to initialize user profile: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Prevent swiping
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}