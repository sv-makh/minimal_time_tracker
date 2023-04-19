import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

import 'package:minimal_time_tracker/data/activity.dart';

part 'main_view_event.dart';

part 'main_view_state.dart';

class MainViewBloc extends Bloc<MainViewEvent, MainViewState> {
  String boxName;
  String archiveName;

  MainViewBloc({required this.boxName, required this.archiveName})
      : super(NormalMainViewState()) {
    Box<Activity> activitiesBox = Hive.box<Activity>(boxName);
    Box<Activity> archiveBox = Hive.box<Activity>(archiveName);

    MainViewState? prevState;

    on<ActivityDeletedMve>(
        (ActivityDeletedMve event, Emitter<MainViewState> emitter) {
      try {
        int index = event.index;
        Activity activity = activitiesBox.getAt(index)!;
        activitiesBox.deleteAt(index);
        return emitter(NormalMainViewState(activity, index));
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });

    on<ActivityAddedTimeMve>(
        (ActivityAddedTimeMve event, Emitter<MainViewState> emitter) {
      try {
        int index = event.index;
        Activity activity = activitiesBox.getAt(index)!;
        activity.addInterval(event.interval);
        activitiesBox.putAt(index, activity);

        MainViewState state = NormalMainViewState(activity, index);
        if (prevState == null) { print('prevState is null'); }
        else {
          if (prevState == state) {print('states are eq');}
          else { print('states are not eq');}
        }
        //print('activity hash = ${activity.hashCode}');
        print('state hash = ${state.hashCode}');
        print('prevState hash = ${prevState.hashCode}');

        prevState = state;
        return emitter(state);
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });

    //?
    on<ActivityAddedMve>(
        (ActivityAddedMve event, Emitter<MainViewState> emitter) {
      try {
        activitiesBox.add(event.activity);
        return emitter(NormalMainViewState());
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });

    on<PressedNewActivityMve>(
        (PressedNewActivityMve event, Emitter<MainViewState> emitter) {
      try {
        Activity newActivity = Activity(
          title: '',
          subtitle: '',
          durationButtons: [Duration(hours: 1), Duration(minutes: 30)],
          presentation: Presentation.BUTTONS,
          maxNum: 0,
          color: 0,
        );
        return emitter(NormalMainViewState(newActivity));
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });

    on<EditActivityMve>(
        (EditActivityMve event, Emitter<MainViewState> emitter) {
      try {
        Activity activity = activitiesBox.getAt(event.index)!;
        return emitter(NormalMainViewState(activity));
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });

    on<SaveEditedActivityMve>(
        (SaveEditedActivityMve event, Emitter<MainViewState> emitter) {
      try {
        activitiesBox.putAt(event.index, event.activity);
        return emitter(NormalMainViewState());
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });

    on<ActivityArchivedMve>(
        (ActivityArchivedMve event, Emitter<MainViewState> emitter) {
      try {
        Activity activity = activitiesBox.getAt(event.index)!;
        archiveBox.add(activity);
        activitiesBox.deleteAt(event.index);
        return emitter(NormalMainViewState());
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });

    on<ActivityUnarchivedMve>(
        (ActivityUnarchivedMve event, Emitter<MainViewState> emitter) {
      try {
        Activity activity = archiveBox.getAt(event.index)!;
        activitiesBox.add(activity);
        archiveBox.deleteAt(event.index);
        return emitter(NormalMainViewState());
      } catch (_) {
        return emitter(ErrorMainViewState());
      }
    });
  }
}
