import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';

void main() {
  SharedPreferences? prefs;

  test('testing default values for Settings', () {
    SettingsBloc settingsBloc = SettingsBloc();
    SettingsState settingsState = settingsBloc.state;

    expect(settingsState.theme, equals('Pale'));
    expect(settingsState.fontSize, equals(12));
    expect(settingsState.showArchive, equals(true));
  });

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
      'description',
      build: () => SettingsBloc(),
      act: (bloc) => bloc.add(SetInitialSetting()),
      expect: () => [SettingsState(Locale('en', ''), 'Pale', 12, true)],
    );
  });
}
