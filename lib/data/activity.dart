//import 'package:build_runner/build_runner.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

part 'activity.g.dart';

/*const String boxName = 'activitiesBox';
const String archiveName = 'archiveBox';*/

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
  @HiveField(4)
  Presentation? presentation;
  @HiveField(5)
  int? maxNum;
  @HiveField(6)
  int? color;

  Activity(
      {required this.title,
      this.subtitle,
      List<Duration>? durationButtons,
      this.presentation,
      this.maxNum,
      this.color})
      : durationButtons = durationButtons ?? [];

  @override
  bool operator ==(Object other) {
    //Function deepEq = const DeepCollectionEquality().equals;
    Function eq = const ListEquality().equals;

/*    Activity act = other as Activity;
    print('identical(this, other) is ${identical(this, other)}');
    print('title == other.title is ${other is Activity && title == other.title}');
    print('subtitle == other.subtitle is ${other is Activity && subtitle == other.subtitle}');
    print('eq(_intervals, other._intervals) is ${other is Activity && eq(_intervals, other._intervals)}');
    print('_intervals l = ${_intervals.length}; other._intervals l = ${act._intervals.length}');
    print('eq(durationButtons, other.durationButtons) is ${other is Activity && eq(durationButtons, other.durationButtons)}');
    print('presentation == other.presentation is ${other is Activity && presentation == other.presentation}');
    print('color == other.color is ${other is Activity && color == other.color}');
    print('maxNum == other.maxNum is ${other is Activity && maxNum == other.maxNum}');*/

    return //identical(this, other) ||
        other is Activity &&
            title == other.title &&
            subtitle == other.subtitle &&
            eq(_intervals, other._intervals) &&
            eq(durationButtons, other.durationButtons) &&//result &&
            presentation == other.presentation &&
            color == other.color &&
            maxNum == other.maxNum;
  }

  @override
  int get hashCode {
    int iHash = 1;
    for (var e in _intervals) { iHash ^= e.hashCode; }
    int dHash = 1;
    for (var e in durationButtons) { dHash ^= e.hashCode; }
    return title.hashCode ^
    subtitle.hashCode ^
    iHash ^
    dHash ^
    presentation.hashCode ^
    color.hashCode ^
    maxNum.hashCode;
  }

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

  @override
  bool operator ==(Object other) {
    return //identical(this, other) ||
        other is TimeInterval && start == other.start && end == other.end && duration == other.duration;
  }

  @override
  int get hashCode {
    return start.hashCode ^ end.hashCode ^ duration.hashCode;
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

@HiveType(typeId: 4)
enum Presentation {
  @HiveField(0)
  BUTTONS,
  @HiveField(1)
  TABLE
}
