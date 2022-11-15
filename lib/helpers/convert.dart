import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//функция преобразования Duration d в строку вида
//2d 15h 30m 13s (или 15h 20s, или 3h...)
//если всё в d = 0, то результат будет 0m
String stringDuration(Duration d, BuildContext context) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('$days${AppLocalizations.of(context)!.daysShort}');
  }
  if (hours != 0) {
    tokens.add('$hours${AppLocalizations.of(context)!.hoursShort}');
  }
  if (tokens.isEmpty || (minutes != 0)) {
    tokens.add('$minutes${AppLocalizations.of(context)!.minutesShort}');
  }
  if (seconds != 0) {
    if (minutes == 0) {
      tokens.remove('$minutes${AppLocalizations.of(context)!.minutesShort}');
    }
    tokens.add('$seconds${AppLocalizations.of(context)!.secondsShort}');
  }

  return tokens.join(' ');
}

// MaterialColor colorToMaterial(Color color) {
//   Map<int, Color> colorCodes = {
//     50: Color.fromRGBO(147, 205, 72, .1),
//     100: Color.fromRGBO(147, 205, 72, .2),
//     200: Color.fromRGBO(147, 205, 72, .3),
//     300: Color.fromRGBO(147, 205, 72, .4),
//     400: Color.fromRGBO(147, 205, 72, .5),
//     500: Color.fromRGBO(147, 205, 72, .6),
//     600: Color.fromRGBO(147, 205, 72, .7),
//     700: Color.fromRGBO(147, 205, 72, .8),
//     800: Color.fromRGBO(147, 205, 72, .9),
//     900: Color.fromRGBO(147, 205, 72, 1),
//   };
// }