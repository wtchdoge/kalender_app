import 'package:flutter/material.dart';
import 'package:database_test_app/screens/auth_wrapper.dart';
import 'services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/mitarbeiter_provider.dart';
import 'package:database_test_app/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/mitarbeiter_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Für RouteAware (z.B. Kalender, Terminliste)
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MitarbeiterAdapter());
  await FirebaseService.initializeApp();
  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => MitarbeiterProvider()),
    ],
    child: MyApp(),
  );
  runApp(app);
  // MitarbeiterProvider nach dem ersten Frame triggern
  Future.delayed(Duration.zero, () {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Provider.of<MitarbeiterProvider>(context, listen: false).syncMitarbeiter();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Kalender App',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      navigatorObservers: [routeObserver],
    );
  }
}
