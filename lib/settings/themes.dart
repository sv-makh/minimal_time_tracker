import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/settings/color_palettes.dart';

// enum AppTheme {
//   LightAppTheme,
//   DarkAppTheme,
// }
//
// final appThemeData = {
//   AppTheme.DarkAppTheme: ThemeData(
//     scaffoldBackgroundColor: Colors.black,
//     primaryColor: Colors.redAccent,
//     textTheme: TextTheme(
//       headline3: TextStyle().copyWith(color: Colors.white),
//     ),
//   ),
//   AppTheme.LightAppTheme: ThemeData(
//     scaffoldBackgroundColor: Colors.white,
//     primaryColor: Colors.greenAccent,
//     textTheme: TextTheme(
//       headline3: TextStyle().copyWith(color: Colors.black),
//     ),
//   ),
// };

Map<String, ThemeData> themeData = {
  'Pale' : ThemeData(
    primarySwatch: Colors.blue,
  ),
  'Dusty Rose' : ThemeData(
    primaryColor: dustyRoseDark[2],
  ),
  'Olive' : ThemeData(
    primaryColor: oliveDark[2],
  ),
  'Pastel' : ThemeData(
    primaryColor: pastelDark[2],
  ),
};