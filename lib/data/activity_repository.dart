import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'activity.dart';

class ActivityRepository {
  String boxName;
  String archiveName;
  late Box<Activity> activitiesBox;
  late Box<Activity> archiveBox;

  ActivityRepository()
      : this.boxName = 'activitiesBox',
        this.archiveName = 'archiveBox';

  ActivityRepository.setBoxnames(
      {required this.boxName, required this.archiveName});

  bool get isActivitiesEmpty {
    try {
      return activitiesBox.values.isEmpty;
    } catch (_) {
      return true;
    }
  }

  bool get isActivitiesNotEmpty {
    try {
      return activitiesBox.values.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  bool get isArchiveEmpty {
    try {
      return archiveBox.values.isEmpty;
    } catch (_) {
      return true;
    }
  }

  int get activitiesLength {
    try {
      return activitiesBox.length;
    } catch (_) {
      return 0;
    }
  }

  int get archiveLength {
    try {
      return archiveBox.length;
    } catch (_) {
      return 0;
    }
  }

  Future<void> initRepository() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(TimeIntervalAdapter());
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(PresentationAdapter());
    await Hive.openBox<Activity>(boxName);
    await Hive.openBox<Activity>(archiveName);

    activitiesBox = Hive.box<Activity>(boxName);
    archiveBox = Hive.box<Activity>(archiveName);
  }

  void activitiesDeleteAt(int index) {
    activitiesBox.deleteAt(index);
  }

  void archiveDeleteAt(int index) {
    archiveBox.deleteAt(index);
  }

  void addTimeToActivity(int index, TimeInterval interval) {
    Activity activity = activitiesBox.getAt(index)!;
    activity.addInterval(interval);
    activitiesBox.putAt(index, activity);
  }

  void addActivityToBox(Activity activity) {
    activitiesBox.add(activity);
  }

  void addActivityToArchive(Activity activity) {
    archiveBox.add(activity);
  }

  void deleteTimeFromActivity(int index, int intervalIndex) {
    Activity activity = activitiesBox.getAt(index)!;
    activity.intervalsList.removeAt(intervalIndex);
    activitiesBox.putAt(index, activity);
  }

  void putActivityToBoxAt(int index, Activity activity) {
    activitiesBox.putAt(index, activity);
  }

  void moveActivityFromBoxToArchive(int index) {
    Activity activity = activitiesBox.getAt(index)!;
    archiveBox.add(activity);
    activitiesBox.deleteAt(index);
  }

  void moveActivityFromArchiveToBox(int index) {
    Activity activity = archiveBox.getAt(index)!;
    activitiesBox.add(activity);
    archiveBox.deleteAt(index);
  }

  Activity getActivityFromBoxAt(int index) {
    return activitiesBox.getAt(index)!;
  }

  Activity getActivityFromArchiveAt(int index) {
    return archiveBox.getAt(index)!;
  }
}
