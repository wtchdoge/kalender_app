import 'package:flutter/material.dart';
import '../screens/availability_details_screen.dart';
import '../utils/id_maps.dart';
import '../utils/date_utils.dart' as AppDateUtils;

class AvailabilityCard extends StatelessWidget {
  final List<String> mitarbeiterIds;
  final DateTime date;

  const AvailabilityCard({super.key, required this.mitarbeiterIds, required this.date});

  @override
  Widget build(BuildContext context) {
    final dateStr = AppDateUtils.DateUtils.formatDate(date);
    final mitarbeiterNamen = mitarbeiterIds
        .map((id) => providerMap[id] ?? 'Unbekannt')
        .toList();
    // Zeige maximal 2 Namen, danach "..."
    final displayNames = mitarbeiterNamen.length > 2 ? mitarbeiterNamen.sublist(0, 2) : mitarbeiterNamen;
    final hasMore = mitarbeiterNamen.length > 2;

    return SizedBox(
      height: 180, // 50% höher als vorher (120 -> 180)
      child: Card(
        margin: const EdgeInsets.all(8),
        color: const Color(0xFFFFE5E5), // Sanftes Rot, ggf. anpassen
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AvailabilityDetailsScreen(names: mitarbeiterNamen, date: date),
              ),
            );
          },
          child: ListTile(
            title: Text(
              'Abwesend',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Datum: $dateStr', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ...displayNames.map((name) => Text('Mitarbeiter: $name', style: const TextStyle(fontSize: 16))),
                if (hasMore) const Text('...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
