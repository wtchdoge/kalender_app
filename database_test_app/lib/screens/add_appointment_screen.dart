// lib/screens/add_appointment_screen.dart

import 'package:flutter/material.dart';
import '../providers/mitarbeiter_provider.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../services/appointment_service.dart';
import '../widgets/address_fields.dart';
import '../widgets/status_dropdown.dart';
import '../widgets/service_dropdown.dart';
import '../models/appointment_form_controller.dart';
import 'package:database_test_app/utils/id_maps.dart' show serviceMap, statusList;

class AddAppointmentScreen extends StatefulWidget {
  final DateTime? selectedDate;
  const AddAppointmentScreen({super.key, this.selectedDate});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  List<DropdownMenuItem<String>> _buildMitarbeiterDropdownItems(List mitarbeiterList) {
    return mitarbeiterList
        .map<DropdownMenuItem<String>>((m) => DropdownMenuItem(
              value: m.id,
              child: Text(m.name),
            ))
        .toList();
  }
  final _formKey = GlobalKey<FormState>();
  late AppointmentFormController formController;

  @override
  void initState() {
    super.initState();
    formController = AppointmentFormController(
      start: widget.selectedDate != null
          ? DateTime(widget.selectedDate!.year, widget.selectedDate!.month, widget.selectedDate!.day, 0, 0)
          : null,
      end: widget.selectedDate != null
          ? DateTime(widget.selectedDate!.year, widget.selectedDate!.month, widget.selectedDate!.day, 0, 0)
          : null,
      status: statusList.first,
      providerId: null, // String statt int
    );
  }

  Future<void> _saveTermin() async {
    final result = await AppointmentService.addAppointmentWithValidation(
      formKey: _formKey,
      start: formController.start,
      end: formController.end,
      providerId: formController.providerId,
      serviceId: formController.serviceId,
      status: formController.status,
      strasse: formController.strasseController.text,
      hausnummer: formController.hausnummerController.text,
      plz: formController.plzController.text,
      ort: formController.ortController.text,
      kundenname: formController.kundennameController.text,
      context: context,
    );
    if (result && mounted) {
      // Terminliste sofort aktualisieren
      try {
        // Provider importiert? Sonst import 'package:provider/provider.dart'; ergänzen
        // ignore: use_build_context_synchronously
        Provider.of<AppointmentProvider>(context, listen: false).fetchAppointments();
      } catch (_) {}
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: formController.start ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (formController.start != null) {
        formController.start = DateTime(picked.year, picked.month, picked.day, formController.start!.hour, formController.start!.minute);
      } else {
        formController.start = DateTime(picked.year, picked.month, picked.day, 0, 0);
      }
      if (formController.end != null) {
        formController.end = DateTime(picked.year, picked.month, picked.day, formController.end!.hour, formController.end!.minute);
      } else {
        formController.end = DateTime(picked.year, picked.month, picked.day, 0, 0);
      }
    });
  }

  Future<void> _pickTime(bool isStart) async {
    final initialTime = isStart
        ? (formController.start != null ? TimeOfDay(hour: formController.start!.hour, minute: formController.start!.minute) : TimeOfDay.now())
        : (formController.end != null ? TimeOfDay(hour: formController.end!.hour, minute: formController.end!.minute) : TimeOfDay.now());
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        final date = formController.start ?? DateTime.now();
        formController.start = DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
      } else {
        final date = formController.end ?? formController.start ?? DateTime.now();
        formController.end = DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neuer Termin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Consumer<MitarbeiterProvider>(
            builder: (context, mitarbeiterProvider, _) {
              final mitarbeiterList = mitarbeiterProvider.mitarbeiter;
              return ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formController.start == null
                              ? 'Datum: wählen'
                              : 'Datum: ${formController.start!.day.toString().padLeft(2, '0')}.${formController.start!.month.toString().padLeft(2, '0')}.${formController.start!.year.toString().substring(2)}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: _pickDate,
                        child: const Text('Datum ändern'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formController.start == null
                              ? 'Start: wählen'
                              : 'Start: ${formController.start!.hour.toString().padLeft(2, '0')}:${formController.start!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _pickTime(true),
                        child: const Text('Startzeit ändern'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formController.end == null
                              ? 'Ende: wählen'
                              : 'Ende: ${formController.end!.hour.toString().padLeft(2, '0')}:${formController.end!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _pickTime(false),
                        child: const Text('Endzeit ändern'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: formController.providerId,
                    items: _buildMitarbeiterDropdownItems(mitarbeiterList),
                    onChanged: (val) => setState(() => formController.providerId = val),
                    validator: (val) => val == null ? "Bitte Mitarbeiter wählen" : null,
                    decoration: const InputDecoration(labelText: 'Mitarbeiter'),
                  ),
                  const SizedBox(height: 16),
                  ServiceDropdown(
                    value: formController.serviceId,
                    serviceMap: serviceMap,
                    onChanged: (val) => setState(() => formController.serviceId = val),
                    validator: (val) => val == null ? "Bitte Dienstleistung wählen" : null,
                  ),
                  const SizedBox(height: 16),
                  StatusDropdown(
                    value: formController.status,
                    statusList: statusList,
                    onChanged: (val) => setState(() => formController.status = val),
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
                  ElevatedButton(
                    onPressed: _saveTermin,
                    child: const Text("Termin speichern"),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }
}


