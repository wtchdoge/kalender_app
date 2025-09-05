import 'package:flutter/material.dart';
import '../utils/dropdown_utils.dart';

class StatusDropdown extends StatelessWidget {
  final String? value;
  final List<String> statusList;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const StatusDropdown({
    super.key,
    required this.value,
    required this.statusList,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(labelText: 'Status'),
  items: DropdownUtils.fromStringList(statusList),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
