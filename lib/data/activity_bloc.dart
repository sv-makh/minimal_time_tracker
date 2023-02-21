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

class DeleteIntervalWithIndex extends ActivityEvent {
  int intervalIndex;
  int activityIndex;

  DeleteIntervalWithIndex(
      {required this.activityIndex, required this.intervalIndex});
}

class EditActivity extends ActivityEvent {
  Activity activity;

  EditActivity({required this.activity});
}

class SaveEditedActivity extends ActivityEvent {
  Activity activity;
  int index;

  SaveEditedActivity({required this.activity, required this.index});
}

class DeleteIntervalEditedActivity extends ActivityEvent {
  int index;

  DeleteIntervalEditedActivity({required this.index});
}

class DeleteAllIntervalsEditedActivity extends ActivityEvent {
  DeleteAllIntervalsEditedActivity();
}

class ActivityArchived extends ActivityEvent {
  int index;

  ActivityArchived({required this.index});
}

class ActivityUnarchived extends ActivityEvent {
  int index;

  ActivityUnarchived({required this.index});
}

class ActivitiesState {
  final Box<Activity> activitiesBox;
  final Box<Activity> archiveBox;
  Map<Duration, bool> durationButtons;
  int color;
  Presentation presentation;
  int numOfCells;
  Activity? editedActivity;

  ActivitiesState(this.activitiesBox, this.archiveBox, this.durationButtons,
      this.color, this.presentation, this.numOfCells,
      [this.editedActivity]);
}

class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState> {
  Box<Activity> activitiesBox = Hive.box<Activity>(boxName);
  Box<Activity> archiveBox = Hive.box<Activity>(archiveName);

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

  ActivitiesBloc()
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
    on<ActivityDeleted>(
        (ActivityDeleted event, Emitter<ActivitiesState> emitter) {
      activitiesBox.deleteAt(event.index);
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells));
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
      return emitter(ActivitiesState(activitiesBox, archiveBox, durationButtons,
          color, presentation, numOfCells, editedActivity));
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
