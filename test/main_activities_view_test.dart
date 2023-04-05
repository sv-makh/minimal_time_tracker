import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';
import 'package:minimal_time_tracker/widgets/activity_card.dart';
import 'package:minimal_time_tracker/screens/main_activities_view.dart';
import 'test_material_app.dart';

void main() {
  group('MainActivitiesScreen tests', () {
    String boxName = 'mockBox';
    String archiveName = 'mockArchive';
    late Box<Activity> testActivitiesBox;
    late Box<Activity> testArchiveBox;

    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(TimeIntervalAdapter());
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(PresentationAdapter());

    late SettingsBloc settingsBloc;

    setUp(() async {
      await setUpTestHive();
      testActivitiesBox = await Hive.openBox<Activity>(boxName);
      testArchiveBox = await Hive.openBox<Activity>(archiveName);
      settingsBloc = SettingsBloc();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    testWidgets('no Activity cards on screen when Hive boxes are empty',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        TestMaterialApp(
          child: MainActivitiesView(),
          boxName: boxName,
          archiveName: archiveName,
          settingsBloc: settingsBloc,
        ),
      );

      expect(find.byKey(Key('noActivitiesText')), findsOneWidget);
      expect(find.byType(ActivityCard), findsNothing);
      expect(find.byKey(Key('archivedActivitiesText')), findsNothing);
    });

    testWidgets('one Activity in Hive box shows one card on screen',
        (widgetTester) async {

      await widgetTester.runAsync(
          () => testActivitiesBox.add(Activity(title: 'test activity')));

      await widgetTester.pumpWidget(
        TestMaterialApp(
          child: MainActivitiesView(),
          boxName: boxName,
          archiveName: archiveName,
          settingsBloc: settingsBloc,
        ),
      );

      expect(find.byType(ActivityCard), findsOneWidget);
      //проверка, что карточка с активностью находится в основной секции
      expect(
          find.ancestor(
              of: find.byType(ActivityCard),
              matching: find.byKey(Key('activitiesBoxListView.builder'))),
          findsOneWidget);

    });

    testWidgets(
        'one Activity in archive Hive box shows one card on screen in archive section',
        (widgetTester) async {
      await widgetTester
          .runAsync(() => testArchiveBox.add(Activity(title: 'test activity')));

      await widgetTester.pumpWidget(
        TestMaterialApp(
          child: MainActivitiesView(),
          boxName: boxName,
          archiveName: archiveName,
          settingsBloc: settingsBloc,
        ),
      );

      //проверка, что по умолчанию архивные активности показываются
      SettingsState settingsState = settingsBloc.state;
      expect(settingsState.showArchive, equals(true));

      expect(find.byType(ActivityCard), findsOneWidget);
      expect(find.byKey(Key('archivedActivitiesText')), findsOneWidget);

      //проверка, что карточка с архивной активностью находится в архивной секции
      expect(
          find.ancestor(
              of: find.byType(ActivityCard),
              matching: find.byKey(Key('archiveListView.builder'))),
          findsOneWidget);
    });
  });
}
