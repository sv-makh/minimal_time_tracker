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
      presentation: fields[4] as Presentation?,
      maxNum: fields[5] as int?,
      color: fields[6] as int?,
    ).._intervals = (fields[2] as List).cast<TimeInterval>();
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subtitle)
      ..writeByte(2)
      ..write(obj._intervals)
      ..writeByte(3)
      ..write(obj.durationButtons)
      ..writeByte(4)
      ..write(obj.presentation)
      ..writeByte(5)
      ..write(obj.maxNum)
      ..writeByte(6)
      ..write(obj.color);
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

class PresentationAdapter extends TypeAdapter<Presentation> {
  @override
  final int typeId = 4;

  @override
  Presentation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Presentation.BUTTONS;
      case 1:
        return Presentation.TABLE;
      default:
        return Presentation.BUTTONS;
    }
  }

  @override
  void write(BinaryWriter writer, Presentation obj) {
    switch (obj) {
      case Presentation.BUTTONS:
        writer.writeByte(0);
        break;
      case Presentation.TABLE:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PresentationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
