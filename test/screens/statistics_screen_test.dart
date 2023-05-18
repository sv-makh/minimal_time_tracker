import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });
}
