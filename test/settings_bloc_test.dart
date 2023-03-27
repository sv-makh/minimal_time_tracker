import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';

void main() {

  test('testing default values for Settings', () {
    SettingsBloc settingsBloc = SettingsBloc();
    SettingsState settingsState = settingsBloc.state;

    expect(settingsState.theme, equals('Pale'));
    expect(settingsState.fontSize, equals(12));
    expect(settingsState.showArchive, equals(true));
  });

  Locale defaultLocale = Locale('en', '');
  String defaultTheme = 'Pale';
  int defaultFontSize = 12;
  bool defaultArch = true;
  SettingsState defaultState =
      SettingsState(defaultLocale, defaultTheme, defaultFontSize, defaultArch);

  group('SettingsBloc tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'lang': 'en',
        'theme': 'Pale',
        'fontSize': 12,
        'showArchive': true,
      });
    });

    blocTest<SettingsBloc, SettingsState>(
      'emits [] when nothing is added',
      build: () => SettingsBloc(),
      expect: () => [],
    );

    blocTest<SettingsBloc, SettingsState>(
      'setting initial state',
      build: () => SettingsBloc(),
      act: (bloc) => bloc.add(SetInitialSetting()),
      expect: () => [defaultState],
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing language',
      build: () => SettingsBloc(),
      act: (bloc) => bloc..add(SetInitialSetting())..add(ChangeLanguage(locale: Locale('ru', ''))),
      skip: 1,
      expect: () => [SettingsState(Locale('ru', ''), defaultTheme, defaultFontSize, defaultArch)],
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing font size',
      build: () => SettingsBloc(),
      act: (bloc) => bloc..add(SetInitialSetting())..add(ChangeFontSize(fontSize: 14)),
      skip: 1,
      expect: () => [SettingsState(defaultLocale, defaultTheme, 14, defaultArch)],
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing theme',
      build: () => SettingsBloc(),
      act: (bloc) => bloc..add(SetInitialSetting())..add(ChangeTheme(theme: 'Olive')),
      skip: 1,
      expect: () => [SettingsState(defaultLocale, 'Olive', defaultFontSize, defaultArch)],
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing visibility for archived activities',
      build: () => SettingsBloc(),
      act: (bloc) => bloc..add(SetInitialSetting())..add(ChangeArchiveVisibility(showArchive: false)),
      skip: 1,
      expect: () => [SettingsState(defaultLocale, defaultTheme, defaultFontSize, false)],
    );
  });
}
