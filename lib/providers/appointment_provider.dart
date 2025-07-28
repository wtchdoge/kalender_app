// lib/providers/appointment_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentProvider with ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  Future<void> fetchAppointments() async {
    try {
      _appointments.clear();

      // Nur Firestore Termine laden
      final firestoreSnap = await FirebaseFirestore.instance.collection('appointments').get();
      for (var doc in firestoreSnap.docs) {
        final appointment = Appointment.fromJson(doc.data(), doc.id);
        _appointments.add(appointment);
      }

      notifyListeners();
    } catch (e) {
      print('❌ Fehler beim Laden der Termine: $e');
    }
  }
}
