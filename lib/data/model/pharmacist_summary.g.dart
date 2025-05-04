// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacist_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PharmacistSummaryAdapter extends TypeAdapter<PharmacistSummary> {
  @override
  final int typeId = 1;

  @override
  PharmacistSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PharmacistSummary(
      name: fields[0] as String,
      total: fields[1] as int,
      morning: fields[2] as int,
      afternoon: fields[3] as int,
      evening: fields[4] as int,
      weekend: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PharmacistSummary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.total)
      ..writeByte(2)
      ..write(obj.morning)
      ..writeByte(3)
      ..write(obj.afternoon)
      ..writeByte(4)
      ..write(obj.evening)
      ..writeByte(5)
      ..write(obj.weekend);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PharmacistSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
