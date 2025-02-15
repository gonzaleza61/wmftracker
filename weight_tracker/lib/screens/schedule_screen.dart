import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, List<WorkoutEvent>> _workouts = {};
  StreamSubscription? _workoutsSubscription;
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  @override
  void dispose() {
    _workoutsSubscription?.cancel();
    super.dispose();
  }

  void _deleteWorkout(String date, String workoutId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final ref = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('workouts')
        .child(date);

    // First remove the specific workout
    ref.child(workoutId).remove().then((_) {
      // Then check if this was the last workout for this date
      ref.get().then((snapshot) {
        if (!snapshot.exists || snapshot.children.isEmpty) {
          // If no workouts left, remove the entire date node
          ref.remove();
        }
      });
    });

    // Update local state immediately
    setState(() {
      final dateWorkouts = _workouts[date] ?? [];
      dateWorkouts.removeWhere((workout) => workout.id == workoutId);

      if (dateWorkouts.isEmpty) {
        _workouts.remove(date);
      } else {
        _workouts[date] = dateWorkouts;
      }
    });
  }

  void _loadWorkouts() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _workoutsSubscription?.cancel();
    _workoutsSubscription = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('workouts')
        .onValue
        .listen((event) {
      if (!mounted) return;
      if (!event.snapshot.exists) return;

      try {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final Map<String, List<WorkoutEvent>> newWorkouts = {};

        data.forEach((dateStr, workouts) {
          if (workouts is Map) {
            final workoutList = <WorkoutEvent>[];
            workouts.forEach((key, value) {
              if (value is Map) {
                workoutList.add(WorkoutEvent(
                  id: key,
                  title: value['title']?.toString() ?? '',
                  date: dateStr.toString(),
                ));
              }
            });
            if (workoutList.isNotEmpty) {
              newWorkouts[dateStr.toString()] = workoutList;
            }
          }
        });

        setState(() {
          _workouts = newWorkouts;
        });
      } catch (e) {
        // Handle error silently or show user feedback if needed
      }
    });
  }

  void _addWorkout(String title, DateTime selectedDate) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final dateStr = selectedDate.toString().split(' ')[0];

    final ref = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('workouts')
        .child(dateStr);

    final workout = {
      'title': title,
      'timestamp': ServerValue.timestamp,
    };

    ref.push().set(workout);
  }

  @override
  Widget build(BuildContext context) {
    final sortedDates = _workouts.keys.toList()..sort((a, b) => b.compareTo(a));
    final selectedDateStr = _selectedDay.toString().split(' ')[0];
    final selectedWorkouts = _workouts[selectedDateStr] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Schedule'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              final dateStr = day.toString().split(' ')[0];
              return _workouts[dateStr] ?? [];
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Workouts for $selectedDateStr',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: selectedWorkouts.isEmpty
                ? Center(child: Text('No workouts scheduled for this day'))
                : ListView.builder(
                    itemCount: selectedWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = selectedWorkouts[index];
                      return Dismissible(
                        key: Key(workout.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteWorkout(selectedDateStr, workout.id);
                        },
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading:
                                Icon(Icons.fitness_center, color: Colors.red),
                            title: Text(workout.title),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkoutDialog(context, _selectedDay),
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddWorkoutDialog(BuildContext context, DateTime selectedDate) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Workout for ${selectedDate.toString().split(' ')[0]}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Workout Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addWorkout(controller.text, selectedDate);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

class WorkoutEvent {
  final String id;
  final String title;
  final String date;

  WorkoutEvent({
    required this.id,
    required this.title,
    required this.date,
  });
}
