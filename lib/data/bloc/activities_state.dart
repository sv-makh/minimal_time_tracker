part of 'activity_bloc.dart';

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

  @override
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
  }
}