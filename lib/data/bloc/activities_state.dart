part of 'activity_bloc.dart';

//без наследования от Equatable и без переопределения == и hashCode
//чтобы блок ребилдил виджеты для каждого состояния
//https://bloclibrary.dev/#/faqs?id=when-to-use-equatable

abstract class ActivitiesState {
  ActivitiesState();
}

class NormalActivitiesState extends ActivitiesState {
  final Box<Activity> activitiesBox;
  final Box<Activity> archiveBox;
  Map<Duration, bool> durationButtons;
  int color;
  Presentation presentation;
  int numOfCells;
  Activity? editedActivity;

  NormalActivitiesState(this.activitiesBox, this.archiveBox, this.durationButtons,
      this.color, this.presentation, this.numOfCells,
      [this.editedActivity]);

/*  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NormalActivitiesState &&
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
}