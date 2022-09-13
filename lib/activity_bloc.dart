import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';

class ActivityEvent {}

class ActivityDeleted extends ActivityEvent {
  int index;

  ActivityDeleted({required this.index});
}

class ActivityAdded extends ActivityEvent {
  Activity activity;

  ActivityAdded({required this.activity});
}

class ActivityAddedTime extends ActivityEvent {
  int index;
  TimeInterval interval;

  ActivityAddedTime({required this.index, required this.interval});
}

class ActivitiesState {
  final Box<Activity> activitiesBox;

  ActivitiesState(this.activitiesBox);
}

class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState> {
  Box<Activity> activitiesBox = Hive.box<Activity>(boxName);

  ActivitiesBloc() : super(ActivitiesState(Hive.box<Activity>(boxName))) {
    on<ActivityDeleted>(
        (ActivityDeleted event, Emitter<ActivitiesState> emitter) {
      activitiesBox.deleteAt(event.index);
      return emitter(ActivitiesState(activitiesBox));
    });

    on<ActivityAddedTime>(
        (ActivityAddedTime event, Emitter<ActivitiesState> emitter) {
      activitiesBox.getAt(event.index)!.addInterval(event.interval);
      return emitter(ActivitiesState(activitiesBox));
    });

    on<ActivityAdded>((ActivityAdded event, Emitter<ActivitiesState> emitter) {
      activitiesBox.add(event.activity);
      return emitter(ActivitiesState(activitiesBox));
    });
  }
}

/*class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState>{
  List<Activity> activitiesBloc;

  ActivitiesBloc(this.activitiesBloc) : super(ActivitiesState(activitiesBloc)) {

    on<ActivityDeleted>((ActivityDeleted event,
        Emitter<ActivitiesState> emitter) {
      activitiesBloc.removeAt(event.index);
      return emitter(ActivitiesState(activitiesBloc));
    });

    on<ActivityAddedTime>((ActivityAddedTime event, Emitter<ActivitiesState> emitter) {
      activitiesBloc[event.index].addInterval(event.interval);
      return emitter(ActivitiesState(activitiesBloc));
    });

    on<ActivityAdded>((ActivityAdded event, Emitter<ActivitiesState> emitter) {
      activitiesBloc.add(event.activity);
      return emitter(ActivitiesState(activitiesBloc));
    });
  }

}*/
