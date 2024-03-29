import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/data/settings/color_palettes.dart';

//светлый вариант темы
ThemeData appTheme(String themeName, int fontSize) {
  return ThemeData(
    colorSchemeSeed: primarySwatches[themeName],
    textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontSize: fontSize.toDouble(),
        ),
        bodySmall: TextStyle(
          fontSize: fontSize.toDouble() - 1,
        )),
    appBarTheme: const AppBarTheme(),
    brightness: Brightness.light,
    useMaterial3: true,
  );
}

//тёмный вариант темы
ThemeData appThemeDark(String themeName, int fontSize) {
  return ThemeData(
    colorSchemeSeed: primarySwatches[themeName],
    textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontSize: fontSize.toDouble(),
        ),
        bodySmall: TextStyle(
          fontSize: fontSize.toDouble() - 1,
        )),
    appBarTheme: const AppBarTheme(),
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}

Map<String, MaterialColor> primarySwatches = {
  'Pale': Colors.blue,
  //'Dusty Rose': Colors.pink,
  //'Olive': Colors.teal,
  'Pastel': Colors.purple,
};

Map<String, List<List<List<Color>>>> themePalettes = {
  'Pale': [
    [pale, paleDark, paleInactive],
    [paleDarkMode, paleDark, paleInactiveDarkMode]
  ],
  //'Dusty Rose': [[dustyRose, dustyRoseDark, dustyRoseInactive],[dustyRose, dustyRoseDark, dustyRoseInactive]],
  //'Olive': [[olive, oliveDark, oliveInactive],[olive, oliveDark, oliveInactive]],
  'Pastel': [
    [pastel, pastelDark, pastelInactive],
    [pastelDarkMode, pastelDark, pastelInactiveDarkMode],
  ],
};
