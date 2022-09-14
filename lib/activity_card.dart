import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/activity_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/helpers/convert.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final int activityIndex;

  const ActivityCard({Key? key, required this.activity, required this.activityIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, ActivitiesState state) {
        return Card(
          child: Column(children: [
            ListTile(
              title: Text(
                  '${activity.title}, ${AppLocalizations.of(context)!.total} = ${stringDuration(activity.totalTime(), context)}'),
              subtitle: (activity.subtitle != null)
                  ? Text(activity.subtitle!)
                  : Container(),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context).add(
                      ActivityDeleted(index: activityIndex));
                },
              ),
            ),
            (activity.durationButtons == null)
                ? Container()
                : _rowOfButtons(context)
          ]),
        );
      },
    );
  }

  Widget _rowOfButtons(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var d in activity.durationButtons)
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: OutlinedButton(
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context).add(
                      ActivityAddedTime(
                          index: activityIndex,
                          interval: TimeInterval.duration(
                              end: DateTime.now(), duration: d)));
                },
                child: Text('+ ' + stringDuration(d, context)),
              ),
            )
        ],
      ),
    );
  }

}
