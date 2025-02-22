import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'schedule_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class ComingSoonScreen extends StatelessWidget {
  final String featureName;

  const ComingSoonScreen({
    super.key,
    required this.featureName,
  });

  int get _currentIndex {
    switch (featureName) {
      case 'Schedule':
        return 1;
      case 'Community':
        return 2;
      case 'Profile':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(featureName),
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
              '$featureName features are under development',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
    );
  }
}
