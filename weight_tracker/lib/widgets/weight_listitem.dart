import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightListTile extends StatelessWidget {
  const WeightListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.arrow_upward,
          color: Colors.green,
        ),
        title: const Text('Weight Number'),
        trailing: Text(DateFormat.yMMMd().format(DateTime.now())),
      ),
    );
  }
}
