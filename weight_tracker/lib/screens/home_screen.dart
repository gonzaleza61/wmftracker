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
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            'lib/assets/WMFlogo.PNG',
            fit: BoxFit.contain,
            width: 60,
            height: 60,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
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
              constraints: BoxConstraints(maxWidth: 1000),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 0.5,
                      child: DashboardButton(
                        title: 'Leaderboard',
                        icon: Icons.leaderboard,
                        onTap: () => _navigateTo(context, ComingSoonScreen()),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: DashboardButton(
                                  title: 'Weight\nTracker',
                                  icon: Icons.monitor_weight,
                                  onTap: () => _navigateTo(
                                      context, WeightTrackerScreen()),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: DashboardButton(
                                  title: 'Workout\nTracker',
                                  icon: Icons.fitness_center,
                                  onTap: () => _navigateTo(
                                      context, WorkoutTrackerScreen()),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: DashboardButton(
                                  title: 'PR\nTracker',
                                  icon: Icons.assessment,
                                  onTap: () =>
                                      _navigateTo(context, PRTrackerScreen()),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: DashboardButton(
                                  title: 'Exercise\nLibrary',
                                  icon: Icons.menu_book,
                                  onTap: () =>
                                      _navigateTo(context, ComingSoonScreen()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
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
        onTap: (index) {
          // Handle navigation when implemented
        },
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
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
