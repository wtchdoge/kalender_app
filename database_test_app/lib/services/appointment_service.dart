import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  /// Fügt einen neuen Termin hinzu, inklusive Validierung und UserId-Check. Zeigt Fehler per SnackBar an.
  static Future<bool> addAppointmentWithValidation({
    required GlobalKey<FormState> formKey,
    required DateTime? start,
    required DateTime? end,
    required String? providerId,
    required int? serviceId,
    required String? status,
    required String strasse,
    required String hausnummer,
    required String plz,
    required String ort,
    required String kundenname,
    required BuildContext context,
  }) async {
    if (!formKey.currentState!.validate() || start == null || end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte alle Felder korrekt ausfüllen!'), backgroundColor: Colors.red),
      );
      return false;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nicht eingeloggt!'), backgroundColor: Colors.red),
      );
      return false;
    }

    final newEntry = {
      'bookingStart': start.toIso8601String(),
      'bookingEnd': end.toIso8601String(),
      'providerId': providerId,
      'serviceId': serviceId,
      'status': status,
      'created': DateTime.now().toIso8601String(),
      'strasse': strasse,
      'hausnummer': hausnummer,
      'plz': plz,
      'ort': ort,
      'kundenname': kundenname.isEmpty ? 'Unbekannt' : kundenname,
      'userId': userId,
    };

    await addAppointment(newEntry, providerId: providerId, start: start);
    return true;
  }

  /// Fügt einen neuen Termin in Firestore hinzu und aktualisiert die Verfügbarkeit.
  static Future<void> addAppointment(Map<String, dynamic> newEntry, {String? providerId, DateTime? start}) async {
    await FirebaseFirestore.instance.collection('appointments').add(newEntry);

    // Neue Abwesenheits-Logik: Fehlende Mitarbeiter pro Tag in 'abwesenheiten' speichern (mit Namen)
    if (start != null && providerId != null) {
      final dateKey = '${start.day.toString().padLeft(2, '0')}-${start.month.toString().padLeft(2, '0')}-${start.year.toString().padLeft(4, '0')}';
      final abwesenheitenRef = FirebaseFirestore.instance.collection('Unterwegs').doc(dateKey);
      // providerMap ist nicht mehr gültig, daher einfach die ID als Name verwenden
      final mitarbeiterName = providerId;
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(abwesenheitenRef);
        List<dynamic> fehltListe = [];
        if (snapshot.exists) {
          fehltListe = List.from(snapshot.data()?['fehlt'] ?? []);
        }
        if (!fehltListe.contains(mitarbeiterName)) {
          fehltListe.add(mitarbeiterName);
        }
        transaction.set(abwesenheitenRef, {
          'fehlt': fehltListe,
          'lastChanged': DateTime.now().toIso8601String(),
        });
      });
    }
  }
  /// Gibt alle Termine für einen bestimmten Tag aus einer Map zurück.
  static List<Appointment> getAppointmentsForDay(
    Map<DateTime, List<Appointment>> termineByDate,
    DateTime day,
  ) {
    final key = DateTime(day.year, day.month, day.day);
    return termineByDate[key] ?? [];
  }

  /// Löscht einen Termin anhand seiner ID aus Firestore
  static Future<void> deleteAppointment(String appointmentId) async {
    await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).delete();
  }

  /// Aktualisiert einen Termin anhand seiner ID. Gibt true bei Erfolg, false bei Fehler zurück.
  static Future<bool> updateAppointment(String appointmentId, Map<String, dynamic> newData) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('appointments').doc(appointmentId);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        await docRef.update(newData);
      } else {
        await FirebaseFirestore.instance.collection('appointments').add(newData);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
