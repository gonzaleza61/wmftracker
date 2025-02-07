import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
          child:
              Text('Workout Tracker Screen', style: TextStyle(fontSize: 22))),
    );
  }
}
