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

class LanguageBloc extends Bloc<SettingsEvent, SettingsState> {

  LanguageBloc() : super(SettingsState(Locale('en', ''), 'Pale')) {

    on<SetInitialSetting>((SetInitialSetting event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String langCode = prefs.getString('lang') ?? Platform.localeName;
      String initTheme = prefs.getString('theme') ?? 'Pale';
      Locale initLocale = Locale(langCode);

      return emitter(SettingsState(initLocale, initTheme));
    });

    on<ChangeLanguage>((ChangeLanguage event, Emitter<SettingsState> emitter) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Locale newLocale = event.locale;
      prefs.setString('lang', newLocale.languageCode);//then Проверка
      
      return emitter(SettingsState(newLocale));
    });
  }
}
