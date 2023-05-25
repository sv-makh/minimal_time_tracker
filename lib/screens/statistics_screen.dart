import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/activity.dart';
import '../data/activity_repository.dart';
import '../bloc/statistics_bloc/statistics_bloc.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
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
                      key: const Key('noActivitiesText stats'),
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
                                key: const Key('stats activities'),
                                physics: const NeverScrollableScrollPhysics(),
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
                              activityRepository.isArchiveNotEmpty
                                  ? Text(
                                      AppLocalizations.of(context)!
                                          .archivedActivities,
                                    )
                                  : Container(),
                              activityRepository.isArchiveNotEmpty
                                  ? ListView.builder(
                                      key: const Key('stats archive'),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          activityRepository.archiveLength,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        try {
                                          Activity currentActivity =
                                              activityRepository
                                                  .getActivityFromArchiveAt(
                                                      index);
                                          return Row(
                                            children: [
                                              Checkbox(
                                                  value: state
                                                          .shownArchiveActivities[
                                                      index],
                                                  onChanged: (bool? value) {
                                                    BlocProvider.of<
                                                                StatisticsBloc>(
                                                            context)
                                                        .add(
                                                            ArchivedActivityPressed(
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
                                    )
                                  : Container(),
                            ],
                          ),
                        )),
                  ),
          );
        }
        return Text(
          AppLocalizations.of(context)!.somethingWrong,
          key: const Key('something wrong stats'),
        );
      });
    });
  }

  //виджет с PieChart
  Widget _pieChart(BuildContext context, Map<int, bool> shownActivities,
      Map<int, bool> shownArchiveActivities) {
    double screenWidth = MediaQuery.of(context).size.width;

    //список активностей, выбранных для отображения
    List<Activity> activitiesForChart() {
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
    Duration totalTimeForChart(List<Activity> resActivities) {
      Duration totalTime = const Duration();
      for (var a in resActivities) {
        totalTime += a.totalTime();
      }
      return totalTime;
    }

    //список данных для секций чарта
    List<PieChartSectionData> sectionsData() {
      List<PieChartSectionData> resList = [];
      List<Activity> resActivities = activitiesForChart();
      Duration totalTime = totalTimeForChart(resActivities);

      for (var a in resActivities) {
        String sectionTitle = a.title;
        //если заголовок для секции чарта слишком длиннный, укорачиваем
        if (sectionTitle.length > 13) {
          sectionTitle = '${sectionTitle.substring(0, 13)}...';
        }

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
      key: const Key('stats chart'),
      width: screenWidth * 3 / 4,
      height: screenWidth * 3 / 4,
      child: Stack(
        children: [
          //в середине чарта показывается суммарное время активностей, выбранных для отображения
          Center(
              child: Text(
            stringDuration(totalTimeForChart(activitiesForChart()), context),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          PieChart(
            PieChartData(
              sections: sectionsData(),
              centerSpaceRadius: double.infinity,
              sectionsSpace: 1,
              borderData: FlBorderData(
                show: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
