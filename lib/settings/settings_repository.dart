import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SettingsRepository {
  late SharedPreferences prefs;

  Future<void> initRepository() async {
    prefs = await SharedPreferences.getInstance();
  }

  Locale getLocale() {
    String langCode = prefs.getString('lang') ?? Platform.localeName;
    return Locale(langCode);
  }

  String getTheme() {
    return prefs.getString('theme') ?? 'Pale';
  }

  int getFontSize() {
    return prefs.getInt('fontSize') ?? 12;
  }

  bool getArchiveVisibility() {
    return prefs.getBool('showArchive') ?? true;
  }

  void setLocale(Locale locale) {
    prefs.setString('lang', locale.languageCode);
  }

  void setTheme(String theme) {
    prefs.setString('theme', theme);
  }

  void setFontSize(int fontSize) {
    prefs.setInt('fontSize', fontSize);
  }

  void setArchiveVisibility(bool archive) {
    prefs.setBool('showArchive', archive);
  }
}
