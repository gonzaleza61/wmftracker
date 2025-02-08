import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PRTrackerScreen extends StatefulWidget {
  const PRTrackerScreen({super.key});

  @override
  State<PRTrackerScreen> createState() => _PRTrackerScreenState();
}

class _PRTrackerScreenState extends State<PRTrackerScreen> {
  final _workoutController = TextEditingController();
  final _prController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance
      .ref()
      .child('prs')
      .child(FirebaseAuth.instance.currentUser!.uid);
  List<Map<String, dynamic>> _prEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchPREntries();
  }

  void _fetchPREntries() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      List<Map<String, dynamic>> entries = [];
      data.forEach((key, value) {
        entries.add({
          "key": key,
          "workout": value["workout"],
          "pr": value["pr"],
        });
      });
      setState(() {
        _prEntries = entries;
      });
    }
  }

  void _addPREntry() async {
    final workout = _workoutController.text;
    final pr = _prController.text;

    if (workout.isNotEmpty && pr.isNotEmpty) {
      await _databaseRef.push().set({
        "workout": workout,
        "pr": pr,
      });
      _fetchPREntries();
      _workoutController.clear();
      _prController.clear();
    }
  }

  void _deletePREntry(String key) async {
    await _databaseRef.child(key).remove();
    _fetchPREntries();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(labelText: 'Workout Name'),
            ),
            TextField(
              controller: _prController,
              decoration: InputDecoration(labelText: 'Personal Record'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addPREntry,
              child: Text('Add PR'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _prEntries.length,
                itemBuilder: (context, index) {
                  final entry = _prEntries[index];
                  return Dismissible(
                    key: Key(entry['key']),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete this PR entry?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      _deletePREntry(entry['key']);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry["workout"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'PR: ${entry["pr"]}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
