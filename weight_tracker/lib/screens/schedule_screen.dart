import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_nav_bar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<DateTime, List<WorkoutEvent>> _workouts = {};
  List<WorkoutEvent> _allWorkouts = [];
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final _databaseRef = FirebaseDatabase.instance
      .ref("users/${FirebaseAuth.instance.currentUser!.uid}/workoutEntries");

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      Map<DateTime, List<WorkoutEvent>> workouts = {};
      List<WorkoutEvent> allWorkouts = [];

      data.forEach((key, value) {
        final List<String> dateParts = value['date'].toString().split('-');
        final DateTime date = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[0]), // month
          int.parse(dateParts[1]), // day
        );

        final event = WorkoutEvent(
          id: key,
          title: value['muscles'],
          date: value['date'],
          dateTime: date,
        );

        if (!workouts.containsKey(date)) {
          workouts[date] = [];
        }
        workouts[date]?.add(event);
        allWorkouts.add(event);
      });

      // Sort all workouts by date (most recent first)
      allWorkouts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      setState(() {
        _workouts = workouts;
        _allWorkouts = allWorkouts;
      });
    }
  }

  List<WorkoutEvent> _getEventsForDay(DateTime day) {
    return _workouts[DateTime(day.year, day.month, day.day)] ?? [];
  }

  String _getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
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
          ),
          Divider(thickness: 1),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Recent Workouts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allWorkouts.length,
              itemBuilder: (context, index) {
                final workout = _allWorkouts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    title: Text(
                      _getDayOfWeek(workout.dateTime),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      '${workout.date}\n${workout.title}',
                    ),
                  ),
                );
              },
            ),
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
  final DateTime dateTime;

  WorkoutEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.dateTime,
  });
}
