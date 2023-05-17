import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_bloc/activity_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  group('ActivitiesBloc tests', () {
    late ActivityRepository activityRepository;

    setUp(() {
      activityRepository = MockActivityRepository();
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
      'normal state',
      setUp: () {
        when(() => activityRepository.activitiesDeleteAt(0)).thenAnswer((_) {});
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityDeleted(index: 0)),
      expect: () => [isA<NormalActivitiesState>()],
      verify: (_) => verify(() => activityRepository.activitiesDeleteAt(0)).called(1),
    );

    blocTest<ActivitiesBloc, ActivitiesState>(
      'error state',
      setUp: () {
        when(() => activityRepository.activitiesDeleteAt(0)).thenThrow(Exception('Error'));
      },
      build: () => ActivitiesBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityDeleted(index: 0)),
      expect: () => [isA<ActivitiesError>()],
      verify: (_) => verify(() => activityRepository.activitiesDeleteAt(0)).called(1),
    );
  });
}
