import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:database_test_app/theme/app_theme.dart';
import 'package:database_test_app/screens/add_appointment_screen.dart';
import 'package:database_test_app/screens/calendar_screen.dart' show SelectionMode;

import 'package:database_test_app/services/availability_service.dart';
import 'package:database_test_app/widgets/save_on_second_tap_button.dart';

class CalendarActionBar extends StatelessWidget {
  final List<DateTime> selectedDays;
  final VoidCallback onReload;
  final VoidCallback? onResetSelection;
  final SelectionMode selectionMode;
  final void Function(SelectionMode)? onStartSelection;
  const CalendarActionBar({
    super.key,
    required this.selectedDays,
    required this.onReload,
    this.onResetSelection,
    required this.selectionMode,
    this.onStartSelection,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Termin hinzufügen
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'add',
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.textLight,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddAppointmentScreen(
                            selectedDate: selectedDays.isNotEmpty ? selectedDays.last : null,
                          ),
                        ),
                      );
                    },
                    tooltip: 'Neuen Termin hinzufügen',
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 130, // gleiche Breite wie bei den anderen Buttons
                    child: Text(
                      'Termin hinzufügen',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
            ),
            // Nicht verfügbar
            Expanded(
              child: SaveOnSecondTapButton(
                label: 'Abwesend markieren',
                icon: Icons.block,
                defaultColor: AppColors.accent,
                heroTag: 'notAvailable',
                labelColor: AppColors.accent,
                selectedDays: selectedDays,
                isActive: selectionMode == SelectionMode.unavailable,
                onStartSelection: () => onStartSelection?.call(SelectionMode.unavailable),
                onSave: (List<DateTime> days) async {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nicht eingeloggt!'), backgroundColor: AppColors.accent),
                    );
                    return;
                  }
                  for (final day in days) {
                    await AvailabilityService.markDayAsUnavailable(userId: userId, day: day);
                  }
                  onReload();
                  if (onResetSelection != null) onResetSelection!();
                  // Nach dem Speichern Auswahlmodus beenden
                  if (onStartSelection != null) onStartSelection!(SelectionMode.viewOnly);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abwesende Tage wurden gespeichert.'), backgroundColor: AppColors.accent),
                  );
                },
              ),
            ),
            // Verfügbar
            Expanded(
              child: SaveOnSecondTapButton(
                label: 'Anwesend markieren',
                icon: Icons.check_circle_outline,
                defaultColor: Colors.blue,
                heroTag: 'available',
                labelColor: Colors.blue,
                selectedDays: selectedDays,
                isActive: selectionMode == SelectionMode.available,
                onStartSelection: () => onStartSelection?.call(SelectionMode.available),
                onSave: (List<DateTime> days) async {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nicht eingeloggt!'), backgroundColor: Colors.blue),
                    );
                    return;
                  }
                  for (final day in days) {
                    await AvailabilityService.markDayAsAvailable(userId: userId, day: day);
                  }
                  onReload();
                  if (onResetSelection != null) onResetSelection!();
                  // Nach dem Speichern Auswahlmodus beenden
                  if (onStartSelection != null) onStartSelection!(SelectionMode.viewOnly);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anwesende Tage wurden gespeichert.'), backgroundColor: Colors.blue),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
