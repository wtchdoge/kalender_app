import 'package:flutter/material.dart';
import '../utils/dropdown_utils.dart';

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
      items: DropdownUtils.fromMap(
        serviceMap.map((k, v) => MapEntry(k.toString(), v)),
        labelBuilder: (entry) => "${entry.value['dienstleistung']} - ${entry.value['kategorie']}",
      ).map((item) => DropdownMenuItem<int>(
        value: int.tryParse(item.value ?? ''),
  child: item.child,
      )).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
