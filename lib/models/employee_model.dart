import 'package:hive/hive.dart';
import '../utils/string_utils.dart';
part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;

  Employee({required this.id, required this.name});
  factory Employee.fromJson(Map<String, dynamic> json, String id) =>
      Employee(id: id, name: StringUtils.displayOrUnknown(json['mitarbeitername'], fallback: ''));
}
