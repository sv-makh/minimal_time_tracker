import 'package:minimal_time_tracker/data/activity.dart';

List<Activity> activities = [
  Activity(title: 'Reading', durationButtons: [Duration(hours: 1)]),
  Activity(
      title: 'Exercizing',
      durationButtons: [Duration(hours: 1), Duration(minutes: 30)]),
  Activity(title: 'Exercizing', subtitle: 'Yoga', durationButtons: [
    Duration(hours: 1, minutes: 30),
    Duration(seconds: 30),
    Duration(hours: 2, minutes: 15, seconds: 45),
  ]),
  Activity(title: 'Exercizing', subtitle: 'Cycling'),
  Activity(title: 'Sleeping'),
];
