import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';

part 'statistics_event.dart';

part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final ActivityRepository activityRepository;

  StatisticsBloc({required this.activityRepository})
      : super(NormalStatisticsState(
          shownActivities: activityRepository.getActivityMap(),
          shownArchiveActivities: activityRepository.getArchiveMap(),
        )) {

    on<OpenStatisticsScreen>((OpenStatisticsScreen event, Emitter<StatisticsState> emitter) {
      try {
        return emitter(NormalStatisticsState(
          shownActivities: activityRepository.getActivityMap(),
          shownArchiveActivities: activityRepository.getArchiveMap(),
        ));
      } catch (_) {
        return emitter(ErrorStatisticsState());
      }
    });

    on<ActivityPressed>(
        (ActivityPressed event, Emitter<StatisticsState> emitter) {
      try {
        final state = this.state;
        if (state is NormalStatisticsState) {
          var actMap = state.shownActivities;
          actMap.update(event.index, (value) => !value);
          return emitter(NormalStatisticsState(
              shownActivities: actMap,
              shownArchiveActivities: state.shownArchiveActivities));
        }
      } catch (_) {
        return emitter(ErrorStatisticsState());
      }
    });

    on<ArchivedActivityPressed>(
        (ArchivedActivityPressed event, Emitter<StatisticsState> emitter) {
      try {
        final state = this.state;
        if (state is NormalStatisticsState) {
          var archMap = state.shownArchiveActivities;
          archMap.update(event.index, (value) => !value);
          return emitter(NormalStatisticsState(
              shownActivities: state.shownActivities,
              shownArchiveActivities: archMap));
        }
      } catch (_) {
        return emitter(ErrorStatisticsState());
      }
    });
  }
}
