import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      elevation: 4,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_outlined),
          selectedIcon: Icon(Icons.event),
          label: 'الفعاليات',
        ),
        NavigationDestination(
          icon: Icon(Icons.group_outlined),
          selectedIcon: Icon(Icons.group),
          label: 'الفريق',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person),
          label: 'حسابي',
        ),
      ],
    );
  }
}