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
    late ActivitiesState testActivitiesState1;

    late Activity testActivity;

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

    blocTest<ActivitiesBloc, ActivitiesState>(
      'adding activity',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) =>
          bloc.add(ActivityAdded(activity: Activity(title: 'title1'))),
      expect: () => [testActivitiesState],
      verify: (_) {
        expect(testActivitiesBox.length, 2);
        expect(testActivitiesBox.getAt(0)!.title, 'title0');
        expect(testActivitiesBox.getAt(1)!.title, 'title1');
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'adding duration buttons',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) =>
          bloc.add(AddedDurationButton(duration: Duration(minutes: 15))),
      expect: () => [
        ActivitiesState(
            testActivitiesBox,
            testArchiveBox,
            {
              Duration(hours: 1): false,
              Duration(minutes: 30): false,
              Duration(minutes: 15): false,
            },
            defaultColor,
            defaultPresentation,
            defaultNumOfCells)
      ],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'pressing duration button',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) =>
          bloc.add(PressedDurationButton(duration: Duration(minutes: 30))),
      expect: () => [
        ActivitiesState(
            testActivitiesBox,
            testArchiveBox,
            {
              Duration(hours: 1): false,
              Duration(minutes: 30): true,
            },
            defaultColor,
            defaultPresentation,
            defaultNumOfCells)
      ],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'changing color',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) => bloc.add(ChangeColor(color: 1)),
      expect: () => [
        ActivitiesState(testActivitiesBox, testArchiveBox,
            defaultDurationButtons, 1, defaultPresentation, defaultNumOfCells)
      ],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'creating new activity',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) => bloc.add(PressedNewActivity()),
      expect: () => [testActivitiesState],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'changing presentation for buttons',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) =>
          bloc.add(ChangePresentation(presentation: Presentation.BUTTONS)),
      expect: () => [testActivitiesState],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'changing presentation',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) =>
          bloc.add(ChangePresentation(presentation: Presentation.TABLE)),
      expect: () => [ActivitiesState(
        testActivitiesBox,
        testArchiveBox,
        {},
        defaultColor,
        Presentation.TABLE,
        defaultNumOfCells,
      )],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'adding duration button',
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) =>
          bloc.add(AddedDurationForTable(duration: Duration(minutes: 15))),
      expect: () => [
        ActivitiesState(
            testActivitiesBox,
            testArchiveBox,
            {Duration(minutes: 15): false},
            defaultColor,
            defaultPresentation,
            defaultNumOfCells)
      ],
    );

    blocTest<ActivitiesBloc, ActivitiesState>('deleting interval from activity',
        setUp: () async {
          Activity newActivity = Activity(title: 'title1');
          newActivity.addInterval(TimeInterval.duration(
              end: DateTime.now(), duration: Duration(hours: 1)));
          newActivity.addInterval(TimeInterval.duration(
              end: DateTime.now(), duration: Duration(minutes: 30)));
          await testActivitiesBox.add(newActivity);
        },
        build: () => ActivitiesBloc(boxName, archiveName),
        act: (bloc) => bloc
            .add(DeleteIntervalWithIndex(activityIndex: 1, intervalIndex: 1)),
        expect: () => [testActivitiesState],
        verify: (_) {
          Activity newActivity = testActivitiesBox.getAt(1)!;
          expect(newActivity.intervalsList.length, 1);
        });

    blocTest<ActivitiesBloc, ActivitiesState>(
      'editing activity',
      setUp: () {
        testActivity = Activity(
          title: 'title1',
          subtitle: 'subtitle1',
          durationButtons: [Duration(minutes: 10), Duration(minutes: 1)],
          color: 1,
          presentation: Presentation.BUTTONS,
        );
      },
      build: () => ActivitiesBloc(boxName, archiveName),
      act: (bloc) => bloc.add(EditActivity(activity: testActivity)),
      expect: () => [
        ActivitiesState(
          testActivitiesBox,
          testArchiveBox,
          {Duration(minutes: 10): true, Duration(minutes: 1): true},
          1,
          Presentation.BUTTONS,
          defaultNumOfCells,
          testActivity,
        )
      ],
    );

    blocTest<ActivitiesBloc, ActivitiesState>('saving activity',
        build: () => ActivitiesBloc(boxName, archiveName),
        act: (bloc) => bloc.add(
            SaveEditedActivity(activity: Activity(title: 'title1'), index: 0)),
        expect: () => [testActivitiesState],
        verify: (_) {
          expect(testActivitiesBox.getAt(0)!.title, 'title1');
        });

    blocTest<ActivitiesBloc, ActivitiesState>(
        'delete interval from edited activity',
        setUp: () {
          testActivity = Activity(
            title: 'title1',
            subtitle: 'subtitle1',
            durationButtons: [Duration(minutes: 10), Duration(minutes: 1)],
            color: 1,
            presentation: Presentation.BUTTONS,
          );
          testActivity.addInterval(TimeInterval.duration(
              end: DateTime.now(), duration: Duration(hours: 1)));
          testActivity.addInterval(TimeInterval.duration(
              end: DateTime.now(), duration: Duration(minutes: 30)));
        },
        build: () => ActivitiesBloc(boxName, archiveName),
        act: (bloc) => bloc
          ..add(EditActivity(activity: testActivity))
          ..add(DeleteIntervalEditedActivity(index: 1)),
        expect: () => [
              ActivitiesState(
                testActivitiesBox,
                testArchiveBox,
                {Duration(minutes: 10): true, Duration(minutes: 1): true},
                1,
                Presentation.BUTTONS,
                defaultNumOfCells,
                testActivity,
              )
            ],
        verify: (_) {
          expect(testActivity.intervalsList.length, 1);
        });

    blocTest<ActivitiesBloc, ActivitiesState>(
        'delete all intervals from edited activity',
        setUp: () {
          testActivity = Activity(
            title: 'title1',
            subtitle: 'subtitle1',
            durationButtons: [Duration(minutes: 10), Duration(minutes: 1)],
            color: 1,
            presentation: Presentation.BUTTONS,
          );
          testActivity.addInterval(TimeInterval.duration(
              end: DateTime.now(), duration: Duration(hours: 1)));
          testActivity.addInterval(TimeInterval.duration(
              end: DateTime.now(), duration: Duration(minutes: 30)));
        },
        build: () => ActivitiesBloc(boxName, archiveName),
        act: (bloc) => bloc
          ..add(EditActivity(activity: testActivity))
          ..add(DeleteAllIntervalsEditedActivity()),
        expect: () => [
              ActivitiesState(
                testActivitiesBox,
                testArchiveBox,
                {Duration(minutes: 10): true, Duration(minutes: 1): true},
                1,
                Presentation.BUTTONS,
                defaultNumOfCells,
                testActivity,
              )
            ],
        verify: (_) {
          expect(testActivity.intervalsList.length, 0);
        });

    blocTest<ActivitiesBloc, ActivitiesState>('archiving activity',
        build: () => ActivitiesBloc(boxName, archiveName),
        act: (bloc) => bloc.add(ActivityArchived(index: 0)),
        expect: () => [testActivitiesState],
        verify: (_) {
          expect(testActivitiesBox.length, 0);
          expect(testArchiveBox.length, 1);
        });

    blocTest<ActivitiesBloc, ActivitiesState>('unarchiving activity',
        setUp: () async {
          await testArchiveBox.add(Activity(title: 'title1'));
        },
        build: () => ActivitiesBloc(boxName, archiveName),
        act: (bloc) => bloc.add(ActivityUnarchived(index: 0)),
        expect: () => [testActivitiesState],
        verify: (_) {
          expect(testActivitiesBox.length, 2);
          expect(testArchiveBox.length, 0);
        });
  });
}
