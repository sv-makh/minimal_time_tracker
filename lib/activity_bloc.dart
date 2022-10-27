//import 'dart:html';

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

class PressedNewActivity extends ActivityEvent {}

class ChangePresentation extends ActivityEvent {
  Presentation presentation;

  ChangePresentation({required this.presentation});
}

class AddedDurationForTable extends ActivityEvent {
  Duration duration;

  AddedDurationForTable({required this.duration});
}

class ChangeNumOfCells extends ActivityEvent {
  int num;

  ChangeNumOfCells({required this.num});
}

class ActivitiesState {
  final Box<Activity> activitiesBox;
  Map<Duration, bool> durationButtons;
  int color;
  Presentation presentation;
  int numOfCells;

  ActivitiesState(this.activitiesBox, this.durationButtons, this.color,
      this.presentation, this.numOfCells);
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

  Presentation presentation = Presentation.BUTTONS;

  int numOfCells = 0;

  ActivitiesBloc()
      : super(ActivitiesState(
          Hive.box<Activity>(boxName),
          {
            Duration(hours: 1): false,
            Duration(minutes: 30): false,
          },
          0,
          Presentation.BUTTONS,
          0,
        )) {
    on<ActivityDeleted>(
        (ActivityDeleted event, Emitter<ActivitiesState> emitter) {
      activitiesBox.deleteAt(event.index);
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<ActivityAddedTime>(
        (ActivityAddedTime event, Emitter<ActivitiesState> emitter) {
      Activity activity = activitiesBox.getAt(event.index)!;
      activity.addInterval(event.interval);
      activitiesBox.putAt(event.index, activity);
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<ActivityAdded>((ActivityAdded event, Emitter<ActivitiesState> emitter) {
      activitiesBox.add(event.activity);
      durationButtons = {
        Duration(hours: 1): false,
        Duration(minutes: 30): false,
      };
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<AddedDurationButton>(
        (AddedDurationButton event, Emitter<ActivitiesState> emitter) {
      durationButtons.update(event.duration, (value) => false,
          ifAbsent: () => false);
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<PressedDurationButton>(
        (PressedDurationButton event, Emitter<ActivitiesState> emitter) {
      durationButtons.update(event.duration, (value) => !value,
          ifAbsent: () => false);
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<ChangeColor>((ChangeColor event, Emitter<ActivitiesState> emitter) {
      color = event.color;
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<PressedNewActivity>(
        (PressedNewActivity event, Emitter<ActivitiesState> emitter) {
      return emitter(ActivitiesState(activitiesBox, defaultDurationButtons, 0,
          Presentation.BUTTONS, numOfCells));
    });

    on<ChangePresentation>(
        (ChangePresentation event, Emitter<ActivitiesState> emitter) {
      presentation = event.presentation;
      if (presentation == Presentation.TABLE) {
        durationButtons.clear();
      } else {
        numOfCells = 0;
        durationButtons = {
          Duration(hours: 1): false,
          Duration(minutes: 30): false,
        };
      }
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<AddedDurationForTable>(
        (AddedDurationForTable event, Emitter<ActivitiesState> emitter) {
      durationButtons.clear();
      durationButtons.update(event.duration, (value) => false,
          ifAbsent: () => false);
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });

    on<ChangeNumOfCells>((ChangeNumOfCells event, Emitter<ActivitiesState> emitter) {
      numOfCells = event.num;
      return emitter(ActivitiesState(
          activitiesBox, durationButtons, color, presentation, numOfCells));
    });
  }
}
