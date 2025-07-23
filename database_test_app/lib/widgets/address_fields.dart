import 'package:flutter/material.dart';

class AddressFields extends StatelessWidget {
  final TextEditingController strasseController;
  final TextEditingController hausnummerController;
  final TextEditingController plzController;
  final TextEditingController ortController;

  const AddressFields({
    super.key,
    required this.strasseController,
    required this.hausnummerController,
    required this.plzController,
    required this.ortController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: strasseController,
          decoration: const InputDecoration(labelText: 'Straße'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: hausnummerController,
          decoration: const InputDecoration(labelText: 'Nr'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: plzController,
          decoration: const InputDecoration(labelText: 'PLZ'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ortController,
          decoration: const InputDecoration(labelText: 'Ort'),
        ),
      ],
    );
  }
}
