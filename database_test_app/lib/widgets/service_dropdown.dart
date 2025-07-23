import 'package:flutter/material.dart';

class ServiceDropdown extends StatelessWidget {
  final int? value;
  final Map<int, Map<String, dynamic>> serviceMap;
  final void Function(int?)? onChanged;
  final String? Function(int?)? validator;

  const ServiceDropdown({
    super.key,
    required this.value,
    required this.serviceMap,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: const InputDecoration(labelText: 'Dienstleistung'),
      isExpanded: true,
      items: serviceMap.entries
          .map((e) => DropdownMenuItem(
                value: e.key,
                child: Text("${e.value['dienstleistung']} - ${e.value['kategorie']}"),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
