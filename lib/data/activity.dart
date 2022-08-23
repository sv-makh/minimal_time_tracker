class Activity {
  String title;
  String? subtitle;
  List<TimeInterval> _intervals = [];
  List<Duration> durationButtons = [];

  Activity({required this.title, this.subtitle});

  void addInterval(DateTime start, DateTime end) {
    _intervals.add(TimeInterval(start: start, end: end));
  }

  Duration totalTime() {
    Duration sum = Duration();
    for (var interval in _intervals) {
      sum += interval.length();
    }
    return sum;
  }
}

class TimeInterval {
  DateTime start;
  DateTime end;

  TimeInterval({required this.start, required this.end});

  Duration length() {
    return end.difference(start);
  }
}
