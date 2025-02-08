import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WeightTrackerScreen extends StatefulWidget {
  const WeightTrackerScreen({super.key});

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
          "key": key,
          "date": value["date"],
          "weight": value["weight"],
        });
      });
      // Sort entries by date
      entries.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA); // Most recent first
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

  // Delete a weight entry from Firebase
  void _deleteWeightEntry(String key) async {
    await _databaseRef.child(key).remove();
    _fetchWeightEntries(); // Re-fetch entries after deletion
  }

  // Open the Date Picker
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
        // Format date as MM-DD-YYYY
        _dateController.text =
            "${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
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
                hintText: 'MM-DD-YYYY',
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
                  // Convert date format for display
                  final dateParts = entry['date'].split('-');
                  final formattedDate = dateParts.length == 3
                      ? "${dateParts[1]}-${dateParts[2]}-${dateParts[0]}" // Convert YYYY-MM-DD to MM-DD-YYYY
                      : entry[
                          'date']; // Fallback to original if format is unexpected
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
                                'Are you sure you want to delete this weight entry?'),
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
                      _deleteWeightEntry(entry['key']);
                    },
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: $formattedDate',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Weight: ${entry['weight']}',
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
