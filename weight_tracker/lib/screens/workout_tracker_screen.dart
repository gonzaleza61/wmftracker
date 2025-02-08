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
        List<String> partsA = a['date'].split('-');
        List<String> partsB = b['date'].split('-');
        DateTime dateA = DateTime(
            int.parse(partsA[2]), // Year
            int.parse(partsA[0]), // Month
            int.parse(partsA[1]) // Day
            );
        DateTime dateB = DateTime(
            int.parse(partsB[2]), int.parse(partsB[0]), int.parse(partsB[1]));
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
      Navigator.pop(context);
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
            "${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  void _showAddWorkoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Workout'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    hintText: 'MM-DD-YYYY',
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.red),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _musclesController,
                  decoration: InputDecoration(
                    labelText: 'Muscles Worked',
                    prefixIcon: Icon(Icons.fitness_center, color: Colors.red),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _workoutController,
                  decoration: InputDecoration(
                    labelText: 'Workout Details',
                    prefixIcon: Icon(Icons.description, color: Colors.red),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: _addWorkoutEntry,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout Tracker',
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
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWorkoutDialog,
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: Container(
        width: double.infinity,
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
          padding: const EdgeInsets.all(16.0),
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
                },
                onDismissed: (direction) {
                  _deleteWorkoutEntry(entry['key']);
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${entry['date']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Muscles: ${entry['muscles']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
      ),
    );
  }
}
