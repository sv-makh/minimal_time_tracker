import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_bloc/activity_bloc.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  group('ActivitiesBloc tests', () {
    late ActivityRepository activityRepository;

    final TimeInterval testTimeInterval = TimeInterval.duration(
        end: DateTime.now(), duration: Duration(hours: 1));
    late Activity testActivity;

    setUp(() {
      activityRepository = MockActivityRepository();

      testActivity = Activity(title: 'title', durationButtons: [
        Duration(hours: 1)], color: 1, presentation: Presentation.TABLE, maxNum: 2);
      testActivity.addInterval(testTimeInterval);
      testActivity.addInterval(testTimeInterval);
    });

    test('state of bloc', () {
      expect(ActivitiesBloc(activityRepository: activityRepository).state,
          isA<NormalActivitiesState>());
    });

    blocTest<ActivitiesBloc, ActivitiesState>(
      'emits [] when nothing is added',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      expect: () => [],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ActivityDeleted',
      setUp: () {
        when(() => activityRepository.activitiesDeleteAt(0)).thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityDeleted(index: 0)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) =>
          verify(() => activityRepository.activitiesDeleteAt(0)).called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after ActivityDeleted',
      setUp: () {
        when(() => activityRepository.activitiesDeleteAt(0))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityDeleted(index: 0)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) =>
          verify(() => activityRepository.activitiesDeleteAt(0)).called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ArchivedActivityDeleted',
      setUp: () {
        when(() => activityRepository.archiveDeleteAt(0)).thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ArchivedActivityDeleted(index: 0)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) =>
          verify(() => activityRepository.archiveDeleteAt(0)).called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after ArchivedActivityDeleted',
      setUp: () {
        when(() => activityRepository.archiveDeleteAt(0))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ArchivedActivityDeleted(index: 0)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) =>
          verify(() => activityRepository.archiveDeleteAt(0)).called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ActivityAddedTime',
      setUp: () {
        when(() => activityRepository.addTimeToActivity(0, testTimeInterval))
            .thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityAddedTime(
        index: 0,
        interval: testTimeInterval,
      )),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) => verify(
              () => activityRepository.addTimeToActivity(0, testTimeInterval))
          .called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after ActivityAddedTime',
      setUp: () {
        when(() => activityRepository.addTimeToActivity(0, testTimeInterval))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityAddedTime(
        index: 0,
        interval: testTimeInterval,
      )),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) => verify(
              () => activityRepository.addTimeToActivity(0, testTimeInterval))
          .called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ActivityAdded',
      setUp: () {
        when(() => activityRepository.addActivityToBox(testActivity))
            .thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityAdded(activity: testActivity)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        verify(() => activityRepository.addActivityToBox(testActivity))
            .called(1);
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.color, 0);
        expect(state.durationButtons,
            {Duration(hours: 1): false, Duration(minutes: 30): false});
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after ActivityAdded',
      setUp: () {
        when(() => activityRepository.addActivityToBox(testActivity))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityAdded(activity: testActivity)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) =>
          verify(() => activityRepository.addActivityToBox(testActivity))
              .called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after AddedDurationButton',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(AddedDurationButton(duration: Duration(hours: 2))),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.durationButtons, {
          Duration(hours: 1): false,
          Duration(minutes: 30): false,
          Duration(hours: 2): false,
        });
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after PressedDurationButton',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(PressedDurationButton(duration: Duration(hours: 1))),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.durationButtons, {
          Duration(hours: 1): true,
          Duration(minutes: 30): false,
        });
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ChangeColor',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ChangeColor(color: 2)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.color, 2);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after PressedNewActivity',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(PressedNewActivity()),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.editedActivity, null);
        expect(state.color, 0);
        expect(state.presentation, Presentation.BUTTONS);
        expect(state.numOfCells, 0);
        expect(state.durationButtons, {
          Duration(hours: 1): false,
          Duration(minutes: 30): false,
        });
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ChangePresentation',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(ChangePresentation(presentation: Presentation.TABLE)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.presentation, Presentation.TABLE);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after AddedDurationForTable',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(AddedDurationForTable(duration: Duration(hours: 2))),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.durationButtons, {Duration(hours: 2): false});
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ChangeNumOfCells',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ChangeNumOfCells(num: 10)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.numOfCells, 10);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after DeleteIntervalWithIndex',
      setUp: () {
        when(() => activityRepository.deleteTimeFromActivity(0, 0))
            .thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(DeleteIntervalWithIndex(activityIndex: 0, intervalIndex: 0)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) {
        verify(() => activityRepository.deleteTimeFromActivity(0, 0)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after DeleteIntervalWithIndex',
      setUp: () {
        when(() => activityRepository.deleteTimeFromActivity(0, 0))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(DeleteIntervalWithIndex(activityIndex: 0, intervalIndex: 0)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) {
        verify(() => activityRepository.deleteTimeFromActivity(0, 0)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after EditActivity',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(EditActivity(activity: testActivity)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.color, testActivity.color);
        expect(state.presentation, testActivity.presentation);
        expect(state.numOfCells, testActivity.maxNum);
        expect(state.durationButtons, {testActivity.durationButtons[0]: true});
        expect(state.intervals, [0, 1]);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after SaveEditedActivity',
      setUp: () {
        when(() => activityRepository.putActivityToBoxAt(0, testActivity))
            .thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(SaveEditedActivity(activity: testActivity, index: 0)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) {
        verify(() => activityRepository.putActivityToBoxAt(0, testActivity)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after SaveEditedActivity',
      setUp: () {
        when(() => activityRepository.putActivityToBoxAt(0, testActivity))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(SaveEditedActivity(activity: testActivity, index: 0)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) {
        verify(() => activityRepository.putActivityToBoxAt(0, testActivity)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after DeleteIntervalEditedActivity',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc..add(EditActivity(activity: testActivity))
      ..add(DeleteIntervalEditedActivity(index: 1)),
      skip: 1,
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.editedActivity!.totalTime(), testTimeInterval.duration);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after DeleteAllIntervalsEditedActivity',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc..add(EditActivity(activity: testActivity))
        ..add(DeleteAllIntervalsEditedActivity()),
      skip: 1,
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.editedActivity!.totalTime(), Duration());
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after DeleteIntervalScreen',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc..add(EditActivity(activity: testActivity))
        ..add(DeleteIntervalScreen(index: 0)),
      skip: 1,
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.intervals, [1]);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after DeleteIntervalScreen',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc..add(EditActivity(activity: testActivity))
        ..add(DeleteIntervalScreen(index: 2)),
      skip: 1,
      expect: () => [isA<ActivitiesError>()],
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after DeleteAllIntervalsScreen',
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc..add(EditActivity(activity: testActivity))
        ..add(DeleteAllIntervalsScreen()),
      skip: 1,
      expect: () => [isA<NormalActivitiesState>()],
      verify: (bloc) {
        NormalActivitiesState state = bloc.state as NormalActivitiesState;
        expect(state.intervals, []);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ActivityArchived',
      setUp: () {
        when(() => activityRepository.moveActivityFromBoxToArchive(0))
            .thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(ActivityArchived(index: 0)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) {
        verify(() => activityRepository.moveActivityFromBoxToArchive(0)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after ActivityArchived',
      setUp: () {
        when(() => activityRepository.moveActivityFromBoxToArchive(0))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(ActivityArchived(index: 0)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) {
        verify(() => activityRepository.moveActivityFromBoxToArchive(0)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'normal state after ActivityUnarchived',
      setUp: () {
        when(() => activityRepository.moveActivityFromArchiveToBox(0))
            .thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(ActivityUnarchived(index: 0)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) {
        verify(() => activityRepository.moveActivityFromArchiveToBox(0)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state after ActivityUnarchived',
      setUp: () {
        when(() => activityRepository.moveActivityFromArchiveToBox(0))
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) =>
          bloc.add(ActivityUnarchived(index: 0)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) {
        verify(() => activityRepository.moveActivityFromArchiveToBox(0)).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>('normal state after DeleteAllActivities',
      setUp: () {
        when(() => activityRepository.clearAll())
            .thenAnswer((_) async {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(DeleteAllActivities()),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) {
        verify(() => activityRepository.clearAll()).called(1);
      },
    );

    blocTest<ActivitiesBloc, ActivitiesState>('error state after DeleteAllActivities',
      setUp: () {
        when(() => activityRepository.clearAll())
            .thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(DeleteAllActivities()),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) {
        verify(() => activityRepository.clearAll()).called(1);
      },
    );
  });
}
