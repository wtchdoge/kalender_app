// lib/widgets/appointment_card.dart
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../utils/id_maps.dart';
import 'package:provider/provider.dart';
import '../models/employee_model.dart';
import '../providers/employee_provider.dart';
import '../utils/date_utils.dart' as AppDateUtils;
import '../screens/appointment_details_screen.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final dienstleistung = serviceMap[appointment.serviceId]?['dienstleistung'] ?? 'Unbekannt';
    final mitarbeiterProvider = Provider.of<EmployeeProvider>(context);
    final mitarbeiter = mitarbeiterProvider.mitarbeiter.firstWhere(
      (m) => m.id == appointment.providerId,
      orElse: () => Employee(id: appointment.providerId, name: 'Unbekannt'),
    ).name;
    final date = AppDateUtils.DateUtils.formatDate(appointment.bookingStart);
    final startTime = AppDateUtils.DateUtils.formatTime(appointment.bookingStart, label: 'Start');
    final endTime = AppDateUtils.DateUtils.formatTime(appointment.bookingEnd, label: 'Ende');

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dienstleistung,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Datum: $date',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Uhrzeit: $startTime - $endTime'),
            Text('Mitarbeiter: $mitarbeiter'),
            Text('Status: ${appointment.status}'),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AppointmentDetailsScreen(appointment: appointment),
            ),
          );
        },
      ),
    );
  }
}
