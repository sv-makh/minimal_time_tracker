import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';
import 'package:minimal_time_tracker/data/statistics_bloc/statistics_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  group('StatisticsBloc tests', () {
    late ActivityRepository activityRepository;
    late Map<int, bool> testActivityMap;

    setUp(() {
      activityRepository = MockActivityRepository();
    });

    test('state of bloc', () {
      when(() => activityRepository.getActivityMap()).thenReturn({});
      when(() => activityRepository.getArchiveMap()).thenReturn({});

      expect(StatisticsBloc(activityRepository: activityRepository).state,
          isA<NormalStatisticsState>());
    });

    blocTest<StatisticsBloc, StatisticsState>(
      'normal state after OpenStatisticsScreen',
      setUp: () {
        when(() => activityRepository.getActivityMap()).thenReturn({});
        when(() => activityRepository.getArchiveMap()).thenReturn({});
      },
      build: () => StatisticsBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(OpenStatisticsScreen()),
      expect: () => [isA<NormalStatisticsState>()],
      verify: (_) {
        verify(() => activityRepository.getActivityMap()).called(1);
        verify(() => activityRepository.getArchiveMap()).called(1);
      },
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'error state after OpenStatisticsScreen',
      setUp: () {
        when(() => activityRepository.getActivityMap())
            .thenThrow(Exception('Error'));
      },
      build: () => StatisticsBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(OpenStatisticsScreen()),
      expect: () => [isA<ErrorStatisticsState>()],
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'normal state after ActivityPressed',
      setUp: () {
        when(() => activityRepository.getActivityMap()).thenReturn({0: false});
        when(() => activityRepository.getArchiveMap()).thenReturn({0: false});
      },
      build: () => StatisticsBloc(activityRepository: activityRepository),
      act: (bloc) {
        bloc
          ..add(OpenStatisticsScreen())
          ..add(ActivityPressed(index: 0));
      },
      expect: () =>
          [isA<NormalStatisticsState>(), isA<NormalStatisticsState>()],
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'error state after ActivityPressed',
      build: () => StatisticsBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ActivityPressed(index: 0)),
      expect: () => [isA<ErrorStatisticsState>()],
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'normal state after ArchivedActivityPressed',
      setUp: () {
        when(() => activityRepository.getActivityMap()).thenReturn({0: false});
        when(() => activityRepository.getArchiveMap()).thenReturn({0: false});
      },
      build: () => StatisticsBloc(activityRepository: activityRepository),
      act: (bloc) {
        bloc
          ..add(OpenStatisticsScreen())
          ..add(ArchivedActivityPressed(index: 0));
      },
      expect: () =>
      [isA<NormalStatisticsState>(), isA<NormalStatisticsState>()],
    );

    blocTest<StatisticsBloc, StatisticsState>(
      'error state after ActivityPressed',
      build: () => StatisticsBloc(activityRepository: activityRepository),
      act: (bloc) => bloc.add(ArchivedActivityPressed(index: 0)),
      expect: () => [isA<ErrorStatisticsState>()],
    );
  });
}
