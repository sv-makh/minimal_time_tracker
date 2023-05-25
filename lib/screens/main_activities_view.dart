import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/add_activity_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/statistics_screen.dart';
import '../widgets/activity_card.dart';
import '../bloc/statistics_bloc/statistics_bloc.dart';
import '../bloc/activity_bloc/activity_bloc.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../data/activity_repository.dart';

class MainActivitiesView extends StatelessWidget {
  final ActivityRepository activityRepository;

  const MainActivitiesView({Key? key, required this.activityRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, SettingsState settingsState) {
        return BlocBuilder<ActivitiesBloc, ActivitiesState>(
          builder: (context, state) {
            return BlocBuilder<StatisticsBloc, StatisticsState>(
              builder: (context, statisticsState) {
                if (state is NormalActivitiesState) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(AppLocalizations.of(context)!.title),
                      actions: [
                        IconButton(
                          onPressed: () {
                            _goToStats(context);
                          },
                          icon: const Icon(Icons.bar_chart),
                        ),
                        IconButton(
                          onPressed: () {
                            _goToSettings(context);
                          },
                          icon: const Icon(Icons.settings),
                        )
                      ],
                    ),
                    body: (activityRepository.isActivitiesEmpty &&
                            activityRepository.isArchiveEmpty)
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.noActivities,
                              key: const Key('noActivitiesText'),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  key: const Key(
                                      'activitiesBoxListView.builder'),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      activityRepository.activitiesLength,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    try {
                                      return ActivityCard(
                                        activity: activityRepository
                                            .getActivityFromBoxAt(index),
                                        activityIndex: index,
                                        archived: false,
                                      );
                                    } catch (_) {
                                      return Container();
                                    }
                                  },
                                ),
                                (settingsState.showArchive &&
                                        activityRepository.isActivitiesNotEmpty)
                                    ? const SizedBox(
                                        height: 20,
                                      )
                                    : Container(),
                                (settingsState.showArchive &&
                                        activityRepository.isArchiveNotEmpty)
                                    ? Text(
                                        AppLocalizations.of(context)!
                                            .archivedActivities,
                                        key:
                                            const Key('archivedActivitiesText'),
                                      )
                                    : Container(),
                                (settingsState.showArchive &&
                                        activityRepository.isArchiveNotEmpty)
                                    ? ListView.builder(
                                        key: const Key(
                                            'archiveListView.builder'),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            activityRepository.archiveLength,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          try {
                                            return ActivityCard(
                                              activity: activityRepository
                                                  .getActivityFromArchiveAt(
                                                      index),
                                              activityIndex: index,
                                              archived: true,
                                            );
                                          } catch (_) {
                                            return Container();
                                          }
                                        },
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                    floatingActionButton: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        _addActivity(context);
                      },
                    ),
                  );
                }
                return Text(
                  AppLocalizations.of(context)!.somethingWrong,
                  key: const Key('somethingWrong'),
                );
              },
            );
          },
        );
      },
    );
  }

  void _goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _goToStats(BuildContext context) {
    BlocProvider.of<StatisticsBloc>(context).add(OpenStatisticsScreen());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(
          activityRepository: activityRepository,
        ),
      ),
    );
  }

  Future<void> _addActivity(BuildContext context) async {
    BlocProvider.of<ActivitiesBloc>(context).add(PressedNewActivity());

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddActivityScreen()),
    ).then(
      (value) => value != null
          ? BlocProvider.of<ActivitiesBloc>(context)
              .add(ActivityAdded(activity: value))
          : {},
    );
  }
}
