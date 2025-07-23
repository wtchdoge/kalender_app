import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mitarbeiter_model.dart';

class MitarbeiterService {
  Future<List<Mitarbeiter>> getMitarbeiterFromHive() async {
    final box = await Hive.openBox<Mitarbeiter>('mitarbeiter');
    print('Hive Mitarbeiter: ${box.values.length}');
    return box.values.toList();
  }

  Future<void> syncMitarbeiterFromFirestore() async {
    final box = await Hive.openBox<Mitarbeiter>('mitarbeiter');
    final snapshot = await FirebaseFirestore.instance.collection('mitarbeiter').get();
    print('Firestore docs: ${snapshot.docs.length}');
    for (var doc in snapshot.docs) {
      final m = Mitarbeiter(
        id: doc.id,
        name: doc['mitarbeitername'] ?? '',
      );
      print('Speichere Mitarbeiter: ${m.name}');
      box.put(m.id, m);
    }
  }

  Future<void> clearHiveBox() async {
    final box = await Hive.openBox<Mitarbeiter>('mitarbeiter');
    await box.clear();
  }
}