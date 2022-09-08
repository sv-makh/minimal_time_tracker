import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';

class ActivityEvent {}

class ActivityDeleted extends ActivityEvent {
  int index;

  ActivityDeleted({required this.index});
}

class ActiviryAdded extends ActivityEvent {

}

class ActivityAddedTime extends ActivityEvent {
  int index;
  TimeInterval interval;

  ActivityAddedTime({required this.index, required this.interval});
}

class ActivitiesState {
  final List<Activity> activitiesState;

  ActivitiesState(this.activitiesState);
}

class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState>{
  List<Activity> activitiesBloc;

  ActivitiesBloc(this.activitiesBloc) : super(ActivitiesState(activitiesBloc));

  @override
  Stream<ActivitiesState> mapEventToState(ActivityEvent event) async* {
    if (event is ActivityDeleted) {
      yield* _mapActivityDeletedToState(event);
    } else if (event is ActivityAddedTime) {
      yield* _mapActivityAddedTimeToState(event);
    }
  }

  Stream<ActivitiesState> _mapActivityDeletedToState(ActivityDeleted event) async* {
    activitiesBloc.removeAt(event.index);
    yield ActivitiesState(activitiesBloc);
  }

  Stream<ActivitiesState> _mapActivityAddedTimeToState(ActivityAddedTime event) async* {
    activitiesBloc[event.index].addInterval(event.interval);
    yield ActivitiesState(activitiesBloc);
  }
}