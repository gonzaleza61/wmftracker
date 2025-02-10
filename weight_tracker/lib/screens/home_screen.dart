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
              child: isLargeScreen
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 0.5,
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'lib/assets/compportrait.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () => _navigateTo(
                                        context, ComingSoonScreen()),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.leaderboard,
                                            size: 40, color: Colors.white),
                                        SizedBox(height: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'LEADERBOARD',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: AspectRatio(
                            aspectRatio: 0.5,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: DashboardButton(
                                            title: 'WEIGHT\nTRACKER',
                                            icon: Icons.monitor_weight,
                                            onTap: () => _navigateTo(
                                                context, WeightTrackerScreen()),
                                            fontSize: 14,
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: DashboardButton(
                                            title: 'WORKOUT\nTRACKER',
                                            icon: Icons.fitness_center,
                                            onTap: () => _navigateTo(context,
                                                WorkoutTrackerScreen()),
                                            fontSize: 14,
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: DashboardButton(
                                            title: 'PR\nTRACKER',
                                            icon: Icons.assessment,
                                            onTap: () => _navigateTo(
                                                context, PRTrackerScreen()),
                                            fontSize: 14,
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: DashboardButton(
                                            title: 'EXERCISE\nLIBRARY',
                                            icon: Icons.menu_book,
                                            onTap: () => _navigateTo(
                                                context, ComingSoonScreen()),
                                            fontSize: 14,
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 3,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage('lib/assets/comp.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () =>
                                      _navigateTo(context, ComingSoonScreen()),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.leaderboard,
                                          size: 40, color: Colors.white),
                                      SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'LEADERBOARD',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DashboardButton(
                                        title: 'WEIGHT\nTRACKER',
                                        icon: Icons.monitor_weight,
                                        onTap: () => _navigateTo(
                                            context, WeightTrackerScreen()),
                                        fontSize: 14,
                                        iconSize: 30,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DashboardButton(
                                        title: 'WORKOUT\nTRACKER',
                                        icon: Icons.fitness_center,
                                        onTap: () => _navigateTo(
                                            context, WorkoutTrackerScreen()),
                                        fontSize: 14,
                                        iconSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DashboardButton(
                                        title: 'PR\nTRACKER',
                                        icon: Icons.assessment,
                                        onTap: () => _navigateTo(
                                            context, PRTrackerScreen()),
                                        fontSize: 14,
                                        iconSize: 30,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: DashboardButton(
                                        title: 'EXERCISE\nLIBRARY',
                                        icon: Icons.menu_book,
                                        onTap: () => _navigateTo(
                                            context, ComingSoonScreen()),
                                        fontSize: 14,
                                        iconSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
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
        backgroundColor: Colors.black,
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
  final double fontSize;
  final double iconSize;

  const DashboardButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.fontSize = 18,
    this.iconSize = 40,
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
            Icon(icon, size: iconSize, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
