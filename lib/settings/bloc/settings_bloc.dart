import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(SettingsState(locale: Locale('en', ''), theme: 'Pale', fontSize: 12, showArchive: true)) {
    Locale? currentLocale;
    String? currentTheme;
    int? currentFont;
    bool? currentArchive;

    on<SetInitialSetting>(
        (SetInitialSetting event, Emitter<SettingsState> emitter) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String langCode = prefs.getString('lang') ?? Platform.localeName;
        String initTheme = prefs.getString('theme') ?? 'Pale';
        int initFont = prefs.getInt('fontSize') ?? 12;
        Locale initLocale = Locale(langCode);
        bool initArchive = prefs.getBool('showArchive') ?? true;

        currentLocale = initLocale;
        currentFont = initFont;
        currentTheme = initTheme;
        currentArchive = initArchive;

        return emitter(state.copyWith(locale: initLocale, theme: initTheme, fontSize: initFont, showArchive: initArchive, status: Status.normal));
            //SettingsState(initLocale, initTheme, initFont, initArchive));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeLanguage>(
        (ChangeLanguage event, Emitter<SettingsState> emitter) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Locale newLocale = event.locale;
        currentLocale = newLocale;
        prefs.setString('lang', newLocale.languageCode);

        return emitter(state.copyWith(locale: newLocale));
            //NormalSettingsState(newLocale, currentTheme, currentFont, currentArchive));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeTheme>((ChangeTheme event, Emitter<SettingsState> emitter) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String newTheme = event.theme;
        currentTheme = newTheme;
        prefs.setString('theme', newTheme);

        return emitter(state.copyWith(theme: newTheme));
            //NormalSettingsState(currentLocale, newTheme, currentFont, currentArchive));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeFontSize>(
        (ChangeFontSize event, Emitter<SettingsState> emitter) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int newFontSize = event.fontSize;
        currentFont = newFontSize;
        prefs.setInt('fontSize', newFontSize);

        return emitter(state.copyWith(fontSize: newFontSize));
            //NormalSettingsState(currentLocale, currentTheme, newFontSize, currentArchive));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeArchiveVisibility>(
        (ChangeArchiveVisibility event, Emitter<SettingsState> emitter) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool newShowArchive = event.showArchive;
        currentArchive = newShowArchive;
        prefs.setBool('showArchive', newShowArchive);

        return emitter(state.copyWith(showArchive: newShowArchive));
            //NormalSettingsState(currentLocale, currentTheme, currentFont, newShowArchive));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });
  }
}
