import 'package:database_test_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../models/appointment_form_controller.dart';
import '../providers/employee_provider.dart';
import '../utils/id_maps.dart';
import '../services/appointment_service.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_form.dart';



class EditAppointmentScreen extends StatefulWidget {
  final Appointment appointment;
  const EditAppointmentScreen({super.key, required this.appointment});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late AppointmentFormController formController;

  @override
  void initState() {
    super.initState();
    formController = AppointmentFormController(
      strasse: widget.appointment.strasse,
      hausnummer: widget.appointment.hausnummer,
      plz: widget.appointment.plz,
      ort: widget.appointment.ort,
      kundenname: widget.appointment.kundenname,
      start: widget.appointment.bookingStart,
      end: widget.appointment.bookingEnd,
      status: statusList.contains(widget.appointment.status)
          ? widget.appointment.status
          : statusList.first,
      providerId: widget.appointment.providerId,
      serviceId: widget.appointment.serviceId,
    );
  }

  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: formController.start ?? DateTime.now(),
      firstDate: DateTime(2020),
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
    final dienstleistung = serviceMap[widget.appointment.serviceId]?['dienstleistung'] ?? 'Unbekannt';
    final kategorie = serviceMap[widget.appointment.serviceId]?['kategorie'] ?? 'Unbekannt';

    return Scaffold(
      appBar: AppBar(title: const Text('Termin bearbeiten')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<EmployeeProvider>(
          builder: (context, mitarbeiterProvider, _) {
            final mitarbeiterList = mitarbeiterProvider.mitarbeiter;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dienstleistung,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text('Kategorie: $kategorie', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 12),
                Expanded(
                  child: AppointmentForm(
                    formController: formController,
                    formKey: _formKey,
                    mitarbeiterList: mitarbeiterList,
                    onSave: _saveTermin,
                    onPickDate: _pickDate,
                    onPickTime: _pickTime,
                    saveButtonText: 'Speichern',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveTermin() async {
    final newAppointment = {
      'bookingStart': formController.start?.toIso8601String(),
      'bookingEnd': formController.end?.toIso8601String(),
      'providerId': formController.providerId,
      'serviceId': widget.appointment.serviceId,
      'status': formController.status,
      'created': widget.appointment.created.toIso8601String(),
      'strasse': formController.strasseController.text,
      'hausnummer': formController.hausnummerController.text,
      'plz': formController.plzController.text,
      'ort': formController.ortController.text,
      'kundenname': formController.kundennameController.text.isEmpty ? 'Unbekannt' : formController.kundennameController.text,
      'userId': null, // Optional: userId falls vorhanden
    };

    final success = await AppointmentService.updateAppointment(widget.appointment.id, newAppointment);

    if (success) {
      try {
        Provider.of<AppointmentProvider>(context, listen: false).fetchAppointments();
      } catch (_) {}
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Änderungen gespeichert!'),
          backgroundColor: AppColors.accent,
        ),
      );
      Navigator.of(context).pop(); // Edit-Screen schließen
      Navigator.of(context).pop(); // Details-Screen schließen, zurück zur Liste
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Fehler beim Speichern!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
