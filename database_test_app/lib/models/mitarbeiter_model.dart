
import 'package:hive/hive.dart';
part 'mitarbeiter_model.g.dart';

@HiveType(typeId: 0)
class Mitarbeiter extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  

  Mitarbeiter({required this.id, required this.name});

  factory Mitarbeiter.fromJson(Map<String, dynamic> json, String id) =>
      Mitarbeiter(id: id, name: json['mitarbeitername'] ?? '');
}