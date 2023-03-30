import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('ActivitiesBloc tests', () {
    String boxName = 'mockBox';
    String archiveName = 'mockArchive';
    late Box<Activity> testActivitiesBox;
    late Box<Activity> testArchiveBox;

    Map<Duration, bool> defaultDurationButtons = {
      Duration(hours: 1): false,
      Duration(minutes: 30): false,
    };
    int defaultColor = 0;
    Presentation defaultPresentation = Presentation.BUTTONS;
    int defaultNumOfCells = 0;

    late ActivitiesState testActivitiesState;

    setUpAll(() {
      Hive.registerAdapter(ActivityAdapter());
      Hive.registerAdapter(TimeIntervalAdapter());
      Hive.registerAdapter(DurationAdapter());
      Hive.registerAdapter(PresentationAdapter());
    });

    setUp(() async {
      await setUpTestHive();
      testActivitiesBox = await Hive.openBox<Activity>(boxName);
      testArchiveBox = await Hive.openBox<Activity>(archiveName);
      await testActivitiesBox.add(Activity(title: 'title0'));
      testActivitiesState = ActivitiesState(
          testActivitiesBox,
          testArchiveBox,
          defaultDurationButtons,
          defaultColor,
          defaultPresentation,
          defaultNumOfCells);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    blocTest<ActivitiesBloc, ActivitiesState>(
      'emits [] when nothing is added',
      build: () => ActivitiesBloc(boxName, archiveName),
      expect: () => [],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'deleting activity',
      //setUp: () => testActivitiesBox.add(Activity(title: 'title')),
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) => bloc.add(ActivityDeleted(index: 0)),
      expect: () => [testActivitiesState],
      verify: (_) {
        expect(testActivitiesBox.length, 0);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'adding interval to activity',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) => bloc.add(ActivityAddedTime(
        index: 0,
        interval: TimeInterval.duration(
            end: DateTime.now(), duration: Duration(hours: 1)),
      )),
      expect: () => [testActivitiesState],
      verify: (_) {
        Activity activity = testActivitiesBox.getAt(0)!;
        expect(activity.intervalsList.length, 1);
      },
    );
  });
}
