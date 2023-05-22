import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  group('ActivityRepository tests', () {
    late ActivityRepository activityRepository;
    late Box<Activity> activitiesBox;
    late Box<Activity> archiveBox;
    Activity testActivity1 = Activity(title: 'title1');
    Activity testActivity2 = Activity(title: 'title2');
    Activity testActivity3 = Activity(title: 'title3');

    setUpAll(() {
      Hive.registerAdapter(ActivityAdapter());
      Hive.registerAdapter(TimeIntervalAdapter());
      Hive.registerAdapter(DurationAdapter());
      Hive.registerAdapter(PresentationAdapter());
    });

    setUp(() async {
      await setUpTestHive();
      activitiesBox = await Hive.openBox<Activity>('testBoxName');
      archiveBox = await Hive.openBox<Activity>('testArchiveName');

      activityRepository = ActivityRepository.setBoxnames(
          boxName: 'testBoxName', archiveName: 'testArchiveName');

      activitiesBox.add(testActivity1);
      archiveBox.add(testActivity2);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('emptiness', () {
      expect(activityRepository.isArchiveEmpty, false);
      expect(activityRepository.isActivitiesEmpty, false);
      expect(activityRepository.isActivitiesNotEmpty, true);
      expect(activityRepository.isArchiveNotEmpty, true);
    });

    test('length', () {
      expect(activityRepository.activitiesLength, 1);
      expect(activityRepository.archiveLength, 1);
    });

    test('get activity from box', () {
      expect(activityRepository.getActivityFromBoxAt(0).title,
          testActivity1.title);
    });

    test('get activity from archive', () {
      expect(activityRepository.getActivityFromArchiveAt(0).title,
          testActivity2.title);
    });

    test('adding activity', () {
      activityRepository.addActivityToBox(testActivity3);
      expect(activityRepository.activitiesLength, 2);
      expect(activityRepository.getActivityFromBoxAt(1).title,
          testActivity3.title);
    });

    test('adding activity to archive', () {
      activityRepository.addActivityToArchive(testActivity3);
      expect(activityRepository.archiveLength, 2);
      expect(activityRepository.getActivityFromArchiveAt(1)!.title,
          testActivity3.title);
    });

    test('delete from box', () {
      activityRepository.activitiesDeleteAt(0);
      expect(activityRepository.isActivitiesEmpty, true);
    });

    test('delete from archive', () {
      activityRepository.archiveDeleteAt(0);
      expect(activityRepository.isArchiveEmpty, true);
    });

    test('add time to activity', () {
      activityRepository
        ..addActivityToBox(testActivity3)
        ..addTimeToActivity(
            1,
            TimeInterval.duration(
                end: DateTime.now(), duration: Duration(hours: 1)));
      expect(activityRepository.getActivityFromBoxAt(1).totalTime(),
          Duration(hours: 1));

      activityRepository.activitiesDeleteAt(1);
    });

    test('delete time from activity', () {
      activityRepository
        ..addTimeToActivity(
            0,
            TimeInterval.duration(
                end: DateTime.now(), duration: Duration(hours: 1)))
        ..deleteTimeFromActivity(0, 0);
      expect(
          activityRepository.getActivityFromBoxAt(0).totalTime(), Duration());
    });

    test('moveActivityFromBoxToArchive', () {
      activityRepository.moveActivityFromBoxToArchive(0);
      expect(activityRepository.isActivitiesEmpty, true);
      expect(activityRepository.archiveLength, 2);
    });

    test('moveActivityFromArchiveToBox', () {
      activityRepository.moveActivityFromArchiveToBox(0);
      expect(activityRepository.isArchiveEmpty, true);
      expect(activityRepository.activitiesLength, 2);
    });

    test('getActivityMap', () {
      expect(activityRepository.getActivityMap(), {0: true});
    });

    test('getArchiveMap', () {
      expect(activityRepository.getArchiveMap(), {0: true});
    });

    test('putActivityToBoxAt', () {
      activityRepository.putActivityToBoxAt(0, testActivity3);
      expect(activityRepository.getActivityFromBoxAt(0).title,
          testActivity3.title);
    });
  });
}
