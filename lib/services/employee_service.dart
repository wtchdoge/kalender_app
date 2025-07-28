import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';

class EmployeeService {
  Future<List<Employee>> getEmployeeFromHive() async {
    final box = await Hive.openBox<Employee>('mitarbeiter');
    print('Hive Mitarbeiter: ${box.values.length}');
    return box.values.toList();
  }

  Future<void> syncEmployeeFromFirestore() async {
    final box = await Hive.openBox<Employee>('mitarbeiter');
    final snapshot = await FirebaseFirestore.instance.collection('mitarbeiter').get();
    print('Firestore docs: ${snapshot.docs.length}');
    for (var doc in snapshot.docs) {
      final m = Employee(
        id: doc.id,
        name: doc['mitarbeitername'] ?? '',
      );
      print('Speichere Mitarbeiter: ${m.name}');
      box.put(m.id, m);
    }
  }

  Future<void> clearEmployeeHiveBox() async {
    final box = await Hive.openBox<Employee>('mitarbeiter');
    await box.clear();
  }
}
