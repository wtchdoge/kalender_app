import 'package:database_test_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_card.dart';
import 'add_appointment_screen.dart';
import '../utils/id_maps.dart';

// ...existing code...
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}


class _AppointmentsScreenState extends State<AppointmentsScreen> with RouteAware {
  String? selectedMitarbeiter;
  String? selectedStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<AppointmentProvider>(context, listen: false).fetchAppointments();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Wird aufgerufen, wenn man von einer anderen Route zurückkehrt
    Provider.of<AppointmentProvider>(context, listen: false).fetchAppointments();
    super.didPopNext();
  }
// RouteObserver für die App
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<AppointmentProvider>(context).appointments;

    final filteredAppointments = appointments.where((a) {
      final mitarbeiterName = providerMap[a.providerId] ?? '';
      final mitarbeiterMatch = selectedMitarbeiter == null || selectedMitarbeiter == mitarbeiterName;
      final statusMatch = selectedStatus == null || selectedStatus == a.status;
      return mitarbeiterMatch && statusMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Termine')),
      body: _isLoading
          ? const Center(
              child: Text(
                'Termine laden...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // ... Filter-Widgets ...
                    ],
                  ),
                ),
                Expanded(
                  child: filteredAppointments.isEmpty
                      ? const Center(
                          child: Text(
                            'Keine Termine vorhanden',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = filteredAppointments[index];
                            return AppointmentCard(appointment: appointment);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textLight,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddAppointmentScreen(),
                ),
              );
            },
            tooltip: 'Neuen Termin hinzufügen',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          Text(
            'Termin hinzufügen',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
