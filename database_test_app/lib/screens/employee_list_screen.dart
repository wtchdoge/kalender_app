import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      context.read<EmployeeProvider>().syncMitarbeiter();
      _didLoad = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mitarbeiter')),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.mitarbeiter.isEmpty) {
            return const Center(child: Text('Keine Mitarbeiter gefunden.'));
          }
          return ListView.builder(
            itemCount: provider.mitarbeiter.length,
            itemBuilder: (context, index) {
              final m = provider.mitarbeiter[index];
              return ListTile(
                title: Text(m.name),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<EmployeeProvider>().syncMitarbeiter(),
        tooltip: 'Aus Firestore laden',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
