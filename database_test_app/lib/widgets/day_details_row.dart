import 'package:flutter/material.dart';
import 'package:database_test_app/widgets/appointment_list.dart';
import 'package:database_test_app/widgets/availability_card.dart';
import 'package:database_test_app/models/appointment_model.dart';

class DayDetailsRow extends StatelessWidget {
  final List<Appointment> appointments;
  final List<String>? notAvailableList;
  final DateTime? dayKey;
  const DayDetailsRow({super.key, required this.appointments, required this.notAvailableList, required this.dayKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppointmentList(appointments: appointments),
        ),
        if (notAvailableList != null && notAvailableList!.isNotEmpty)
          Expanded(
            child: AvailabilityCard(mitarbeiterIds: notAvailableList!, date: dayKey!),
          ),
      ],
    );
  }
}
