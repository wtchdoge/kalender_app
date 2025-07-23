import 'package:flutter/material.dart';

class ProviderDropdown extends StatelessWidget {
  final int? value;
  final Map<int, String> providerMap;
  final void Function(int?)? onChanged;
  final String? Function(int?)? validator;

  const ProviderDropdown({
    super.key,
    required this.value,
    required this.providerMap,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: const InputDecoration(labelText: 'Mitarbeiter'),
      isExpanded: true,
      items: providerMap.entries
          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
