import 'my_appointments_screen.dart';
import 'employee_list_screen.dart';
import 'package:database_test_app/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:database_test_app/screens/appointments_screen.dart';
import 'package:database_test_app/screens/calendar_screen.dart';

// Optional: importiere deinen zukünftigen Kalender-Screen
// import 'calendar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final username = user?.displayName ?? user?.email ?? "Benutzer";
    return Scaffold(
      appBar: AppBar(
        title: Text('Hallo $username', style: TextStyle(color: AppColors.textLight)),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.logout, color: AppColors.textLight),
            label: Text('Abmelden', style: TextStyle(color: AppColors.textLight)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Terminliste anzeigen'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Kalender anzeigen'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Meine Termine'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyAppointmentsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Mitarbeiter anzeigen'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EmployeeListScreen()),
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
