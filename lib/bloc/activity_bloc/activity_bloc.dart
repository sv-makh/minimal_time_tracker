import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';

part 'activity_event.dart';

part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivityEvent, ActivitiesState> {
  final ActivityRepository activityRepository;

  Map<Duration, bool> defaultDurationButtons = {
    const Duration(hours: 1): false,
    const Duration(minutes: 30): false,
  };

  Map<Duration, bool> durationButtons = {
    const Duration(hours: 1): false,
    const Duration(minutes: 30): false,
  };

  int color = 0;

  Presentation presentation = Presentation.BUTTONS;

  int numOfCells = 0;

  List<int> intervals = [];

  Activity? editedActivity;

  ActivitiesBloc({required this.activityRepository})
      : super(NormalActivitiesState(
          {
            const Duration(hours: 1): false,
            const Duration(minutes: 30): false,
          },
          0,
          Presentation.BUTTONS,
          0,
          [],
        )) {
    on<ActivityDeleted>(
        (ActivityDeleted event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.activitiesDeleteAt(event.index);
        return emitter(NormalActivitiesState(
            durationButtons, color, presentation, numOfCells, intervals));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ArchivedActivityDeleted>(
        (ArchivedActivityDeleted event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.archiveDeleteAt(event.index);
        return emitter(NormalActivitiesState(
            durationButtons, color, presentation, numOfCells, intervals));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ActivityAddedTime>(
        (ActivityAddedTime event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.addTimeToActivity(event.index, event.interval);
        return emitter(NormalActivitiesState(
            durationButtons, color, presentation, numOfCells, intervals));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ActivityAdded>((ActivityAdded event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.addActivityToBox(event.activity);
        durationButtons = {
          const Duration(hours: 1): false,
          const Duration(minutes: 30): false,
        };
        color = 0;
        intervals.clear();
        return emitter(NormalActivitiesState(
            durationButtons, color, presentation, numOfCells, intervals));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<AddedDurationButton>(
        (AddedDurationButton event, Emitter<ActivitiesState> emitter) {
      try {
        durationButtons.update(event.duration, (value) => false,
            ifAbsent: () => false);
        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<PressedDurationButton>(
        (PressedDurationButton event, Emitter<ActivitiesState> emitter) {
      try {
        durationButtons.update(event.duration, (value) => !value,
            ifAbsent: () => false);
        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ChangeColor>((ChangeColor event, Emitter<ActivitiesState> emitter) {
      try {
        color = event.color;
        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<PressedNewActivity>(
        (PressedNewActivity event, Emitter<ActivitiesState> emitter) {
      try {
        editedActivity = null;
        color = 0;
        durationButtons.clear();
        durationButtons = {
          const Duration(hours: 1): false,
          const Duration(minutes: 30): false,
        };
        presentation = Presentation.BUTTONS;
        numOfCells = 0;
        intervals.clear();
        return emitter(NormalActivitiesState(defaultDurationButtons, 0,
            Presentation.BUTTONS, numOfCells, intervals));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ChangePresentation>(
        (ChangePresentation event, Emitter<ActivitiesState> emitter) {
      try {
        presentation = event.presentation;
        if (presentation == Presentation.TABLE) {
          durationButtons.clear();
        } else {
          numOfCells = 0;
          durationButtons = {
            const Duration(hours: 1): false,
            const Duration(minutes: 30): false,
          };
        }
        ActivitiesState state = NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity);
        return emitter(state);
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<AddedDurationForTable>(
        (AddedDurationForTable event, Emitter<ActivitiesState> emitter) {
      try {
        durationButtons.clear();
        durationButtons.update(event.duration, (value) => false,
            ifAbsent: () => false);
        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ChangeNumOfCells>(
        (ChangeNumOfCells event, Emitter<ActivitiesState> emitter) {
      try {
        numOfCells = event.num;
        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<DeleteIntervalWithIndex>(
        (DeleteIntervalWithIndex event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.deleteTimeFromActivity(
            event.activityIndex, event.intervalIndex);

        return emitter(NormalActivitiesState(
            durationButtons, color, presentation, numOfCells, intervals));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<DeleteIntervalScreen>(
        (DeleteIntervalScreen event, Emitter<ActivitiesState> emitter) {
      try {
        intervals.removeAt(event.index);
        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<DeleteAllIntervalsScreen>(
        (DeleteAllIntervalsScreen event, Emitter<ActivitiesState> emitter) {
      try {
        intervals.clear();
        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<EditActivity>((EditActivity event, Emitter<ActivitiesState> emitter) {
      try {
        durationButtons.clear();
        for (var d in event.activity.durationButtons) {
          durationButtons[d] = true;
        }
        color = event.activity.color!;
        presentation = event.activity.presentation!;
        if (presentation == Presentation.TABLE) {
          numOfCells = event.activity.maxNum!;
        }
        intervals.clear();
        for (int i = 0; i < event.activity.intervalsList.length; i++) {
          intervals.add(i);
        }
        editedActivity = event.activity;

        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<SaveEditedActivity>(
        (SaveEditedActivity event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.putActivityToBoxAt(event.index, event.activity);

        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<DeleteIntervalEditedActivity>(
        (DeleteIntervalEditedActivity event, Emitter<ActivitiesState> emitter) {
      try {
        editedActivity!.intervalsList.removeAt(event.index);

        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<DeleteAllIntervalsEditedActivity>(
        (DeleteAllIntervalsEditedActivity event,
            Emitter<ActivitiesState> emitter) {
      try {
        editedActivity!.intervalsList.clear();

        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ActivityArchived>(
        (ActivityArchived event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.moveActivityFromBoxToArchive(event.index);

        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<ActivityUnarchived>(
        (ActivityUnarchived event, Emitter<ActivitiesState> emitter) {
      try {
        activityRepository.moveActivityFromArchiveToBox(event.index);

        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });

    on<DeleteAllActivities>(
        (DeleteAllActivities event, Emitter<ActivitiesState> emitter) async {
      try {
        await activityRepository.clearAll();

        return emitter(NormalActivitiesState(durationButtons, color,
            presentation, numOfCells, intervals, editedActivity));
      } catch (_) {
        return emitter(ActivitiesError());
      }
    });
  }
}
