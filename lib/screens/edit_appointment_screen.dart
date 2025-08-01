import 'package:database_test_app/theme/app_theme.dart';
import '../utils/app_snackbar.dart';
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
    await AppointmentFormController.pickDate(
      context: context,
      controller: formController,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    setState(() {});
  }

  Future<void> _pickTime(bool isStart) async {
    await AppointmentFormController.pickTime(
      context: context,
      controller: formController,
      isStart: isStart,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termin bearbeiten')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<EmployeeProvider>(
          builder: (context, mitarbeiterProvider, _) {
            final mitarbeiterList = mitarbeiterProvider.mitarbeiter;
            return AppointmentForm(
              formController: formController,
              formKey: _formKey,
              mitarbeiterList: mitarbeiterList,
              onSave: _saveTermin,
              onPickDate: _pickDate,
              onPickTime: _pickTime,
              saveButtonText: 'Speichern',
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
      AppSnackBar.show(context, 'Änderungen gespeichert!', color: AppColors.accent);
      Navigator.of(context).pop(); // Edit-Screen schließen
      Navigator.of(context).pop(); // Details-Screen schließen, zurück zur Liste
    } else {
      AppSnackBar.show(context, 'Fehler beim Speichern!', color: Colors.red);
    }
  }
}
