import 'package:flutter/material.dart';
import 'package:database_test_app/widgets/absent_employees_list.dart';

class AvailabilityDetailsScreen extends StatelessWidget {
  final List<String> names;
  final DateTime date;

  const AvailabilityDetailsScreen({super.key, required this.names, required this.date});

  @override
  Widget build(BuildContext context) {
    final dateStr = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abwesenheitsdetails'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datum: $dateStr', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            AbsentEmployeesList(names: names),
          ],
        ),
      ),
    );
  }
}
