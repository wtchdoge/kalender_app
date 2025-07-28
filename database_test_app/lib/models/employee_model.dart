import 'package:hive/hive.dart';
part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;

  Employee({required this.id, required this.name});

  factory Employee.fromJson(Map<String, dynamic> json, String id) =>
      Employee(id: id, name: json['mitarbeitername'] ?? '');
}
