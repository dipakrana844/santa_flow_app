import 'package:flutter/material.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/participants/presentation/screens/participants_screen.dart';
import '../../features/matching/presentation/screens/matching_screen.dart';
import '../../features/reveal/presentation/screens/reveal_history_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// Main navigation container with bottom navigation bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    EventsScreen(),
    ParticipantsScreen(),
    MatchingScreen(),
    RevealHistoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Participants',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shuffle), label: 'Matching'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
