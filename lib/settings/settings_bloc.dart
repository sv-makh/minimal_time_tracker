import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  Locale locale;

  ChangeLanguage({required this.locale});
}

class SetInitialSetting extends SettingsEvent {
}

class ChangeTheme extends SettingsEvent {
  String theme;

  ChangeTheme({required this.theme});
}

class ChangeFontSize extends SettingsEvent {
  int fontSize;

  ChangeFontSize({required this.fontSize});
}

class SettingsState {
  Locale? locale;
  String? theme;
  int? fontSize;

  SettingsState([this.locale, this.theme, this.fontSize]);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  SettingsBloc() : super(SettingsState(Locale('en', ''), 'Pale')) {

    Locale? currentLocale;
    String? currentTheme;

    on<SetInitialSetting>((SetInitialSetting event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String langCode = prefs.getString('lang') ?? Platform.localeName;
      String initTheme = prefs.getString('theme') ?? 'Pale';
      int initFont = prefs.getInt('fontSize') ?? 12;
      Locale initLocale = Locale(langCode);
      currentLocale = initLocale;

      return emitter(SettingsState(initLocale, initTheme));
    });

    on<ChangeLanguage>((ChangeLanguage event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Locale newLocale = event.locale;
      currentLocale = newLocale;
      prefs.setString('lang', newLocale.languageCode);//then Проверка
      
      return emitter(SettingsState(newLocale));
    });

    on<ChangeTheme>((ChangeTheme event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String newTheme = event.theme;
      currentTheme = newTheme;
      prefs.setString('theme', newTheme);

      return emitter(SettingsState(currentLocale, newTheme));
    });

    on<ChangeFontSize>((ChangeFontSize event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int newFontSize = event.fontSize;
      prefs.setInt('fontSize', newFontSize);

      return emitter(SettingsState(currentLocale, currentTheme, newFontSize));
    });
  }
}
