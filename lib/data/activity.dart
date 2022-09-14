//import 'package:build_runner/build_runner.dart';
import 'package:hive/hive.dart';

part 'activity.g.dart';

const String boxName = 'activitiesBox';

@HiveType(typeId: 1)
class Activity {
  @HiveField(0)
  String title;
  @HiveField(1)
  String? subtitle;
  @HiveField(2)
  List<TimeInterval> _intervals = [];
  @HiveField(3)
  List<Duration> durationButtons = <Duration>[];

  Activity(
      {required this.title, this.subtitle, List<Duration>? durationButtons})
      : durationButtons = durationButtons ?? [];

  void addInterval(TimeInterval ti) {
    _intervals.add(ti);
  }

  void addDurationButton(Duration duration) {
    durationButtons.add(duration);
  }

  Duration totalTime() {
    Duration sum = Duration();
    if (_intervals == null) return Duration();
    for (var interval in _intervals) {
      sum += interval.length();
    }
    return sum;
  }

  List<TimeInterval> get intervalsList => _intervals;
}

@HiveType(typeId: 2)
class TimeInterval {
  @HiveField(0)
  late DateTime start;
  @HiveField(1)
  late DateTime end;
  @HiveField(2)
  late Duration duration;

  TimeInterval({required this.start, required this.end})
      : duration = end.difference(start);

  TimeInterval.duration({required this.end, required this.duration})
      : start = end.subtract(duration);

  Duration length() {
    return duration;
  }
}

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final typeId = 3;

  @override
  void write(BinaryWriter writer, Duration value) =>
      writer.writeInt(value.inMicroseconds);

  @override
  Duration read(BinaryReader reader) =>
      Duration(microseconds: reader.readInt());
}
