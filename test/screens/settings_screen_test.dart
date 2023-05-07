import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/bloc/activity_bloc.dart';
import 'package:minimal_time_tracker/screens/settings_screen.dart';
import 'package:minimal_time_tracker/settings/bloc/settings_bloc.dart';
import 'package:mocktail/mocktail.dart';
import '../test_material_app.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockActivitiesBloc extends MockBloc<ActivityEvent, ActivitiesState>
    implements ActivitiesBloc {}

void main() {
  group('SettingsScreen tests', () {
    //String boxName = 'mockBox';
    //String archiveName = 'mockArchive';
    late Box<Activity> testActivitiesBox;
    late Box<Activity> testArchiveBox;
    late SettingsBloc settingsBloc;
    late ActivitiesBloc activitiesBloc;

    setUpAll(() {
      Hive.registerAdapter(ActivityAdapter());
      Hive.registerAdapter(TimeIntervalAdapter());
      Hive.registerAdapter(DurationAdapter());
      Hive.registerAdapter(PresentationAdapter());
    });

    setUp(() async {
      settingsBloc = MockSettingsBloc();
      await setUpTestHive();
      //testActivitiesBox = await Hive.openBox<Activity>(boxName);
      //testArchiveBox = await Hive.openBox<Activity>(archiveName);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    testWidgets('default settings screen', (widgetTester) async {
      when(() => settingsBloc.state)
          .thenReturn(SettingsState(locale: Locale('en', ''), theme: 'Olive', fontSize: 12, showArchive: true));

      await widgetTester.pumpWidget(TestMaterialApp(
          child: SettingsScreen(),
          //boxName: boxName,
          //archiveName: archiveName,
          settingsBloc: settingsBloc));

      expect(find.text('Language'), findsOneWidget);
      final langButton =
          widgetTester.widget(find.byKey(Key('languageCodeDropdownButton')))
              as DropdownButton;
      expect(langButton.value, equals('en'));

      expect(find.text('Theme'), findsOneWidget);
      final themeButton = widgetTester
          .widget(find.byKey(Key('themeDropdownButton'))) as DropdownButton;
      expect(themeButton.value, equals('Olive'));

      expect(find.text('Font'), findsOneWidget);
      final fontButton = widgetTester
          .widget(find.byKey(Key('fontDropdownButton'))) as DropdownButton;
      expect(fontButton.value, equals(12));

      expect(find.text('Show archived activities'), findsOneWidget);
      final switchArchive =
          widgetTester.widget(find.byKey(Key('archiveSwitch'))) as Switch;
      expect(switchArchive.value, equals(true));
    });
  });
}
