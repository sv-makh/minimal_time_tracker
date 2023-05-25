import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/bloc/activity_bloc/activity_bloc.dart';
import 'package:minimal_time_tracker/bloc/statistics_bloc/statistics_bloc.dart';
import 'package:minimal_time_tracker/bloc/settings_bloc/settings_bloc.dart';
import 'package:minimal_time_tracker/widgets/activity_card.dart';
import 'package:minimal_time_tracker/screens/main_activities_view.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';
import '../helper_test_material_app.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockActivitiesBloc extends MockBloc<ActivityEvent, ActivitiesState>
    implements ActivitiesBloc {}

class MockStatisticsBloc extends MockBloc<StatisticsEvent, StatisticsState>
    implements StatisticsBloc {}

void main() {
  late ActivityRepository activityRepository;
  SettingsBloc settingsBloc = MockSettingsBlock();
  ActivitiesBloc activitiesBloc = MockActivitiesBloc();
  StatisticsBloc statisticsBloc = MockStatisticsBloc();

  group('MainActivitiesScreen error tests', () {
    setUp(() {
      activityRepository = MockActivityRepository();

      when(() => settingsBloc.state).thenReturn(const SettingsState(
          locale: Locale('en', ''),
          theme: 'Pale',
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      when(() => activitiesBloc.state).thenReturn(ActivitiesError());

      when(() => statisticsBloc.state).thenReturn(NormalStatisticsState(
          shownActivities: {}, shownArchiveActivities: {}));
    });

    testWidgets('Error message when error state', (widgetTester) async {
      await widgetTester.pumpWidget(
        TestMaterialApp(
          settingsBloc: settingsBloc,
          activitiesBloc: activitiesBloc,
          statisticsBloc: statisticsBloc,
          child: MainActivitiesView(activityRepository: activityRepository),
        ),
      );

      expect(find.byKey(const Key('somethingWrong')), findsOneWidget);
    });
  });

  group('MainActivitiesScreen tests', () {
    setUp(() {
      activityRepository = MockActivityRepository();

      when(() => settingsBloc.state).thenReturn(const SettingsState(
          locale: Locale('en', ''),
          theme: 'Pale',
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      when(() => activitiesBloc.state).thenReturn(NormalActivitiesState(
          {const Duration(hours: 1): false, const Duration(minutes: 30): false},
          0,
          Presentation.BUTTONS,
          0,
          []));

      when(() => statisticsBloc.state).thenReturn(NormalStatisticsState(
          shownActivities: {}, shownArchiveActivities: {}));
    });

    testWidgets('no Activity cards on screen when activity repository is empty',
        (widgetTester) async {
      when(() => activityRepository.isActivitiesEmpty).thenReturn(true);
      when(() => activityRepository.isArchiveEmpty).thenReturn(true);

      await widgetTester.pumpWidget(
        TestMaterialApp(
          settingsBloc: settingsBloc,
          activitiesBloc: activitiesBloc,
          statisticsBloc: statisticsBloc,
          child: MainActivitiesView(activityRepository: activityRepository),
        ),
      );

      expect(find.byKey(const Key('noActivitiesText')), findsOneWidget);
      expect(find.byType(ActivityCard), findsNothing);
      expect(find.byKey(const Key('archivedActivitiesText')), findsNothing);
    });

    testWidgets(
        'one Activity in repository not in archive => one card on screen',
        (widgetTester) async {
      when(() => activityRepository.isActivitiesEmpty).thenReturn(false);
      when(() => activityRepository.isArchiveEmpty).thenReturn(true);
      when(() => activityRepository.isActivitiesNotEmpty).thenReturn(true);
      when(() => activityRepository.isArchiveNotEmpty).thenReturn(false);
      when(() => activityRepository.activitiesLength).thenReturn(1);
      when(() => activityRepository.getActivityFromBoxAt(0))
          .thenReturn(Activity(title: 'title'));

      await widgetTester.pumpWidget(
        TestMaterialApp(
          settingsBloc: settingsBloc,
          activitiesBloc: activitiesBloc,
          statisticsBloc: statisticsBloc,
          child: MainActivitiesView(activityRepository: activityRepository),
        ),
      );

      expect(find.byType(ActivityCard), findsOneWidget);
      //проверка, что карточка с активностью находится в основной секции
      expect(
          find.ancestor(
              of: find.byType(ActivityCard),
              matching: find.byKey(const Key('activitiesBoxListView.builder'))),
          findsOneWidget);
    });

    testWidgets('one Activity in repository in archive => one card on screen',
        (widgetTester) async {
      when(() => activityRepository.isActivitiesEmpty).thenReturn(true);
      when(() => activityRepository.isArchiveEmpty).thenReturn(false);
      when(() => activityRepository.isActivitiesNotEmpty).thenReturn(false);
      when(() => activityRepository.isArchiveNotEmpty).thenReturn(true);
      when(() => activityRepository.activitiesLength).thenReturn(0);
      when(() => activityRepository.archiveLength).thenReturn(1);
      when(() => activityRepository.getActivityFromArchiveAt(0))
          .thenReturn(Activity(title: 'title'));

      await widgetTester.pumpWidget(
        TestMaterialApp(
          settingsBloc: settingsBloc,
          activitiesBloc: activitiesBloc,
          statisticsBloc: statisticsBloc,
          child: MainActivitiesView(activityRepository: activityRepository),
        ),
      );

      expect(find.byType(ActivityCard), findsOneWidget);
      expect(find.byKey(const Key('archivedActivitiesText')), findsOneWidget);

      //проверка, что карточка с архивной активностью находится в архивной секции
      expect(
          find.ancestor(
              of: find.byType(ActivityCard),
              matching: find.byKey(const Key('archiveListView.builder'))),
          findsOneWidget);
    });
  });
}
