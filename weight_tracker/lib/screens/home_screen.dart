import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'weight_tracker_screen.dart';
import 'workout_tracker_screen.dart';
import 'pr_tracker_screen.dart';
import 'coming_soon_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isLargeScreen
                ? 'lib/assets/WMFlogoExtended.PNG'
                : 'lib/assets/WMFlogo.PNG'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLargeScreen)
                    Row(
                      children: [
                        Expanded(
                          child: DashboardButton(
                            title: 'Weight Tracker',
                            icon: Icons.monitor_weight,
                            onTap: () =>
                                _navigateTo(context, WeightTrackerScreen()),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DashboardButton(
                            title: 'Workout Tracker',
                            icon: Icons.fitness_center,
                            onTap: () =>
                                _navigateTo(context, WorkoutTrackerScreen()),
                          ),
                        ),
                      ],
                    ),
                  if (isLargeScreen) SizedBox(height: 20),
                  if (isLargeScreen)
                    Row(
                      children: [
                        Expanded(
                          child: DashboardButton(
                            title: 'PR Tracker',
                            icon: Icons.assessment,
                            onTap: () =>
                                _navigateTo(context, PRTrackerScreen()),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DashboardButton(
                            title: 'Coming Soon',
                            icon: Icons.hourglass_empty,
                            onTap: () =>
                                _navigateTo(context, ComingSoonScreen()),
                          ),
                        ),
                      ],
                    ),
                  if (!isLargeScreen) ...[
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
                ],
              ),
            ),
          ),
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
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(double.infinity, 60),
            textStyle: TextStyle(fontSize: 18, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.white),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
