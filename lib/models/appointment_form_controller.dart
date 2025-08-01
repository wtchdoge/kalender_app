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

  /// Zeigt einen DatePicker an und aktualisiert start und end im Controller.
  static Future<void> pickDate({
    required BuildContext context,
    required AppointmentFormController controller,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.start ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
    );
    if (picked == null) return;
    // ignore: invalid_use_of_protected_member
    if (controller.start != null) {
      controller.start = DateTime(picked.year, picked.month, picked.day, controller.start!.hour, controller.start!.minute);
    } else {
      controller.start = DateTime(picked.year, picked.month, picked.day, 0, 0);
    }
    if (controller.end != null) {
      controller.end = DateTime(picked.year, picked.month, picked.day, controller.end!.hour, controller.end!.minute);
    } else {
      controller.end = DateTime(picked.year, picked.month, picked.day, 0, 0);
    }
  }

  /// Zeigt einen TimePicker an und aktualisiert start oder end im Controller.
  static Future<void> pickTime({
    required BuildContext context,
    required AppointmentFormController controller,
    required bool isStart,
  }) async {
    final initialTime = isStart
        ? (controller.start != null ? TimeOfDay(hour: controller.start!.hour, minute: controller.start!.minute) : TimeOfDay.now())
        : (controller.end != null ? TimeOfDay(hour: controller.end!.hour, minute: controller.end!.minute) : TimeOfDay.now());
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked == null) return;
    if (isStart) {
      final date = controller.start ?? DateTime.now();
      controller.start = DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
    } else {
      final date = controller.end ?? controller.start ?? DateTime.now();
      controller.end = DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
    }
  }
}
