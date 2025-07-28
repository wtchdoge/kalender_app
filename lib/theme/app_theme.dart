import 'package:flutter/material.dart';

class AppColors {
  // 🌲 Hauptfarbe – für AppBar, Schaltflächen, Icons, primäre Interaktionen
  static const Color primary = Color(0xFF276B56);

  // 🌿 Sekundärfarbe – für unterstützende Aktionen, z.B. FloatingActionButton, Links
  static const Color secondary = Color(0xFF41A58D);

  // 🕊 Hellgrüner Hintergrund – z.B. für Seitenhintergrund, Karten oder leichte Flächen
  static const Color backgroundLight = Color(0xFFF1FCFA);

  // 🌫 Helles Grau – für Container, Trennlinien, zarte UI-Elemente
  static const Color lightGray = Color(0xFFF6F6F6);

  // 🖋 Dunkler Text – für Fließtext, Headlines (auf hellem Hintergrund)
  static const Color textDark = Color(0xFF333333);

  // 🧊 Heller Text – z.B. für Texte auf primärfarbigen Buttons oder Dark Mode
  static const Color textLight = Color(0xFFFFFFFF);

  // 🍊 Akzentfarbe – optional für Buttons, Warnungen oder Call-to-Actions
  static const Color accent = Color(0xFFF29E4C);

  // 🖤 Standard-Schwarz (kann z. B. für Schatten oder tiefdunklen Text verwendet werden)
  static const Color black = Color(0xFF000000);

  // ⚪ Standard-Weiß – z.B. für Flächen, Hintergründe, Texte auf dunklem Grund
  static const Color white = Color(0xFFFFFFFF);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  cardColor: AppColors.white,
  dividerColor: AppColors.lightGray,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textLight,
    elevation: 2,
    iconTheme: const IconThemeData(color: AppColors.textLight),
    titleTextStyle: const TextStyle(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textLight,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textLight,
    background: AppColors.backgroundLight,
    onBackground: AppColors.textDark,
    surface: AppColors.white,
    onSurface: AppColors.textDark,
    error: AppColors.accent,
    onError: AppColors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.textLight,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.textDark),
    bodyLarge: TextStyle(color: AppColors.textDark),
    titleLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    labelLarge: TextStyle(color: AppColors.secondary),
    headlineSmall: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightGray,
    labelStyle: const TextStyle(color: AppColors.primary),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.secondary, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.accent),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.accent, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
