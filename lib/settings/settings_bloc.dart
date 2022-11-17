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

class SettingsState {
  Locale? locale;
  String? theme;

  SettingsState([this.locale, this.theme]);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  SettingsBloc() : super(SettingsState(Locale('en', ''), 'Pale')) {

    Locale? currentLocale;

    on<SetInitialSetting>((SetInitialSetting event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String langCode = prefs.getString('lang') ?? Platform.localeName;
      String initTheme = prefs.getString('theme') ?? 'Pale';
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
      prefs.setString('theme', newTheme);

      return emitter(SettingsState(currentLocale, newTheme));
    });
  }
}
