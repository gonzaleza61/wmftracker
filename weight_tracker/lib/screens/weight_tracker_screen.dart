import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeightTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracker'),
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
          child: Text('Weight Tracker Screen', style: TextStyle(fontSize: 22))),
    );
  }
}
