part of 'main_view_bloc.dart';

abstract class MainViewEvent extends Equatable {
  const MainViewEvent();
}

class ActivityDeletedMve extends MainViewEvent {
  final int index;

  const ActivityDeletedMve({required this.index});

  @override
  List<Object?> get props => [index];
}

class ActivityAddedMve extends MainViewEvent {
  final Activity activity;

  const ActivityAddedMve({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class ActivityAddedTimeMve extends MainViewEvent {
  final int index;
  final TimeInterval interval;

  const ActivityAddedTimeMve({required this.index, required this.interval});

  @override
  List<Object?> get props => [index, interval];
}

class PressedNewActivityMve extends MainViewEvent {
  @override
  List<Object?> get props => [];
}

class EditActivityMve extends MainViewEvent {
  final Activity activity;

  const EditActivityMve({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class ActivityArchivedMve extends MainViewEvent {
  final int index;

  const ActivityArchivedMve({required this.index});

  @override
  List<Object?> get props => [index];
}

class ActivityUnarchivedMve extends MainViewEvent {
  final int index;

  const ActivityUnarchivedMve({required this.index});

  @override
  List<Object?> get props => [index];
}