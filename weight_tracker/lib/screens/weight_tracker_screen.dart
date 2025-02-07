import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WeightTrackerScreen extends StatefulWidget {
  @override
  _WeightTrackerScreenState createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  final _weightController = TextEditingController();
  final _dateController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance
      .ref("users/${FirebaseAuth.instance.currentUser!.uid}/weightEntries");
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> _weightEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchWeightEntries();
  }

  // Fetch weight entries from Firebase
  void _fetchWeightEntries() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      List<Map<String, dynamic>> entries = [];
      data.forEach((key, value) {
        entries.add({
          "date": value["date"],
          "weight": value["weight"],
        });
      });
      setState(() {
        _weightEntries = entries;
      });
    }
  }

  // Add a new weight entry to Firebase
  void _addWeightEntry() async {
    final weight = _weightController.text;
    final date = _dateController.text;

    if (weight.isNotEmpty && date.isNotEmpty) {
      await _databaseRef.push().set({
        "date": date,
        "weight": weight,
      });
      _fetchWeightEntries(); // Re-fetch entries after adding new one
      _weightController.clear();
      _dateController.clear();
    }
  }

  // Open the Date Picker
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = "${selectedDate.toLocal()}"
            .split(' ')[0]; // format date as yyyy-MM-dd
      });
  }

  // Logout the user
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route
        .isFirst); // This will pop all routes and take you back to the first screen, typically the login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date picker for selecting date
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Select Date',
                hintText: 'YYYY-MM-DD',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            // Input field for weight
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addWeightEntry,
              child: Text('Add Entry'),
            ),
            SizedBox(height: 16),
            // Display previous weight entries
            Expanded(
              child: ListView.builder(
                itemCount: _weightEntries.length,
                itemBuilder: (context, index) {
                  final entry = _weightEntries[index];
                  return ListTile(
                    title: Text('Date: ${entry['date']}'),
                    subtitle: Text('Weight: ${entry['weight']}'),
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
