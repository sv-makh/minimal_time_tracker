part of 'statistics_bloc.dart';

abstract class StatisticsState {}

class NormalStatisticsState extends StatisticsState {
  final Map<int, bool> shownActivities;
  final Map<int, bool> shownArchiveActivities;

  NormalStatisticsState({
    required this.shownActivities,
    required this.shownArchiveActivities,
  });
}

class ErrorStatisticsState extends StatisticsState {}
