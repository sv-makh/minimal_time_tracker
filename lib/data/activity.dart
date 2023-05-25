//import 'package:build_runner/build_runner.dart';
import 'package:hive/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 1)
class Activity {
  //заголовок активности
  @HiveField(0)
  String title;

  //подзаголовок активоности
  @HiveField(1)
  String? subtitle;

  //добавленные пользователем интервалы времени
  @HiveField(2)
  List<TimeInterval> _intervals = [];

  //кнопки, с помощью которых добавляется время
  @HiveField(3)
  List<Duration> durationButtons = <Duration>[];

  //кнопочное/табличное добавление времени
  @HiveField(4)
  Presentation? presentation;

  //количество яцеек в таблице в случает табличного представления
  @HiveField(5)
  int? maxNum;

  //цвет карточки активности - индекс цвета из массивов цветов для темы
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

  void addInterval(TimeInterval ti) {
    _intervals.add(ti);
  }

  void addDurationButton(Duration duration) {
    durationButtons.add(duration);
  }

  Duration totalTime() {
    Duration sum = const Duration();
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

@HiveType(typeId: 4)
enum Presentation {
  @HiveField(0)
  BUTTONS,
  @HiveField(1)
  TABLE
}
