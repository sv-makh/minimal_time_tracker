part of 'statistics_bloc.dart';

abstract class StatisticsEvent {}

class ActivityPressed extends StatisticsEvent {
  int index;

  ActivityPressed({required this.index});
}

class ArchivedActivityPressed extends StatisticsEvent {
  int index;

  ArchivedActivityPressed({required this.index});
}

class OpenStatisticsScreen extends StatisticsEvent {}