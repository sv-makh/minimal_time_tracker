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

class AddedDurationButton extends ActivityEvent {
  Duration duration;

  AddedDurationButton({required this.duration});
}

class PressedDurationButton extends ActivityEvent {
  Duration duration;

  PressedDurationButton({required this.duration});
}

class ActivitiesState{
  final Box<Activity> activitiesBox;
  final Map<Duration, bool> durationButtons;

  ActivitiesState(this.activitiesBox, this.durationButtons);
}

class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState> {
  Box<Activity> activitiesBox = Hive.box<Activity>(boxName);

  Map<Duration, bool> durationButtons = {
    Duration(hours: 1): false,
    Duration(minutes: 30): false,
  };

  ActivitiesBloc() : super(ActivitiesState(Hive.box<Activity>(boxName), {
    Duration(hours: 1): false,
    Duration(minutes: 30): false,
  })) {
    on<ActivityDeleted>(
        (ActivityDeleted event, Emitter<ActivitiesState> emitter) {
      activitiesBox.deleteAt(event.index);
      return emitter(ActivitiesState(activitiesBox, durationButtons));
    });

    on<ActivityAddedTime>(
        (ActivityAddedTime event, Emitter<ActivitiesState> emitter) {
      Activity activity = activitiesBox.getAt(event.index)!;
      activity.addInterval(event.interval);
      activitiesBox.putAt(event.index, activity);
      return emitter(ActivitiesState(activitiesBox, durationButtons));
    });

    on<ActivityAdded>((ActivityAdded event, Emitter<ActivitiesState> emitter) {
      activitiesBox.add(event.activity);
      return emitter(ActivitiesState(activitiesBox, durationButtons));
    });

    on<AddedDurationButton>((AddedDurationButton event, Emitter<ActivitiesState> emitter) {
      durationButtons.update(event.duration, (value) => false, ifAbsent: () => false);
      return emitter(ActivitiesState(activitiesBox, durationButtons));
    });

    on<PressedDurationButton>((PressedDurationButton event, Emitter<ActivitiesState> emitter) {
      durationButtons.update(event.duration, (value) => !value, ifAbsent: () => false);
      return emitter(ActivitiesState(activitiesBox, durationButtons));
    });
  }
}
