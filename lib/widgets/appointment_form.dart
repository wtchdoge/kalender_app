import 'package:flutter/material.dart';
import '../models/appointment_form_controller.dart';
import '../widgets/address_fields.dart';
import '../widgets/status_dropdown.dart';
import '../widgets/service_dropdown.dart';
import 'package:database_test_app/utils/id_maps.dart' show serviceMap, statusList;
import '../utils/date_utils.dart' as AppDateUtils;

class AppointmentForm extends StatelessWidget {
  final AppointmentFormController formController;
  final GlobalKey<FormState> formKey;
  final List mitarbeiterList;
  final VoidCallback onSave;
  final void Function()? onCancel;
  final void Function()? onPickDate;
  final void Function(bool isStart)? onPickTime;
  final String saveButtonText;

  const AppointmentForm({
    super.key,
    required this.formController,
    required this.formKey,
    required this.mitarbeiterList,
    required this.onSave,
    this.onCancel,
    this.onPickDate,
    this.onPickTime,
    this.saveButtonText = 'Termin speichern',
  });

  List<DropdownMenuItem<String>> _buildMitarbeiterDropdownItems(List mitarbeiterList) {
    return mitarbeiterList
        .map<DropdownMenuItem<String>>((m) => DropdownMenuItem(
              value: m.id,
              child: Text(m.name),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppDateUtils.DateUtils.formatDate(formController.start),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: onPickDate,
                child: const Text('Datum ändern'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppDateUtils.DateUtils.formatTime(formController.start, label: 'Start'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => onPickTime?.call(true),
                child: const Text('Startzeit ändern'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppDateUtils.DateUtils.formatTime(formController.end, label: 'Ende'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => onPickTime?.call(false),
                child: const Text('Endzeit ändern'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: formController.providerId,
            items: _buildMitarbeiterDropdownItems(mitarbeiterList),
            onChanged: (val) => formController.providerId = val,
            validator: (val) => val == null ? "Bitte Mitarbeiter wählen" : null,
            decoration: const InputDecoration(labelText: 'Mitarbeiter'),
          ),
          const SizedBox(height: 16),
          ServiceDropdown(
            value: formController.serviceId,
            serviceMap: serviceMap,
            onChanged: (val) => formController.serviceId = val,
            validator: (val) => val == null ? "Bitte Dienstleistung wählen" : null,
          ),
          const SizedBox(height: 16),
          StatusDropdown(
            value: formController.status,
            statusList: statusList,
            onChanged: (val) => formController.status = val,
            validator: (val) => val == null ? "Bitte Status wählen" : null,
          ),
          const SizedBox(height: 16),
          AddressFields(
            strasseController: formController.strasseController,
            hausnummerController: formController.hausnummerController,
            plzController: formController.plzController,
            ortController: formController.ortController,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: formController.kundennameController,
            decoration: const InputDecoration(labelText: 'Kunde'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onSave,
                  child: Text(saveButtonText),
                ),
              ),
              if (onCancel != null)
                const SizedBox(width: 12),
              if (onCancel != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Abbrechen'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
