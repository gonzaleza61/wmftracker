import 'package:flutter/material.dart';

class TrainersScreen extends StatelessWidget {
  const TrainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildTrainerCard(
            'John Smith',
            'Strength & Conditioning',
            'assets/trainer1.jpg',
            '10+ years experience in powerlifting',
          ),
          _buildTrainerCard(
            'Sarah Johnson',
            'CrossFit Specialist',
            'assets/trainer2.jpg',
            'CrossFit Level 2 Trainer',
          ),
          _buildTrainerCard(
            'Mike Wilson',
            'Nutrition Expert',
            'assets/trainer3.jpg',
            'Certified Nutritionist',
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(
      String name, String specialty, String imagePath, String description) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(name),
            subtitle: Text(specialty),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(description),
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {},
                child: Text('VIEW PROFILE'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('CONTACT'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
