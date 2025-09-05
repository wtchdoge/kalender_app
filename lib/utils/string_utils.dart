// lib/utils/string_utils.dart

class StringUtils {
  /// Returns [value] if it is not null and not empty, otherwise returns [fallback] (default: 'Unbekannt').
  static String displayOrUnknown(String? value, {String fallback = 'Unbekannt'}) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value;
  }
}
