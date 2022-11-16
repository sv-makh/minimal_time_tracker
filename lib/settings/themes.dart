import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/settings/color_palettes.dart';

Map<String, ThemeData> themeData = {
  'Pale' : ThemeData(
    primarySwatch: Colors.blue,
  ),
  'Dusty Rose' : ThemeData(
    primarySwatch: Colors.pink,
  ),
  'Olive' : ThemeData(
    primarySwatch: Colors.teal,
  ),
  'Pastel' : ThemeData(
    primaryColor: Colors.purple,
  ),
};

Map<String, List<List<Color>>> themePalettes = {
  'Pale' : [ pale, paleDark ],
  'Dusty Rose' : [ dustyRose, dustyRoseDark ],
  'Olive' : [ olive, oliveDark ],
  'Pastel' : [ pastel, pastelDark ],
};