import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../utils/id_maps.dart';
import '../utils/app_snackbar.dart';
import '../utils/string_utils.dart';
import '../utils/date_utils.dart' as app_date_utils;
import 'edit_appointment_screen.dart';
import '../utils/address_utils.dart';
import '../utils/app_labels.dart';
import '../services/appointment_service.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
  final dienstleistung = StringUtils.displayOrUnknown(serviceMap[appointment.serviceId]?['dienstleistung']);
  final kategorie = StringUtils.displayOrUnknown(serviceMap[appointment.serviceId]?['kategorie']);
  final mitarbeiter = StringUtils.displayOrUnknown(providerMap[appointment.providerId]);
  final startTime = app_date_utils.DateUtils.formatTime(appointment.bookingStart, label: '');
  final endTime = app_date_utils.DateUtils.formatTime(appointment.bookingEnd, label: '');
  final strasse = StringUtils.displayOrUnknown(appointment.strasse);
  final hausnummer = StringUtils.displayOrUnknown(appointment.hausnummer, fallback: '');
  final plz = StringUtils.displayOrUnknown(appointment.plz, fallback: '');
  final ort = StringUtils.displayOrUnknown(appointment.ort, fallback: '');
  final kundenname = StringUtils.displayOrUnknown(appointment.kundenname);

    return Scaffold(
  appBar: AppBar(title: const Text(AppLabels.service)),
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
              '${AppLabels.date}: ${app_date_utils.DateUtils.formatDate(appointment.bookingStart)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              '${AppLabels.time}: ${startTime.replaceFirst(':' , '').trim()} - ${endTime.replaceFirst(':' , '').trim()}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text('${AppLabels.category}: $kategorie', style: const TextStyle(fontSize: 18)),
            Text('${AppLabels.employee}: $mitarbeiter', style: const TextStyle(fontSize: 18)),
            Text('${AppLabels.status}: ${appointment.status}', style: const TextStyle(fontSize: 18)),
            Text('${AppLabels.customer}: $kundenname', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Text(AppLabels.address, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              AddressUtils.formatAddress(
                street: strasse,
                houseNumber: hausnummer,
                zip: plz,
                city: ort,
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.map),
                    tooltip: AppLabels.searchInGoogleMaps,
                    onPressed: () async {
                      await AddressUtils.openInGoogleMaps(
                        street: strasse,
                        houseNumber: hausnummer,
                        zip: plz,
                        city: ort,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(AppLabels.searchInGoogleMaps, style: TextStyle(fontSize: 16)),
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
