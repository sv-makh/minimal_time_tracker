import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  Locale locale;

  ChangeLanguage({required this.locale});
}

class SetInitialSetting extends SettingsEvent {}

class ChangeTheme extends SettingsEvent {
  String theme;

  ChangeTheme({required this.theme});
}

class ChangeFontSize extends SettingsEvent {
  int fontSize;

  ChangeFontSize({required this.fontSize});
}

class ChangeArchiveVisibility extends SettingsEvent {
  bool showArchive;

  ChangeArchiveVisibility({required this.showArchive});
}

class SettingsState {
  Locale? locale;
  String? theme;
  int? fontSize;
  bool?  showArchive;

  SettingsState([this.locale, this.theme, this.fontSize, this.showArchive]);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(Locale('en', ''), 'Pale', 12, false)) {
    Locale? currentLocale;
    String? currentTheme;
    int? currentFont;
    bool? currentArchive;

    on<SetInitialSetting>(
        (SetInitialSetting event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String langCode = prefs.getString('lang') ?? Platform.localeName;
      String initTheme = prefs.getString('theme') ?? 'Pale';
      int initFont = prefs.getInt('fontSize') ?? 12;
      Locale initLocale = Locale(langCode);
      bool initArchive = prefs.getBool('showArchive') ?? false;

      currentLocale = initLocale;
      currentFont = initFont;
      currentTheme = initTheme;
      currentArchive = initArchive;

      return emitter(SettingsState(initLocale, initTheme, initFont, initArchive));
    });

    on<ChangeLanguage>(
        (ChangeLanguage event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Locale newLocale = event.locale;
      currentLocale = newLocale;
      prefs.setString('lang', newLocale.languageCode);

      return emitter(SettingsState(newLocale, currentTheme, currentFont, currentArchive));
    });

    on<ChangeTheme>((ChangeTheme event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String newTheme = event.theme;
      currentTheme = newTheme;
      prefs.setString('theme', newTheme);

      return emitter(SettingsState(currentLocale, newTheme, currentFont, currentArchive));
    });

    on<ChangeFontSize>(
        (ChangeFontSize event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int newFontSize = event.fontSize;
      currentFont = newFontSize;
      prefs.setInt('fontSize', newFontSize);

      return emitter(SettingsState(currentLocale, currentTheme, newFontSize, currentArchive));
    });

    on<ChangeArchiveVisibility>((ChangeArchiveVisibility event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool newShowArchive = event.showArchive;
      currentArchive = newShowArchive;
      prefs.setBool('showArchive', newShowArchive);

      return emitter(SettingsState(currentLocale, currentTheme, currentFont, newShowArchive));
    });
  }
}
