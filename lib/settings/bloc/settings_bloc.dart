import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:minimal_time_tracker/settings/settings_repository.dart';

part 'settings_state.dart';

part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository})
      : super(SettingsState(
            locale: Locale('en', ''),
            theme: 'Pale',
            fontSize: 12,
            showArchive: true)) {
    Locale? currentLocale;
    String? currentTheme;
    int? currentFont;
    bool? currentArchive;

    on<SetInitialSetting>(
        (SetInitialSetting event, Emitter<SettingsState> emitter) async {
      try {
        String initTheme = settingsRepository.getTheme();
        int initFont = settingsRepository.getFontSize();
        Locale initLocale = settingsRepository.getLocale();
        bool initArchive = settingsRepository.getArchiveVisibility();

        currentLocale = initLocale;
        currentFont = initFont;
        currentTheme = initTheme;
        currentArchive = initArchive;

        return emitter(state.copyWith(
            locale: initLocale,
            theme: initTheme,
            fontSize: initFont,
            showArchive: initArchive,
            status: Status.normal));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeLanguage>(
        (ChangeLanguage event, Emitter<SettingsState> emitter) async {
      try {
        Locale newLocale = event.locale;
        currentLocale = newLocale;
        settingsRepository.setLocale(newLocale);

        return emitter(state.copyWith(locale: newLocale));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeTheme>((ChangeTheme event, Emitter<SettingsState> emitter) async {
      try {
        String newTheme = event.theme;
        currentTheme = newTheme;
        settingsRepository.setTheme(newTheme);

        return emitter(state.copyWith(theme: newTheme));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeFontSize>(
        (ChangeFontSize event, Emitter<SettingsState> emitter) async {
      try {
        int newFontSize = event.fontSize;
        currentFont = newFontSize;
        settingsRepository.setFontSize(newFontSize);

        return emitter(state.copyWith(fontSize: newFontSize));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });

    on<ChangeArchiveVisibility>(
        (ChangeArchiveVisibility event, Emitter<SettingsState> emitter) async {
      try {
        bool newShowArchive = event.showArchive;
        currentArchive = newShowArchive;
        settingsRepository.setArchiveVisibility(newShowArchive);

        return emitter(state.copyWith(showArchive: newShowArchive));
      } catch (_) {
        return emitter(state.copyWith(status: Status.error));
      }
    });
  }
}
