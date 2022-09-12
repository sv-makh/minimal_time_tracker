import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/activity_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, ActivitiesState state) {
        return Card(
          child: Column(children: [
            ListTile(
              title: Text(
                  '${activity.title}, ${AppLocalizations.of(context)!.total} = ${_stringDuration(activity.totalTime(), context)}'),
              subtitle: (activity.subtitle != null)
                  ? Text(activity.subtitle!)
                  : Container(),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context).add(
                      ActivityDeleted(index: activities.indexOf(activity)));
                },
              ),
            ),
            (activity.durationButtons == null)
                ? Container()
                : _rowOfButtons(context)
          ]),
        );
      },
    );
  }

  Widget _rowOfButtons(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var d in activity.durationButtons)
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: OutlinedButton(
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context).add(
                      ActivityAddedTime(
                          index: activities.indexOf(activity),
                          interval: TimeInterval.duration(
                              end: DateTime.now(), duration: d)));
                },
                child: Text('+ ' + _stringDuration(d, context)),
              ),
            )
        ],
      ),
    );
  }

  //функция преобразования Duration d в строку вида
  //2d 15h 30m 13s (или 15h 20s, или 3h...)
  //если всё в d = 0, то результат будет 0m
  String _stringDuration(Duration d, BuildContext context) {
    var _seconds = d.inSeconds;
    final _days = _seconds ~/ Duration.secondsPerDay;
    _seconds -= _days * Duration.secondsPerDay;
    final _hours = _seconds ~/ Duration.secondsPerHour;
    _seconds -= _hours * Duration.secondsPerHour;
    final _minutes = _seconds ~/ Duration.secondsPerMinute;
    _seconds -= _minutes * Duration.secondsPerMinute;

    final List<String> _tokens = [];
    if (_days != 0) {
      _tokens.add('${_days}${AppLocalizations.of(context)!.daysShort}');
    }
    if (_hours != 0) {
      _tokens.add('${_hours}${AppLocalizations.of(context)!.hoursShort}');
    }
    if (_tokens.isEmpty || (_minutes != 0)) {
      _tokens.add('${_minutes}${AppLocalizations.of(context)!.minutesShort}');
    }
    if (_seconds != 0) {
      if (_minutes == 0) {
        _tokens.remove('${_minutes}${AppLocalizations.of(context)!.minutesShort}');
      }
      _tokens.add('${_seconds}${AppLocalizations.of(context)!.secondsShort}');
    }

    return _tokens.join(' ');
  }
}
