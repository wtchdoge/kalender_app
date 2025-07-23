import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mitarbeiter_provider.dart';

class MitarbeiterListScreen extends StatefulWidget {
  const MitarbeiterListScreen({super.key});

  @override
  State<MitarbeiterListScreen> createState() => _MitarbeiterListScreenState();
}

class _MitarbeiterListScreenState extends State<MitarbeiterListScreen> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      context.read<MitarbeiterProvider>().syncMitarbeiter();
      _didLoad = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mitarbeiter')),
      body: Consumer<MitarbeiterProvider>(
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
        onPressed: () => context.read<MitarbeiterProvider>().syncMitarbeiter(),
        tooltip: 'Aus Firestore laden',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}