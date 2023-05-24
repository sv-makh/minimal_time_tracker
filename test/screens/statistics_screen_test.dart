import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/statistics_bloc/statistics_bloc.dart';
import 'package:minimal_time_tracker/screens/statistics_screen.dart';
import 'package:minimal_time_tracker/settings/settings_bloc/settings_bloc.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../helper_test_material_app.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockStatisticsBloc extends MockBloc<StatisticsEvent, StatisticsState>
    implements StatisticsBloc {}

void main() {
  late ActivityRepository activityRepository;
  SettingsBloc settingsBloc = MockSettingsBlock();
  StatisticsBloc statisticsBloc = MockStatisticsBloc();

  group('StatisticsScreen error tests', () {
    setUp(() {
      activityRepository = MockActivityRepository();

      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pale',
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      when(() => statisticsBloc.state).thenReturn(ErrorStatisticsState());
    });

    testWidgets('Error message when error state', (widgetTester) async {
      await widgetTester.pumpWidget(TestMaterialApp(
        settingsBloc: settingsBloc,
        statisticsBloc: statisticsBloc,
        child: StatisticsScreen(activityRepository: activityRepository),
      ));

      expect(find.byKey(Key('something wrong stats')), findsOneWidget);
    });
  });

  group('StatisticsScreen tests', () {
    setUp(() {
      activityRepository = MockActivityRepository();

      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pale',
          fontSize: 12,
          showArchive: true,
          status: Status.normal));
    });

    testWidgets('No chart when repository is empty', (widgetTester) async {
      when(() => statisticsBloc.state).thenReturn(NormalStatisticsState(
          shownActivities: {}, shownArchiveActivities: {}));

      when(() => activityRepository.isActivitiesEmpty).thenReturn(true);
      when(() => activityRepository.isArchiveEmpty).thenReturn(true);

      await widgetTester.pumpWidget(TestMaterialApp(
        settingsBloc: settingsBloc,
        statisticsBloc: statisticsBloc,
        child: StatisticsScreen(activityRepository: activityRepository),
      ));

      expect(find.byKey(Key('noActivitiesText stats')), findsOneWidget);
      expect(find.byKey(Key('stats chart')), findsNothing);
    });

    testWidgets('screen with data', (widgetTester) async {
      Activity testActivity1 = Activity(title: 'test title');
      Activity testActivity2 = Activity(title: 'arch title');
      testActivity1.addInterval(TimeInterval.duration(
          end: DateTime.now(), duration: Duration(hours: 1)));
      testActivity2.addInterval(TimeInterval.duration(
          end: DateTime.now(), duration: Duration(hours: 2)));

      when(() => statisticsBloc.state).thenReturn(NormalStatisticsState(
          shownActivities: {0: true}, shownArchiveActivities: {0: true}));
      when(() => activityRepository.isActivitiesEmpty).thenReturn(false);
      when(() => activityRepository.isArchiveEmpty).thenReturn(false);
      when(() => activityRepository.isArchiveNotEmpty).thenReturn(true);
      when(() => activityRepository.activitiesLength).thenReturn(1);
      when(() => activityRepository.getActivityFromBoxAt(0))
          .thenReturn(testActivity1);
      when(() => activityRepository.archiveLength).thenReturn(1);
      when(() => activityRepository.getActivityFromArchiveAt(0))
          .thenReturn(testActivity2);

      await widgetTester.pumpWidget(TestMaterialApp(
        settingsBloc: settingsBloc,
        statisticsBloc: statisticsBloc,
        child: StatisticsScreen(activityRepository: activityRepository),
      ));

      expect(find.byKey(Key('stats chart')), findsOneWidget);
      expect(find.byKey(Key('stats activities')), findsOneWidget);
      expect(find.byKey(Key('stats archive')), findsOneWidget);
      expect(find.byType(Checkbox), findsNWidgets(2));
      expect(find.text('test title, 1 h'), findsOneWidget);
      expect(find.text('arch title, 2 h'), findsOneWidget);
    });
  });
}
