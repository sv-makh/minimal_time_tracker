import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/settings/settings_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:minimal_time_tracker/settings/settings_bloc/settings_bloc.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockContext extends Mock implements BuildContext {}

void main() {
  late SettingsRepository settingsRepository;

  setUp(() {
    settingsRepository = MockSettingsRepository();
  });

  Locale defaultLocale = Locale('en', '');
  String defaultTheme = 'Pale';
  int defaultFontSize = 12;
  bool defaultArch = true;
  bool defaultThemeMode = true;
  SettingsState defaultState = SettingsState(
      locale: defaultLocale,
      theme: defaultTheme,
      themeMode: defaultThemeMode,
      fontSize: defaultFontSize,
      showArchive: defaultArch,
      status: Status.normal);

  test('testing default values for Settings', () {
    SettingsBloc settingsBloc =
        SettingsBloc(settingsRepository: settingsRepository);
    SettingsState settingsState = settingsBloc.state;

    expect(settingsState.theme, defaultTheme);
    expect(settingsState.fontSize, defaultFontSize);
    expect(settingsState.showArchive, defaultArch);
    expect(settingsState.status, Status.normal);
    expect(settingsState.locale, defaultLocale);
  });

  BuildContext testContext = MockContext();

  group('SettingsBloc tests', () {
    blocTest<SettingsBloc, SettingsState>(
      'emits [] when nothing is added',
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      expect: () => [],
    );

    blocTest<SettingsBloc, SettingsState>(
      'setting initial state',
      setUp: () {
        when(() => settingsRepository.getTheme()).thenReturn(defaultTheme);
        when(() => settingsRepository.getFontSize())
            .thenReturn(defaultFontSize);
        when(() => settingsRepository.getLocale()).thenReturn(defaultLocale);
        when(() => settingsRepository.getArchiveVisibility())
            .thenReturn(defaultArch);
        when(() => settingsRepository.getThemeMode(testContext))
            .thenReturn(defaultThemeMode);
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(SetInitialSetting(context: testContext)),
      expect: () => [defaultState],
      verify: (_) {
        verify(() => settingsRepository.getTheme()).called(1);
        verify(() => settingsRepository.getFontSize()).called(1);
        verify(() => settingsRepository.getLocale()).called(1);
        verify(() => settingsRepository.getArchiveVisibility()).called(1);
        verify(() => settingsRepository.getThemeMode(testContext)).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing language',
      setUp: () {
        when(() => settingsRepository.setLocale(Locale('ru', ''))).thenAnswer((_) {});
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeLanguage(locale: Locale('ru', ''))),
      expect: () => [
        SettingsState(
            locale: Locale('ru', ''),
            theme: defaultTheme,
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.normal)
      ],
      verify: (_) {
        verify(() => settingsRepository.setLocale(Locale('ru', ''))).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing language & error',
      setUp: () {
        when(() => settingsRepository.setLocale(Locale('ru', ''))).thenThrow(Exception('Error'));
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeLanguage(locale: Locale('ru', ''))),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.error)
      ],
      verify: (_) {
        verify(() => settingsRepository.setLocale(Locale('ru', ''))).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing font size',
      setUp: () {
        when(() => settingsRepository.setFontSize(14)).thenAnswer((_) {});
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeFontSize(fontSize: 14)),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            fontSize: 14,
            showArchive: defaultArch,
            status: Status.normal)
      ],
      verify: (_) {
        verify(() => settingsRepository.setFontSize(14)).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing font size & error',
      setUp: () {
        when(() => settingsRepository.setFontSize(14)).thenThrow(Exception('Error'));
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeFontSize(fontSize: 14)),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.error)
      ],
      verify: (_) {
        verify(() => settingsRepository.setFontSize(14)).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing theme',
      setUp: () {
        when(() => settingsRepository.setTheme('Pastel')).thenAnswer((_) {});
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeTheme(theme: 'Pastel')),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: 'Pastel',
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.normal)
      ],
      verify: (_) {
        verify(() => settingsRepository.setTheme('Pastel')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing theme & error',
      setUp: () {
        when(() => settingsRepository.setTheme('Pastel')).thenThrow(Exception('Error'));
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeTheme(theme: 'Pastel')),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.error)
      ],
      verify: (_) {
        verify(() => settingsRepository.setTheme('Pastel')).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing visibility for archived activities',
      setUp: () {
        when(() => settingsRepository.setArchiveVisibility(false)).thenAnswer((_) {});
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeArchiveVisibility(showArchive: false)),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            fontSize: defaultFontSize,
            showArchive: false,
            status: Status.normal)
      ],
      verify: (_) {
        verify(() => settingsRepository.setArchiveVisibility(false)).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing visibility for archived activities & error',
      setUp: () {
        when(() => settingsRepository.setArchiveVisibility(false)).thenThrow(Exception('Error'));
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeArchiveVisibility(showArchive: false)),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.error)
      ],
      verify: (_) {
        verify(() => settingsRepository.setArchiveVisibility(false)).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing theme mode',
      setUp: () {
        when(() => settingsRepository.setThemeMode(false)).thenAnswer((_) {});
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeThemeMode(mode: false)),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            themeMode: false,
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.normal)
      ],
      verify: (_) {
        verify(() => settingsRepository.setThemeMode(false)).called(1);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'changing theme mode & error',
      setUp: () {
        when(() => settingsRepository.setThemeMode(false)).thenThrow(Exception('Error'));
      },
      build: () => SettingsBloc(settingsRepository: settingsRepository),
      act: (bloc) => bloc.add(ChangeThemeMode(mode: false)),
      expect: () => [
        SettingsState(
            locale: defaultLocale,
            theme: defaultTheme,
            themeMode: defaultThemeMode,
            fontSize: defaultFontSize,
            showArchive: defaultArch,
            status: Status.error)
      ],
      verify: (_) {
        verify(() => settingsRepository.setThemeMode(false)).called(1);
      },
    );
  });
}
