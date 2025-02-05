import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightListTileDown extends StatelessWidget {
  const WeightListTileDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.arrow_downward,
          color: Colors.red,
        ),
        title: const Text('Weight Number Down'),
        trailing: Text(DateFormat.yMMMd().format(DateTime.now())),
      ),
    );
  }
}
