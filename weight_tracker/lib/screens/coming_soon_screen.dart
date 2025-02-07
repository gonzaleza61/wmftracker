import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coming Soon'),
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
          child: Text('This feature is coming soon!',
              style: TextStyle(fontSize: 22))),
    );
  }
}
