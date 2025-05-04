// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyScheduleAdapter extends TypeAdapter<DailySchedule> {
  @override
  final int typeId = 0;

  @override
  DailySchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySchedule(
      date: fields[0] as DateTime,
      shift: fields[1] as String,
      pharmacists: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailySchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.shift)
      ..writeByte(2)
      ..write(obj.pharmacists);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
