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

class ChangeColor extends ActivityEvent {
  int color;

  ChangeColor({required this.color});
}

class ActivitiesState{
  final Box<Activity> activitiesBox;
  Map<Duration, bool> durationButtons;
  int color;

  ActivitiesState(this.activitiesBox, this.durationButtons, this.color);
}

class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState> {
  Box<Activity> activitiesBox = Hive.box<Activity>(boxName);

  Map<Duration, bool> defaultDurationButtons = {
    Duration(hours: 1): false,
    Duration(minutes: 30): false,
  };

  Map<Duration, bool> durationButtons = {
    Duration(hours: 1): false,
    Duration(minutes: 30): false,
  };

  int color = 0;

  ActivitiesBloc() : super(ActivitiesState(Hive.box<Activity>(boxName), {
    Duration(hours: 1): false,
    Duration(minutes: 30): false,
  }, 0)) {
    on<ActivityDeleted>(
            (ActivityDeleted event, Emitter<ActivitiesState> emitter) {
          activitiesBox.deleteAt(event.index);
          return emitter(ActivitiesState(activitiesBox, durationButtons, color));
        });

    on<ActivityAddedTime>(
            (ActivityAddedTime event, Emitter<ActivitiesState> emitter) {
          Activity activity = activitiesBox.getAt(event.index)!;
          activity.addInterval(event.interval);
          activitiesBox.putAt(event.index, activity);
          return emitter(ActivitiesState(activitiesBox, durationButtons, color));
        });

    on<ActivityAdded>((ActivityAdded event, Emitter<ActivitiesState> emitter) {
      activitiesBox.add(event.activity);
      durationButtons = {
        Duration(hours: 1): false,
        Duration(minutes: 30): false,
      };
      return emitter(ActivitiesState(activitiesBox, durationButtons, color));
    });

    on<AddedDurationButton>((AddedDurationButton event,
        Emitter<ActivitiesState> emitter) {
      durationButtons.update(
          event.duration, (value) => false, ifAbsent: () => false);
      return emitter(ActivitiesState(activitiesBox, durationButtons, color));
    });

    on<PressedDurationButton>((PressedDurationButton event,
        Emitter<ActivitiesState> emitter) {
      durationButtons.update(
          event.duration, (value) => !value, ifAbsent: () => false);
      return emitter(ActivitiesState(activitiesBox, durationButtons, color));
    });

    on<ChangeColor>((ChangeColor event, Emitter<ActivitiesState> emitter) {
      color = event.color;
      return emitter(ActivitiesState(activitiesBox, durationButtons, color));
    });
  }
}
