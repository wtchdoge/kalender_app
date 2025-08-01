// lib/utils/date_utils.dart

class DateUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return 'Datum: wählen';
    return 'Datum: ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year.toString().substring(2)}';
  }

  static String formatTime(DateTime? date, {required String label}) {
    if (date == null) return '$label: wählen';
    return '$label: ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
