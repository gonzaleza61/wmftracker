import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'weight_tracker_screen.dart';
import 'workout_tracker_screen.dart';
import 'pr_tracker_screen.dart';
import 'coming_soon_screen.dart';

class HomeScreen extends StatelessWidget {
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardButton(
              title: 'Weight Tracker',
              icon: Icons.monitor_weight,
              onTap: () => _navigateTo(context, WeightTrackerScreen()),
            ),
            DashboardButton(
              title: 'Workout Tracker',
              icon: Icons.fitness_center,
              onTap: () => _navigateTo(context, WorkoutTrackerScreen()),
            ),
            DashboardButton(
              title: 'PR Tracker',
              icon: Icons.assessment,
              onTap: () => _navigateTo(context, PRTrackerScreen()),
            ),
            DashboardButton(
              title: 'Coming Soon',
              icon: Icons.hourglass_empty,
              onTap: () => _navigateTo(context, ComingSoonScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 60),
          textStyle: TextStyle(fontSize: 18),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
