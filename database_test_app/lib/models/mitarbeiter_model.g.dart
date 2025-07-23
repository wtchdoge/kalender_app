// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mitarbeiter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MitarbeiterAdapter extends TypeAdapter<Mitarbeiter> {
  @override
  final int typeId = 0;

  @override
  Mitarbeiter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mitarbeiter(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Mitarbeiter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MitarbeiterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
