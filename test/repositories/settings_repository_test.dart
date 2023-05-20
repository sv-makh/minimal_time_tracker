import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/settings/settings_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class MockContext extends Mock implements BuildContext {}

void main() {
  group('SettingsRepository tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late SettingsRepository settingsRepository;

    String langCode = 'ru';
    String theme = 'Pastel';
    int fontSize = 14;
    bool showArchive = false;
    bool themeMode = true;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'lang': langCode,
        'theme': theme,
        'fontSize': fontSize,
        'showArchive': showArchive,
        'themeMode': themeMode,
      });
      settingsRepository = SettingsRepository();
      await settingsRepository.initRepository();
    });

    test('getLocale', () {
      expect(settingsRepository.getLocale(), Locale(langCode));
    });

    test('getTheme', () {
      expect(settingsRepository.getTheme(), theme);
    });

    test('getFontSize', () {
      expect(settingsRepository.getFontSize(), fontSize);
    });

    test('getArchiveVisibility', () {
      expect(settingsRepository.getArchiveVisibility(), showArchive);
    });

    test('getThemeMode', () {
      BuildContext context = MockContext();
      expect(settingsRepository.getThemeMode(context), themeMode);
    });

    test('setThemeMode', () {
      BuildContext context = MockContext();
      settingsRepository.setThemeMode(!themeMode);
      expect(settingsRepository.getThemeMode(context), !themeMode);
    });

    test('setLocale', () {
      Locale testLocale = Locale('en');
      settingsRepository.setLocale(testLocale);
      expect(settingsRepository.getLocale(), testLocale);
    });

    test('setTheme', () {
      String testTheme = 'Pale';
      settingsRepository.setTheme(testTheme);
      expect(settingsRepository.getTheme(), testTheme);
    });

    test('setFontSize', () {
      int testFontSize = 16;
      settingsRepository.setFontSize(testFontSize);
      expect(settingsRepository.getFontSize(), testFontSize);
    });

    test('setArchiveVisibility', () {
      settingsRepository.setArchiveVisibility(!showArchive);
      expect(settingsRepository.getArchiveVisibility(), !showArchive);
    });
  });
}