class Activity {
  String title;
  String? subtitle;
  List<TimeInterval> _intervals = [];
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
}

class TimeInterval {
  late DateTime start;
  late DateTime end;
  late Duration duration;

  TimeInterval({required this.start, required this.end})
      : duration = end.difference(start);

  TimeInterval.duration({required this.end, required this.duration})
      : start = end.subtract(duration);

  Duration length() {
    return duration;
  }
}
