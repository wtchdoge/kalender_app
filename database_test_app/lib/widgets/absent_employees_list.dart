import 'package:flutter/material.dart';

class AbsentEmployeesList extends StatelessWidget {
  final List<String> names;
  const AbsentEmployeesList({super.key, required this.names});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Abwesende Mitarbeiter:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...names.map((name) => Text(name, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
