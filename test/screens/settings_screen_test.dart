import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:minimal_time_tracker/screens/settings_screen.dart';
import 'package:minimal_time_tracker/bloc/settings_bloc/settings_bloc.dart';
import '../helper_test_material_app.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  group('SettingsScreen tests', () {
    SettingsBloc settingsBloc = MockSettingsBlock();

    testWidgets('SettingsScreen view', (widgetTester) async {
      when(() => settingsBloc.state).thenReturn(const SettingsState(
          locale: Locale('en', ''),
          theme: 'Pale',
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      await widgetTester.pumpWidget(TestMaterialApp(
        settingsBloc: settingsBloc,
        child: const SettingsScreen(),
      ));

      expect(find.text('Language'), findsOneWidget);
      final langButton = widgetTester
              .widget(find.byKey(const Key('languageCodeDropdownButton')))
          as DropdownButton;
      expect(langButton.value, equals('en'));

      expect(find.text('Theme'), findsOneWidget);
      final themeButton =
          widgetTester.widget(find.byKey(const Key('themeDropdownButton')))
              as DropdownButton;
      expect(themeButton.value, equals('Pale'));

      expect(find.text('Font'), findsOneWidget);
      final fontButton =
          widgetTester.widget(find.byKey(const Key('fontDropdownButton')))
              as DropdownButton;
      expect(fontButton.value, equals(12));

      expect(find.text('Show archived activities'), findsOneWidget);
      final switchArchive =
          widgetTester.widget(find.byKey(const Key('archiveSwitch'))) as Switch;
      expect(switchArchive.value, equals(true));
    });
  });
}
