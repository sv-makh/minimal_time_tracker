//import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

import 'package:minimal_time_tracker/data/activity.dart';

//import 'hive_data.dart';

part 'activities_state.dart';
part 'activity_event.dart';

class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState> {
  String boxName;
  String archiveName;

  //Box<Activity> activitiesBox = Hive.box<Activity>(boxName);
  //Box<Activity> archiveBox = Hive.box<Activity>(archiveName);

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

  Activity? editedActivity;

  ActivitiesBloc(this.boxName, this.archiveName)
      : super(ActivitiesState(
          Hive.box<Activity>(boxName),
          Hive.box<Activity>(archiveName),
          {
            Duration(hours: 1): false,
            Duration(minutes: 30): false,
          },
          0,
          Presentation.BUTTONS,
          0,
        )) {
    Box<Activity> activitiesBox = Hive.box<Activity>(boxName);
    Box<Activity> archiveBox = Hive.box<Activity>(archiveName);

    on<ActivityDeleted>(
        (ActivityDeleted event, Emitter<ActivitiesState> emitter) {
        activitiesBox.deleteAt(event.index);
        return emitter(ActivitiesState(activitiesBox, archiveBox,
            durationButtons, color, presentation, numOfCells));
    });

    on<ActivityAddedTime>(
        (ActivityAddedTime event, Emitter<ActivitiesState> emitter) {
      Activity activity = activitiesBox.getAt(event.index)!;
      activity.addInterval(event.interval);
      activitiesBox.putAt(event.index, activity);
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells));
    });

    on<ActivityAdded>((ActivityAdded event, Emitter<ActivitiesState> emitter) {
      activitiesBox.add(event.activity);
      durationButtons = {
        Duration(hours: 1): false,
        Duration(minutes: 30): false,
      };
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells));
    });

    on<AddedDurationButton>(
        (AddedDurationButton event, Emitter<ActivitiesState> emitter) {
      durationButtons.update(event.duration, (value) => false,
          ifAbsent: () => false);
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<PressedDurationButton>(
        (PressedDurationButton event, Emitter<ActivitiesState> emitter) {
      durationButtons.update(event.duration, (value) => !value,
          ifAbsent: () => false);
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<ChangeColor>((ChangeColor event, Emitter<ActivitiesState> emitter) {
      color = event.color;
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<PressedNewActivity>(
        (PressedNewActivity event, Emitter<ActivitiesState> emitter) {
      return emitter(ActivitiesState(activitiesBox, archiveBox,
          defaultDurationButtons, 0, Presentation.BUTTONS, numOfCells));
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
      ActivitiesState state = ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity);
/*      print('ChangePresentation durationButtons = $durationButtons ; color = $color ; presentation = $presentation ; numOfCells = $numOfCells ; editedActivity = $editedActivity');
      print('ChangePresentation hash = ${state.hashCode}');
      print('ChangePresentation durationButtons length = ${durationButtons.length}');*/
      return emitter(state);
    });

    on<AddedDurationForTable>(
        (AddedDurationForTable event, Emitter<ActivitiesState> emitter) {
      durationButtons.clear();
      durationButtons.update(event.duration, (value) => false,
          ifAbsent: () => false);
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<ChangeNumOfCells>(
        (ChangeNumOfCells event, Emitter<ActivitiesState> emitter) {
      numOfCells = event.num;
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<DeleteIntervalWithIndex>(
        (DeleteIntervalWithIndex event, Emitter<ActivitiesState> emitter) {
      Activity activity = activitiesBox.getAt(event.activityIndex)!;
      activity.intervalsList.removeAt(event.intervalIndex);
      activitiesBox.putAt(event.activityIndex, activity);

      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells));
    });

    on<EditActivity>((EditActivity event, Emitter<ActivitiesState> emitter) {
      durationButtons.clear();
      for (var d in event.activity.durationButtons) {
        durationButtons[d] = true;
      }
      color = event.activity.color!;
      presentation = event.activity.presentation!;
      if (presentation == Presentation.TABLE) {
        numOfCells = event.activity.maxNum!;
      }
      editedActivity = event.activity;

      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<SaveEditedActivity>(
        (SaveEditedActivity event, Emitter<ActivitiesState> emitter) {
      activitiesBox.putAt(event.index, event.activity);

      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<DeleteIntervalEditedActivity>(
        (DeleteIntervalEditedActivity event, Emitter<ActivitiesState> emitter) {
      editedActivity!.intervalsList.removeAt(event.index);

      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<DeleteAllIntervalsEditedActivity>(
        (DeleteAllIntervalsEditedActivity event,
            Emitter<ActivitiesState> emitter) {
      editedActivity!.intervalsList.clear();

      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<ActivityArchived>(
        (ActivityArchived event, Emitter<ActivitiesState> emitter) {
      Activity activity = activitiesBox.getAt(event.index)!;
      archiveBox.add(activity);
      activitiesBox.deleteAt(event.index);

      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });

    on<ActivityUnarchived>(
        (ActivityUnarchived event, Emitter<ActivitiesState> emitter) {
      Activity activity = archiveBox.getAt(event.index)!;
      activitiesBox.add(activity);
      archiveBox.deleteAt(event.index);

      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
    });
  }
}
