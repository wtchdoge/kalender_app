import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_model.dart';
import '../widgets/appointment_card.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  Future<List<Appointment>> _fetchMitarbeiterAppointments() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    // 1. Hole das Mitarbeiter-Dokument, das zu dieser userId gehört
    final mitarbeiterSnapshot = await FirebaseFirestore.instance
        .collection('mitarbeiter')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (mitarbeiterSnapshot.docs.isEmpty) return [];

    // 2. Die Mitarbeiter-ID ist der Dokumentname (id)
    final mitarbeiterId = mitarbeiterSnapshot.docs.first.id;

    // 3. Suche alle Termine, bei denen providerId == mitarbeiterId
    final query = await FirebaseFirestore.instance
        .collection('appointments')
        .where('providerId', isEqualTo: mitarbeiterId)
        .get();

    return query.docs
        .map((doc) => Appointment.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Mitarbeiter-Termine')),
      body: FutureBuilder<List<Appointment>>(
        future: _fetchMitarbeiterAppointments(),
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

          // Sortiere nach Startzeit
          final now = DateTime.now();
          final upcoming = appointments.where((a) => a.bookingStart.isAfter(now)).toList();
          upcoming.sort((a, b) => a.bookingStart.compareTo(b.bookingStart));

          Appointment? next;
          List<Appointment> rest = [];
          if (upcoming.isNotEmpty) {
            next = upcoming.first;
            rest = upcoming.skip(1).toList();
          }

          return ListView(
            children: [
              if (next != null) ...[
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Nächster Termin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                AppointmentCard(appointment: next),
              ],
              if (rest.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Bevorstehende Termine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...rest.map((appt) => AppointmentCard(appointment: appt)),
              ],
              if (upcoming.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Keine bevorstehenden Termine.', style: TextStyle(fontSize: 16)),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
