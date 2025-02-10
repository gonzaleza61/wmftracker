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
  final _bodyweightController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance
      .ref()
      .child('prs')
      .child(FirebaseAuth.instance.currentUser!.uid);
  List<Map<String, dynamic>> _prEntries = [];
  String _selectedGender = 'Male';
  String _selectedLift = 'Bench';
  String _strengthLevel = '';

  @override
  void initState() {
    super.initState();
    _fetchPREntries();
  }

  String _calculateStrengthLevel(
      double bodyweight, double maxLift, String gender, String lift) {
    // Strength standards as multipliers of bodyweight
    final standards = {
      'Male': {
        'Bench': {
          'Untrained': 0.5,
          'Novice': 0.8,
          'Intermediate': 1.0,
          'Advanced': 1.5,
          'Elite': 2.0,
        },
        'Squat': {
          'Untrained': 0.75,
          'Novice': 1.2,
          'Intermediate': 1.5,
          'Advanced': 2.0,
          'Elite': 2.5,
        },
        'Deadlift': {
          'Untrained': 1.0,
          'Novice': 1.5,
          'Intermediate': 2.0,
          'Advanced': 2.5,
          'Elite': 3.0,
        },
      },
      'Female': {
        'Bench': {
          'Untrained': 0.3,
          'Novice': 0.5,
          'Intermediate': 0.75,
          'Advanced': 1.0,
          'Elite': 1.25,
        },
        'Squat': {
          'Untrained': 0.5,
          'Novice': 0.8,
          'Intermediate': 1.1,
          'Advanced': 1.5,
          'Elite': 2.0,
        },
        'Deadlift': {
          'Untrained': 0.75,
          'Novice': 1.0,
          'Intermediate': 1.5,
          'Advanced': 2.0,
          'Elite': 2.5,
        },
      },
    };

    final ratio = maxLift / bodyweight;
    final levelStandards = standards[gender]![lift]!;

    if (ratio >= levelStandards['Elite']!) return 'Elite';
    if (ratio >= levelStandards['Advanced']!) return 'Advanced';
    if (ratio >= levelStandards['Intermediate']!) return 'Intermediate';
    if (ratio >= levelStandards['Novice']!) return 'Novice';
    return 'Untrained';
  }

  void _fetchPREntries() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      setState(() {
        _prEntries = [];
        Map<dynamic, dynamic> data = snapshot.value as Map;
        data.forEach((key, value) {
          _prEntries.add({
            "key": key,
            "workout": value["workout"],
            "pr": value["pr"],
            "bodyweight": value["bodyweight"],
            "gender": value["gender"],
            "lift": value["lift"],
            "strengthLevel": value["strengthLevel"],
          });
        });
      });
    }
  }

  void _showStrengthStandardsDialog() {
    // Reset controllers and strength level
    _prController.clear();
    _bodyweightController.clear();
    _strengthLevel = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Check Your Strength Level'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['Male', 'Female'].map((String gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLift,
                    decoration: InputDecoration(
                      labelText: 'Lift Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['Bench', 'Squat', 'Deadlift'].map((String lift) {
                      return DropdownMenuItem(
                        value: lift,
                        child: Text(lift),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLift = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _bodyweightController,
                    decoration: InputDecoration(
                      labelText: 'Body Weight (lbs)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _prController,
                    decoration: InputDecoration(
                      labelText: 'Max Lift (lbs)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  if (_strengthLevel.isNotEmpty)
                    Text(
                      'Your strength level: $_strengthLevel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Calculate'),
                  onPressed: () async {
                    if (_bodyweightController.text.isNotEmpty &&
                        _prController.text.isNotEmpty) {
                      final bodyweight =
                          double.parse(_bodyweightController.text);
                      final maxLift = double.parse(_prController.text);
                      final strengthLevel = _calculateStrengthLevel(
                        bodyweight,
                        maxLift,
                        _selectedGender,
                        _selectedLift,
                      );

                      setState(() {
                        _strengthLevel = strengthLevel;
                      });

                      try {
                        await _databaseRef.push().set({
                          "workout": _selectedLift,
                          "pr": maxLift.toString(),
                          "bodyweight": bodyweight.toString(),
                          "gender": _selectedGender,
                          "lift": _selectedLift,
                          "strengthLevel": strengthLevel,
                        });

                        _fetchPREntries();
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Error saving entry: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deletePREntry(String key) async {
    try {
      await _databaseRef.child(key).remove();
      _fetchPREntries();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entry deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting entry: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation(String key) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this PR entry?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deletePREntry(key);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'PR Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showStrengthStandardsDialog,
        backgroundColor: Colors.red,
        child: Icon(Icons.calculate),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/WMFlogo.PNG'),
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
            itemCount: _prEntries.length,
            itemBuilder: (context, index) {
              final entry = _prEntries[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    '${entry["lift"]} - ${entry["strengthLevel"]}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: Text(
                    'PR: ${entry["pr"]} lbs\nBodyweight: ${entry["bodyweight"]} lbs\nGender: ${entry["gender"]}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  leading: Icon(
                    Icons.emoji_events,
                    color: Colors.red,
                    size: 32,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(entry['key']),
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
