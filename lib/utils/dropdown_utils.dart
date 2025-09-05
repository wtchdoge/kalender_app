// lib/utils/dropdown_utils.dart
import 'package:flutter/material.dart';

class DropdownUtils {
  /// Builds dropdown items from a list of strings.
  static List<DropdownMenuItem<String>> fromStringList(List<String> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ))
        .toList();
  }

  /// Builds dropdown items from a map with custom label formatting.
  static List<DropdownMenuItem<String>> fromMap(Map<String, dynamic> map, {String Function(MapEntry<String, dynamic>)? labelBuilder}) {
    return map.entries
        .map((entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Text(labelBuilder != null ? labelBuilder(entry) : entry.key),
            ))
        .toList();
  }
}
