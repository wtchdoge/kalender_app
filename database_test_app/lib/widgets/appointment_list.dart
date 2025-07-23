import 'package:flutter/material.dart';
import 'package:database_test_app/models/appointment_model.dart';
import 'package:database_test_app/widgets/appointment_card.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;
  const AppointmentList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Center(child: Text("Keine Termine an diesem Tag."));
    }
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointmentCard(appointment: appointment);
      },
    );
  }
}
