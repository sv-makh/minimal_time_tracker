import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/activity_bloc/activity_bloc.dart';
import '../data/statistics_bloc/statistics_bloc.dart';
import '../settings/settings_bloc/settings_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/activity_repository.dart';

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
                              _pieChart(),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: activityRepository.activitiesLength,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  try {
                                    return Row(
                                      children: [
                                        Checkbox(value: state.shownActivities[index], onChanged: (bool? value) {
                                          BlocProvider.of<StatisticsBloc>(context).add(ActivityPressed(index: index));
                                        }),
                                        Text(activityRepository.getActivityFromBoxAt(index).title),
                                      ],
                                    );
                                  } catch (_) {
                                    return Container();
                                  }
                                    },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: activityRepository.archiveLength,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  try {
                                    return Row(
                                      children: [
                                        Checkbox(value: state.shownArchiveActivities[index], onChanged: (bool? value) {
                                          BlocProvider.of<StatisticsBloc>(context).add(ArchivedActivityPressed(index: index));
                                        }),
                                        Text(activityRepository.getActivityFromArchiveAt(index).title),
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

  Widget _pieChart() {
    List<PieChartSectionData> _sectionsData() {
      List<PieChartSectionData> resList = [];

      return resList;
    }

    return PieChart(
      PieChartData(sections: _sectionsData()),
    );
  }
}
