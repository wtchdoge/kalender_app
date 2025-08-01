import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../utils/id_maps.dart';
import '../utils/app_snackbar.dart';
import 'package:intl/intl.dart';
import 'edit_appointment_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/appointment_service.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final dienstleistung = serviceMap[appointment.serviceId]?['dienstleistung'] ?? 'Unbekannt';
    final kategorie = serviceMap[appointment.serviceId]?['kategorie'] ?? 'Unbekannt';
    final mitarbeiter = providerMap[appointment.providerId] ?? 'Unbekannt';
    final startTime = DateFormat('HH:mm').format(appointment.bookingStart);
    final endTime = DateFormat('HH:mm').format(appointment.bookingEnd);
    final strasse = appointment.strasse ?? 'Unbekannt';
    final hausnummer = appointment.hausnummer ?? '';
    final plz = appointment.plz ?? '';
    final ort = appointment.ort ?? '';
    final kundenname = appointment.kundenname ?? 'Unbekannt';

    return Scaffold(
      appBar: AppBar(title: const Text('Termin Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dienstleistung,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('dd.MM.yy').format(appointment.bookingStart)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              'Time: $startTime - $endTime',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text('Category: $kategorie', style: const TextStyle(fontSize: 18)),
            Text('Employee: $mitarbeiter', style: const TextStyle(fontSize: 18)),
            Text('Status: ${appointment.status}', style: const TextStyle(fontSize: 18)),
            Text('Customer: $kundenname', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Text('Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Street: $strasse', style: const TextStyle(fontSize: 18)),
            Text('House Number: ${hausnummer.isNotEmpty ? hausnummer : 'Unknown'}', style: const TextStyle(fontSize: 18)),
            Text('ZIP: ${plz.isNotEmpty ? plz : 'Unknown'}', style: const TextStyle(fontSize: 18)),
            Text('City: ${ort.isNotEmpty ? ort : 'Unknown'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.map),
                    tooltip: 'Open in Google Maps',
                    onPressed: () async {
                      final addressQuery = Uri.encodeComponent('$strasse $hausnummer, $plz $ort');
                      final url = 'https://www.google.com/maps/search/?api=1&query=$addressQuery';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text('Search in Google Maps', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditAppointmentScreen(appointment: appointment),
                  ),
                );
              },
              child: const Text('Bearbeiten'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Termin löschen'),
                    content: const Text('Do you really want to delete this appointment?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Löschen'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await AppointmentService.deleteAppointment(appointment.id);
                  if (context.mounted) {
                    // Terminliste sofort aktualisieren
                    try {
                      Provider.of<AppointmentProvider>(context, listen: false).fetchAppointments();
                    } catch (_) {}
                    Navigator.of(context).pop();
                    AppSnackBar.show(context, 'Appointment deleted!', color: Colors.red);
                  }
                }
              },
              child: const Text('Löschen'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                // Status auf 'abgeschlossen' setzen
                await AppointmentService.updateAppointmentStatus(appointment.id, 'abgeschlossen');
                if (context.mounted) {
                  try {
                    Provider.of<AppointmentProvider>(context, listen: false).fetchAppointments();
                  } catch (_) {}
                  Navigator.of(context).pop();
                  AppSnackBar.show(context, 'Termin als abgeschlossen markiert!', color: Colors.green);
                }
              },
              child: const Text('Als abgeschlossen markieren'),
            ),
          ],
        ),
      ),
    );
  }
}
