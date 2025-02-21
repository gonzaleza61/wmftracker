import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'schedule_screen.dart';

class ComingSoonScreen extends StatefulWidget {
  final String featureName;

  const ComingSoonScreen({
    super.key,
    required this.featureName,
  });

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set initial selected index based on feature name
    _selectedIndex = widget.featureName == 'Schedule'
        ? 1
        : widget.featureName == 'Community'
            ? 2
            : widget.featureName == 'Profile'
                ? 3
                : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.featureName),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upcoming,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Coming Soon!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              '${widget.featureName} features are under development',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              if (_selectedIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleScreen()),
                );
              }
              break;
            case 2:
              if (_selectedIndex != 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ComingSoonScreen(featureName: 'Community'),
                  ),
                );
              }
              break;
            case 3:
              if (_selectedIndex != 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ComingSoonScreen(featureName: 'Profile'),
                  ),
                );
              }
              break;
          }
        },
      ),
    );
  }
}
