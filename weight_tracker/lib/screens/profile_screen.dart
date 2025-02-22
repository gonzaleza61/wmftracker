import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _goalController;

  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _goalController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await _database.child('users/$userId/profile').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _heightController.text = data['height'] ?? '';
          _goalController.text = data['goal'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    setState(() => _isLoading = true);

    try {
      await _database.child('users/$userId/profile').set({
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'height': _heightController.text,
        'goal': _goalController.text,
        'lastUpdated': ServerValue.timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildDisplayTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        subtitle: Text(value.isEmpty ? 'Not set' : value),
        trailing: _isEditing ? Icon(Icons.edit) : null,
      ),
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.red,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  _saveProfile();
                  setState(() => _isEditing = false);
                }
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red.shade100,
                child: Icon(Icons.person, size: 50, color: Colors.red),
              ),
              SizedBox(height: 24),
              if (_isEditing) ...[
                _buildEditField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                ),
                SizedBox(height: 16),
                _buildEditField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _buildEditField(
                  controller: _heightController,
                  label: 'Height',
                  icon: Icons.height,
                ),
                SizedBox(height: 16),
                _buildEditField(
                  controller: _goalController,
                  label: 'Fitness Goal',
                  icon: Icons.flag,
                  maxLines: 3,
                ),
              ] else ...[
                _buildDisplayTile(
                  title: 'Name',
                  value: _nameController.text,
                  icon: Icons.person,
                ),
                _buildDisplayTile(
                  title: 'Age',
                  value: _ageController.text,
                  icon: Icons.calendar_today,
                ),
                _buildDisplayTile(
                  title: 'Height',
                  value: _heightController.text,
                  icon: Icons.height,
                ),
                _buildDisplayTile(
                  title: 'Fitness Goal',
                  value: _goalController.text,
                  icon: Icons.flag,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _goalController.dispose();
    super.dispose();
  }
}
