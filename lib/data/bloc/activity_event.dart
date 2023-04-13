part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {}

//!
class ActivityDeleted extends ActivityEvent {
  final int index;

  ActivityDeleted({required this.index});

  @override
  List<Object?> get props => [index];
}

//!
class ActivityAdded extends ActivityEvent {
  final Activity activity;

  ActivityAdded({required this.activity});

  @override
  List<Object?> get props => [activity];
}

//!
class ActivityAddedTime extends ActivityEvent {
  final int index;
  final TimeInterval interval;

  ActivityAddedTime({required this.index, required this.interval});

  @override
  List<Object?> get props => [index, interval];
}

class AddedDurationButton extends ActivityEvent {
  final Duration duration;

  AddedDurationButton({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class PressedDurationButton extends ActivityEvent {
  final Duration duration;

  PressedDurationButton({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class ChangeColor extends ActivityEvent {
  final int color;

  ChangeColor({required this.color});

  @override
  List<Object?> get props => [color];
}

//!
class PressedNewActivity extends ActivityEvent {
  @override
  List<Object?> get props => [];
}

class ChangePresentation extends ActivityEvent {
  final Presentation presentation;

  ChangePresentation({required this.presentation});

  @override
  List<Object?> get props => [presentation];
}

class AddedDurationForTable extends ActivityEvent {
  final Duration duration;

  AddedDurationForTable({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class ChangeNumOfCells extends ActivityEvent {
  final int num;

  ChangeNumOfCells({required this.num});

  @override
  List<Object?> get props => [num];
}

class DeleteIntervalWithIndex extends ActivityEvent {
  final int intervalIndex;
  final int activityIndex;

  DeleteIntervalWithIndex(
      {required this.activityIndex, required this.intervalIndex});

  @override
  List<Object?> get props => [intervalIndex, activityIndex];
}

//!
class EditActivity extends ActivityEvent {
  final Activity activity;

  EditActivity({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class SaveEditedActivity extends ActivityEvent {
  final Activity activity;
  final int index;

  SaveEditedActivity({required this.activity, required this.index});

  @override
  List<Object?> get props => [activity, index];
}

class DeleteIntervalEditedActivity extends ActivityEvent {
  final int index;

  DeleteIntervalEditedActivity({required this.index});

  @override
  List<Object?> get props => [index];
}

class DeleteAllIntervalsEditedActivity extends ActivityEvent {
  DeleteAllIntervalsEditedActivity();

  @override
  List<Object?> get props => [];
}

//!
class ActivityArchived extends ActivityEvent {
  final int index;

  ActivityArchived({required this.index});

  @override
  List<Object?> get props => [index];
}

//!
class ActivityUnarchived extends ActivityEvent {
  final int index;

  ActivityUnarchived({required this.index});

  @override
  List<Object?> get props => [index];
}