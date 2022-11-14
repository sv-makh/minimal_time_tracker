import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:minimal_time_tracker/screens/add_activity_screen.dart';
import 'package:minimal_time_tracker/screens/settings_screen.dart';
import 'package:minimal_time_tracker/widgets/activity_card.dart';
import 'package:minimal_time_tracker/data/activity_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';

class MainActivitiesView extends StatelessWidget {
  const MainActivitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Activity> activitiesBox = Hive.box<Activity>(boxName);

    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, ActivitiesState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.title),
            actions: [
              IconButton(
                onPressed: () {
                  _goToSettings(context);
                },
                icon: const Icon(Icons.settings),
              )
            ],
          ),
          body: activitiesBox.values.isEmpty
              ? SafeArea(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.noActivities),
                  ),
                )
              : SafeArea(
                  child: ListView.builder(
                    itemCount: state.activitiesBox.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ActivityCard(
                        activity: state.activitiesBox.getAt(index)!,
                        activityIndex: index,
                      );
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _addActivity(context);
            },
          ),
        );
      },
    );
  }

  void _goToSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  Future<void> _addActivity(BuildContext context) async {
    BlocProvider.of<ActivitiesBloc>(context).add(PressedNewActivity());

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddActivityScreen()),
    ).then((value) => BlocProvider.of<ActivitiesBloc>(context)
        .add(ActivityAdded(activity: value)));
  }
}
