import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PRTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PR Tracker'),
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
          child: Text('PR Tracker Screen', style: TextStyle(fontSize: 22))),
    );
  }
}
