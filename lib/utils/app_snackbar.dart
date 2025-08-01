import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(BuildContext context, String text, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color ?? Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
