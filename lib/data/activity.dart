class Activity {
  String title;
  String? subtitle;
  List<DateTime> _intervals = [];

  Activity({required this.title, this.subtitle});

  void addInterval(DateTime interval) {
    _intervals.add(interval);
  }
}
