part of 'statistics_bloc.dart';

abstract class StatisticsState {}

//в состоянии находятся данные о том, какие активности отображать в чарте
//Map<int, bool>: ключ - индекс активности, значение - отображать/не отображать
class NormalStatisticsState extends StatisticsState {
  final Map<int, bool> shownActivities;
  final Map<int, bool> shownArchiveActivities;

  NormalStatisticsState({
    required this.shownActivities,
    required this.shownArchiveActivities,
  });
}

class ErrorStatisticsState extends StatisticsState {}
