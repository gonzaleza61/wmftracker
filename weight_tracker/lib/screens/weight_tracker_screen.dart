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
          "weight": double.parse(value["weight"]),
        });
      });
      // Sort entries by date
      entries.sort((a, b) {
        // Parse date in MM-DD-YYYY format
        List<String> partsA = a['date'].split('-');
        List<String> partsB = b['date'].split('-');

        DateTime dateA = DateTime(
            int.parse(partsA[2]), // Year
            int.parse(partsA[0]), // Month
            int.parse(partsA[1]) // Day
            );
        DateTime dateB = DateTime(
            int.parse(partsB[2]), int.parse(partsB[0]), int.parse(partsB[1]));
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

    // Validate date format (MM-DD-YYYY)
    RegExp dateFormat = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!dateFormat.hasMatch(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter date in MM-DD-YYYY format')));
      return;
    }

    // Further validate date parts
    List<String> dateParts = date.split('-');
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    if (month < 1 ||
        month > 12 ||
        day < 1 ||
        day > 31 ||
        year < 2000 ||
        year > 2101) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a valid date')));
      return;
    }

    if (weight.isNotEmpty && date.isNotEmpty) {
      await _databaseRef.push().set({
        "date": date,
        "weight": weight,
      });
      _fetchWeightEntries(); // Re-fetch entries after adding new one
      _weightController.clear();
      _dateController.clear();
      Navigator.pop(context);
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

  void _showAddWeightDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Weight'),
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
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight',
                    prefixIcon: Icon(Icons.monitor_weight, color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
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
              onPressed: _addWeightEntry,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Logout the user
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route
        .isFirst); // This will pop all routes and take you back to the first screen, typically the login screen
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weight Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWeightDialog,
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: Container(
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
            itemCount: _weightEntries.length,
            itemBuilder: (context, index) {
              final entry = _weightEntries[index];
              final previousWeight = index < _weightEntries.length - 1
                  ? _weightEntries[index + 1]['weight']
                  : null;
              final weightDiff = previousWeight != null
                  ? entry['weight'] - previousWeight
                  : null;

              Widget? weightChangeIndicator;
              if (weightDiff != null) {
                final isGain = weightDiff > 0;
                weightChangeIndicator = Row(
                  children: [
                    Icon(
                      isGain ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isGain ? Colors.red : Colors.green,
                    ),
                    Text(
                      '${weightDiff.abs().toStringAsFixed(1)}',
                      style: TextStyle(
                        color: isGain ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }

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
                  _deleteWeightEntry(entry['key']);
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      'Date: ${entry['date']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          'Weight: ${entry['weight']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 10),
                        if (weightChangeIndicator != null)
                          weightChangeIndicator,
                      ],
                    ),
                    leading: Icon(
                      Icons.fitness_center,
                      color: Colors.red,
                      size: 32,
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
