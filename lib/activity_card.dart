import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          title: Text(
              '${activity.title}, total = ${_stringDuration(activity.totalTime())}'),
          subtitle: (activity.subtitle != null)
              ? Text(activity.subtitle!)
              : Container(),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ),
        (activity.durationButtons == null) ? Container() : _rowOfButtons()
      ]),
    );
  }

  Widget _rowOfButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var d in activity.durationButtons)
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: OutlinedButton(
                onPressed: () {},
                child: Text('+ ' + _stringDuration(d)),
              ),
            )
        ],
      ),
    );
  }

  //функция преобразования Duration d в строку вида
  //2d 15h 30m 13s (или 15h 20s, или 3h...)
  //если всё в d = 0, то результат будет 0m
  String _stringDuration(Duration d) {
    var _seconds = d.inSeconds;
    final _days = _seconds ~/ Duration.secondsPerDay;
    _seconds -= _days * Duration.secondsPerDay;
    final _hours = _seconds ~/ Duration.secondsPerHour;
    _seconds -= _hours * Duration.secondsPerHour;
    final _minutes = _seconds ~/ Duration.secondsPerMinute;
    _seconds -= _minutes * Duration.secondsPerMinute;

    final List<String> _tokens = [];
    if (_days != 0) {
      _tokens.add('${_days}d');
    }
    if (_hours != 0) {
      _tokens.add('${_hours}h');
    }
    if (_tokens.isEmpty || (_minutes != 0)) {
      _tokens.add('${_minutes}m');
    }
    if (_seconds != 0) {
      if (_minutes == 0) {
        _tokens.remove('${_minutes}m');
      }
      _tokens.add('${_seconds}s');
    }

    return _tokens.join(' ');
  }
}
