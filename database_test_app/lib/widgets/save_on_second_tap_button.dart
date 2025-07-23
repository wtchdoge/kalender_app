import 'package:flutter/material.dart';
import 'package:database_test_app/theme/app_theme.dart';

class SaveOnSecondTapButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color defaultColor;
  final String heroTag;
  final List<DateTime> selectedDays;
  final bool isActive;
  final VoidCallback? onStartSelection;
  final Future<void> Function(List<DateTime>) onSave;
  final Color labelColor;

  const SaveOnSecondTapButton({
    super.key,
    required this.label,
    required this.icon,
    required this.defaultColor,
    required this.heroTag,
    required this.selectedDays,
    required this.isActive,
    this.onStartSelection,
    required this.onSave,
    required this.labelColor,
  });

  @override
  State<SaveOnSecondTapButton> createState() => _SaveOnSecondTapButtonState();
}

class _SaveOnSecondTapButtonState extends State<SaveOnSecondTapButton> {

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: widget.heroTag,
          backgroundColor: isActive ? Colors.green : widget.defaultColor,
          foregroundColor: AppColors.textLight,
          onPressed: () async {
            if (!isActive) {
              // Hinweis anzeigen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Bitte Tage auswählen'),
                  backgroundColor: AppColors.primary,
                ),
              );
              widget.onStartSelection?.call();
            } else {
              await widget.onSave(widget.selectedDays);
            }
          },
          child: Icon(isActive ? Icons.save : widget.icon),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 130, // Feste Breite für gleichmäßige Buttons, ggf. anpassen
          child: Text(
            isActive ? 'Speichern' : widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: isActive ? Colors.green : widget.labelColor),
          ),
        ),
      ],
    );
  }
}
