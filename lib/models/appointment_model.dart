// lib/models/appointment_model.dart
import '../utils/string_utils.dart';
class Appointment {
  final String id;
  final int serviceId;
  final String providerId;
  final DateTime bookingStart;
  final DateTime bookingEnd;
  final String status;
  final DateTime created;
  final String? strasse;
  final String? kundenname;
  final String? hausnummer;
  final String? plz;
  final String? ort;

  Appointment({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.bookingStart,
    required this.bookingEnd,
    required this.status,
    required this.created,
    this.strasse,
    this.hausnummer,
    this.plz,
    this.ort,
    this.kundenname,
  });

  factory Appointment.fromJson(Map<String, dynamic> json, String firebaseId) {
    return Appointment(
      id: firebaseId,
      serviceId: int.tryParse(json['serviceId'].toString()) ?? 0,
      providerId: StringUtils.displayOrUnknown(json['providerId']?.toString(), fallback: ''),
      bookingStart: DateTime.parse(json['bookingStart']),
      bookingEnd: DateTime.parse(json['bookingEnd']),
      status: StringUtils.displayOrUnknown(json['status'], fallback: ''),
      created: DateTime.parse(json['created']),
      strasse: StringUtils.displayOrUnknown(json['strasse']),
      hausnummer: StringUtils.displayOrUnknown(json['hausnummer'], fallback: ''),
      plz: StringUtils.displayOrUnknown(json['plz'], fallback: ''),
      ort: StringUtils.displayOrUnknown(json['ort'], fallback: ''),
      kundenname: StringUtils.displayOrUnknown(json['kundenname']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'providerId': providerId,
      'bookingStart': bookingStart.toIso8601String(),
      'bookingEnd': bookingEnd.toIso8601String(),
      'status': status,
      'created': created.toIso8601String(),
      'strasse': strasse,
      'hausnummer': hausnummer,
      'plz': plz,
      'ort': ort,
      'kundenname': kundenname,
    };
  }
}
