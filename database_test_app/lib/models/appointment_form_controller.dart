import 'package:flutter/material.dart';

class AppointmentFormController {
  final TextEditingController strasseController;
  final TextEditingController hausnummerController;
  final TextEditingController plzController;
  final TextEditingController ortController;
  final TextEditingController kundennameController;

  DateTime? start;
  DateTime? end;
  String? status;
  String? providerId;
  int? serviceId;

  AppointmentFormController({
    String? strasse,
    String? hausnummer,
    String? plz,
    String? ort,
    String? kundenname,
    this.start,
    this.end,
    this.status,
    this.providerId,
    this.serviceId,
  })  : strasseController = TextEditingController(text: strasse ?? ''),
        hausnummerController = TextEditingController(text: hausnummer ?? ''),
        plzController = TextEditingController(text: plz ?? ''),
        ortController = TextEditingController(text: ort ?? ''),
        kundennameController = TextEditingController(text: kundenname ?? '');

  void dispose() {
    strasseController.dispose();
    hausnummerController.dispose();
    plzController.dispose();
    ortController.dispose();
    kundennameController.dispose();
  }
}
