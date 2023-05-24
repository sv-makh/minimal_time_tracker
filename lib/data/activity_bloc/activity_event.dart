part of 'activity_bloc.dart';

abstract class ActivityEvent {}

class ActivityDeleted extends ActivityEvent {
  int index;

  ActivityDeleted({required this.index});
}

class ArchivedActivityDeleted extends ActivityEvent {
  int index;

  ArchivedActivityDeleted({required this.index});
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

class DeleteAllIntervalsEditedActivity extends ActivityEvent {}

class ActivityArchived extends ActivityEvent {
  int index;

  ActivityArchived({required this.index});
}

class ActivityUnarchived extends ActivityEvent {
  int index;

  ActivityUnarchived({required this.index});
}

class DeleteAllActivities extends ActivityEvent {}

class DeleteIntervalScreen extends ActivityEvent {
  int index;

  DeleteIntervalScreen({required this.index});
}

class DeleteAllIntervalsScreen extends ActivityEvent {}