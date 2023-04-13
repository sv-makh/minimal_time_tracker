part of 'activity_bloc.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();
}

class NormalActivitiesState extends ActivitiesState {
  //final Box<Activity> activitiesBox;
  //final Box<Activity> archiveBox;
  final Map<Duration, bool> durationButtons;
  final int color;
  final Presentation presentation;
  final int numOfCells;
  final Activity? editedActivity;

  NormalActivitiesState(//this.activitiesBox, this.archiveBox,
      this.durationButtons, this.color, this.presentation, this.numOfCells,
      [this.editedActivity]);

  @override
  List<Object?> get props => [
        //activitiesBox,
        //archiveBox,
        durationButtons,
        color,
        presentation,
        numOfCells,
        editedActivity,
      ];

/*  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ActivitiesState &&
            activitiesBox == other.activitiesBox &&
            archiveBox == other.archiveBox &&
            mapEquals(durationButtons, other.durationButtons) &&//result &&
            color == other.color &&
            presentation == other.presentation &&
            numOfCells == other.numOfCells &&
            editedActivity == other.editedActivity;
  }

  @override
  int get hashCode {
    int mapHash = 1;
    for (var k in durationButtons.keys) {
      mapHash ^= k.hashCode;
      mapHash ^= durationButtons[k].hashCode;
    }
    int result = activitiesBox.hashCode ^
    archiveBox.hashCode ^
    mapHash ^
    color.hashCode ^
    presentation.hashCode ^
    numOfCells.hashCode ^
    editedActivity.hashCode;
    return result;
  }*/
}

class ActivitiesError extends ActivitiesState {
  @override
  List<Object?> get props => [];
}
