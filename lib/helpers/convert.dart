import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//функция преобразования Duration d в строку вида
//2d 15h 30m 13s (или 15h 20s, или 3h...)
//если всё в d = 0, то результат будет 0m
String stringDuration(Duration d, BuildContext context) {
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
