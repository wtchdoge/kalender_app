import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_test_app/models/appointment_model.dart';
import 'package:database_test_app/utils/id_maps.dart';

class AppointmentsAndAvailability {
  final Map<DateTime, List<Appointment>> termineByDate;
  final Map<DateTime, List<String>> notAvailableByDate;
  AppointmentsAndAvailability(this.termineByDate, this.notAvailableByDate);
}

class AvailabilityService {
  /// Markiert einen Tag für den aktuellen User als verfügbar.
  static Future<void> markDayAsAvailable({
    required String userId,
    required DateTime day,
  }) async {
    // Hole den Benutzernamen aus der users-Collection
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final username = userDoc.data()?['username'] ?? 'Unbekannt';
    final dateKey = '${day.day.toString().padLeft(2, '0')}.${day.month.toString().padLeft(2, '0')}.${day.year.toString()}';
    final abwesenheitRef = FirebaseFirestore.instance.collection('abwesenheit').doc(dateKey);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(abwesenheitRef);
      List<dynamic> fehltListe = [];
      if (snapshot.exists) {
        fehltListe = List.from(snapshot.data()?['fehlt'] ?? []);
      }
      if (fehltListe.contains(username)) {
        fehltListe.remove(username);
      }
      transaction.set(abwesenheitRef, {
        'fehlt': fehltListe,
        'lastChanged': DateTime.now().toIso8601String(),
      });
    });
  }

  /// Lädt alle Termine und die nicht verfügbaren Mitarbeiter pro Tag.
  /// Gibt ein Objekt mit Terminen und nicht verfügbaren Namen pro Tag zurück.
  static Future<AppointmentsAndAvailability> loadAppointmentsAndAvailability() async {
    final Map<DateTime, List<Appointment>> loaded = {};

    // Termine aus Firestore laden
    final firestoreSnap = await FirebaseFirestore.instance.collection('appointments').get();
    for (var doc in firestoreSnap.docs) {
      final appointment = Appointment.fromJson(doc.data(), doc.id);
      final dayKey = DateTime(
        appointment.bookingStart.year,
        appointment.bookingStart.month,
        appointment.bookingStart.day,
      );
      loaded.putIfAbsent(dayKey, () => []);
      loaded[dayKey]!.add(appointment);
    }

    // Abwesenheiten aus der Collection 'abwesenheit' laden
    final notAvailable = <DateTime, List<String>>{};
    final abwesenheitSnap = await FirebaseFirestore.instance.collection('abwesenheit').get();
    for (var doc in abwesenheitSnap.docs) {
      // doc.id ist im Format dd.MM.yyyy
      final dateParts = doc.id.split('.');
      if (dateParts.length == 3) {
        final day = int.tryParse(dateParts[0]);
        final month = int.tryParse(dateParts[1]);
        final year = int.tryParse(dateParts[2]);
        if (year != null && month != null && day != null) {
          final date = DateTime(year, month, day);
          final fehltListe = List<String>.from(doc.data()['fehlt'] ?? []);
          if (fehltListe.isNotEmpty) {
            notAvailable[date] = fehltListe;
          }
        }
      }
    }

    // Filter: Mitarbeiter mit Termin nicht als abwesend anzeigen
    final filteredNotAvailable = <DateTime, List<String>>{};
    notAvailable.forEach((date, names) {
      final appointments = loaded[date] ?? [];
      final mitarbeiterMitTermin = appointments.map((a) {
        return providerMap[a.providerId];
      }).toSet();
      final gefiltert = names.where((name) => !mitarbeiterMitTermin.contains(name)).toList();
      if (gefiltert.isNotEmpty) {
        filteredNotAvailable[date] = gefiltert;
      }
    });

    return AppointmentsAndAvailability(loaded, filteredNotAvailable);
  }

  /// Markiert einen Tag für den aktuellen User als nicht verfügbar.
  static Future<void> markDayAsUnavailable({
    required String userId,
    required DateTime day,
  }) async {
    // Hole den Benutzernamen aus der users-Collection
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final username = userDoc.data()?['username'] ?? 'Unbekannt';
    final dateKey = '${day.day.toString().padLeft(2, '0')}.${day.month.toString().padLeft(2, '0')}.${day.year.toString()}';
    final abwesenheitRef = FirebaseFirestore.instance.collection('abwesenheit').doc(dateKey);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(abwesenheitRef);
      List<dynamic> fehltListe = [];
      if (snapshot.exists) {
        fehltListe = List.from(snapshot.data()?['fehlt'] ?? []);
      }
      if (!fehltListe.contains(username)) {
        fehltListe.add(username);
      }
      transaction.set(abwesenheitRef, {
        'fehlt': fehltListe,
        'lastChanged': DateTime.now().toIso8601String(),
      });
    });
  }
}