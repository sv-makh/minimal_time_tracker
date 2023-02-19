import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/settings/color_palettes.dart';

ThemeData appTheme(String themeName, int fontSize) {
  return ThemeData(
    colorSchemeSeed: primarySwatches[themeName],
    //primarySwatch: primarySwatches[themeName],
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: fontSize.toDouble(),
      ),
      bodySmall: TextStyle(
        fontSize: fontSize.toDouble() - 1,
      )
    ),
    appBarTheme: AppBarTheme(),
    useMaterial3: true,
  );
}

Map<String, MaterialColor> primarySwatches = {
  'Pale' : Colors.blue,
  'Dusty Rose' : Colors.pink,
  'Olive' : Colors.teal,
  'Pastel' : Colors.purple,
};

Map<String, List<List<Color>>> themePalettes = {
  'Pale' : [ pale, paleDark ],
  'Dusty Rose' : [ dustyRose, dustyRoseDark ],
  'Olive' : [ olive, oliveDark ],
  'Pastel' : [ pastel, pastelDark ],
};