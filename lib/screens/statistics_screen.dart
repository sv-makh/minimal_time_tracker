import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/activity.dart';
import '../data/statistics_bloc/statistics_bloc.dart';
import '../settings/settings_bloc/settings_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/activity_repository.dart';
import '../helpers/convert.dart';

//экран со статистикой - виджет с PieChart и под ним колонка чекбоксы с ативностями
class StatisticsScreen extends StatelessWidget {
  final ActivityRepository activityRepository;

  const StatisticsScreen({Key? key, required this.activityRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, SettingsState settingsState) {
      return BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
        if (state is NormalStatisticsState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.statistics),
            ),
            body: (activityRepository.isActivitiesEmpty &&
                    activityRepository.isArchiveEmpty)
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noActivities,
                      key: Key('noActivitiesText'),
                    ),
                  )
                : SafeArea(
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _pieChart(
                                context,
                                state.shownActivities,
                                state.shownArchiveActivities,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: activityRepository.activitiesLength,
                                itemBuilder: (BuildContext context, int index) {
                                  try {
                                    Activity currentActivity =
                                        activityRepository
                                            .getActivityFromBoxAt(index);
                                    return Row(
                                      children: [
                                        Checkbox(
                                            value: state.shownActivities[index],
                                            onChanged: (bool? value) {
                                              BlocProvider.of<StatisticsBloc>(
                                                      context)
                                                  .add(ActivityPressed(
                                                      index: index));
                                            }),
                                        Expanded(
                                          child: Text(
                                              '${currentActivity.title}, ${stringDuration(currentActivity.totalTime(), context)}'),
                                        ),
                                      ],
                                    );
                                  } catch (_) {
                                    return Container();
                                  }
                                },
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .archivedActivities,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: activityRepository.archiveLength,
                                itemBuilder: (BuildContext context, int index) {
                                  try {
                                    Activity currentActivity =
                                        activityRepository
                                            .getActivityFromArchiveAt(index);
                                    return Row(
                                      children: [
                                        Checkbox(
                                            value: state
                                                .shownArchiveActivities[index],
                                            onChanged: (bool? value) {
                                              BlocProvider.of<StatisticsBloc>(
                                                      context)
                                                  .add(ArchivedActivityPressed(
                                                      index: index));
                                            }),
                                        Expanded(
                                          child: Text(
                                              '${currentActivity.title}, ${stringDuration(currentActivity.totalTime(), context)}'),
                                        ),
                                      ],
                                    );
                                  } catch (_) {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        )),
                  ),
          );
        }
        return Text(AppLocalizations.of(context)!.somethingWrong);
      });
    });
  }

  //виджет с PieChart
  Widget _pieChart(BuildContext context, Map<int, bool> shownActivities,
      Map<int, bool> shownArchiveActivities) {
    double screenWidth = MediaQuery.of(context).size.width;

    //список активностей, выбранных для отображения
    List<Activity> _activitiesForChart() {
      List<Activity> res = [];
      shownActivities.forEach((key, value) {
        if (value) {
          res.add(activityRepository.getActivityFromBoxAt(key));
        }
      });
      shownArchiveActivities.forEach((key, value) {
        if (value) {
          res.add(activityRepository.getActivityFromArchiveAt(key));
        }
      });
      return res;
    }

    //суммарное время активностей, выбранных для отображения
    Duration _totalTime(List<Activity> resActivities) {
      Duration totalTime = Duration();
      for (var a in resActivities) {
        totalTime += a.totalTime();
      }
      return totalTime;
    }

    //список данных для секций чарта
    List<PieChartSectionData> _sectionsData() {
      List<PieChartSectionData> resList = [];
      List<Activity> resActivities = _activitiesForChart();
      Duration totalTime = _totalTime(resActivities);

      for (var a in resActivities) {
        String sectionTitle = a.title;
        //если заголовок для секции чарта слишком длиннный, укорачиваем
        if (sectionTitle.length > 13)
          sectionTitle = sectionTitle.substring(0, 13) + '...';

        resList.add(PieChartSectionData(
          value: a.totalTime().inMinutes * 100 / totalTime.inMinutes,
          color: Colors
              .primaries[resActivities.indexOf(a) % Colors.primaries.length],
          radius: screenWidth * 3 / 16,
          showTitle: true,
          title: sectionTitle,
        ));
      }

      return resList;
    }

    return SizedBox(
        width: screenWidth * 3 / 4,
        height: screenWidth * 3 / 4,
        child: Stack(children: [
          //в середине чарта показывается суммарное время активностей, выбранных для отображения
          Center(
              child: Text(
            stringDuration(_totalTime(_activitiesForChart()), context),
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          PieChart(
            PieChartData(
              sections: _sectionsData(),
              centerSpaceRadius: double.infinity,
              sectionsSpace: 1,
              borderData: FlBorderData(
                show: false,
              ),
            ),
          ),
        ]));
  }
}
