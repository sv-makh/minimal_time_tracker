// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 1;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      title: fields[0] as String,
      subtitle: fields[1] as String?,
      durationButtons: (fields[3] as List?)?.cast<Duration>(),
    ).._intervals = (fields[2] as List).cast<TimeInterval>();
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subtitle)
      ..writeByte(2)
      ..write(obj._intervals)
      ..writeByte(3)
      ..write(obj.durationButtons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeIntervalAdapter extends TypeAdapter<TimeInterval> {
  @override
  final int typeId = 2;

  @override
  TimeInterval read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeInterval(
      start: fields[0] as DateTime,
      end: fields[1] as DateTime,
    )..duration = fields[2] as Duration;
  }

  @override
  void write(BinaryWriter writer, TimeInterval obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeIntervalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
