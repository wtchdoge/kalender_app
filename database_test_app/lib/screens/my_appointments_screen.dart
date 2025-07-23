import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_model.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  Future<List<Appointment>> _fetchUserAppointments() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final query = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: user.uid)
        .get();
    return query.docs
        .map((doc) => Appointment.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Termine')),
      body: FutureBuilder<List<Appointment>>(
        future: _fetchUserAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }
          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return const Center(child: Text('Keine Termine gefunden.'));
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              return ListTile(
                title: Text(appt.kundenname ?? 'Unbekannt'),
                subtitle: Text('${appt.bookingStart} - ${appt.status}'),
              );
            },
          );
        },
      ),
    );
  }
}
