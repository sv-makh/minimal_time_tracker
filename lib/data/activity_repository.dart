import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'activity.dart';

class ActivityRepository {
  String boxName;
  String archiveName;

  ActivityRepository()
      : this.boxName = 'activitiesBox',
        this.archiveName = 'archiveBox';

  ActivityRepository.setBoxnames(
      {required this.boxName, required this.archiveName});

  void initRepository() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(TimeIntervalAdapter());
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(PresentationAdapter());
    await Hive.openBox<Activity>(boxName);
    await Hive.openBox<Activity>(archiveName);
  }



}
