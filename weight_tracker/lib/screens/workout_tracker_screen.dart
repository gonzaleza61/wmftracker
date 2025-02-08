import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkoutTrackerScreen extends StatefulWidget {
  const WorkoutTrackerScreen({super.key});

  @override
  _WorkoutTrackerScreenState createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  final _dateController = TextEditingController();
  final _musclesController = TextEditingController();
  final _workoutController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance
      .ref("users/${FirebaseAuth.instance.currentUser!.uid}/workoutEntries");
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> _workoutEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkoutEntries();
  }

  void _fetchWorkoutEntries() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      List<Map<String, dynamic>> entries = [];
      data.forEach((key, value) {
        entries.add({
          "key": key,
          "date": value["date"],
          "muscles": value["muscles"],
          "workout": value["workout"],
        });
      });
      entries.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA);
      });
      setState(() {
        _workoutEntries = entries;
      });
    }
  }

  void _addWorkoutEntry() async {
    final date = _dateController.text;
    final muscles = _musclesController.text;
    final workout = _workoutController.text;

    if (date.isNotEmpty && muscles.isNotEmpty && workout.isNotEmpty) {
      await _databaseRef.push().set({
        "date": date,
        "muscles": muscles,
        "workout": workout,
      });
      _fetchWorkoutEntries();
      _dateController.clear();
      _musclesController.clear();
      _workoutController.clear();
    }
  }

  Future<void> _deleteWorkoutEntry(String key) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this workout entry?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await _databaseRef.child(key).remove();
      _fetchWorkoutEntries();
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

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
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            TextField(
              controller: _musclesController,
              decoration: InputDecoration(
                labelText: 'Muscles Worked',
              ),
            ),
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(
                labelText: 'Workout Details',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addWorkoutEntry,
              child: Text('Add Workout'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _workoutEntries.length,
                itemBuilder: (context, index) {
                  final entry = _workoutEntries[index];
                  return Dismissible(
                    key: Key(entry['key']),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete this workout entry?'),
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
                      _deleteWorkoutEntry(entry['key']);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${entry['date']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Muscles: ${entry['muscles']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Workout: ${entry['workout']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
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
