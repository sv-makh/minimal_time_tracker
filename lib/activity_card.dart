import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          title: Text('${activity.title}, total = ${activity.totalTime()}'),
          subtitle: (activity.subtitle != null)
              ? Text(activity.subtitle!)
              : Container(),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ),
        (activity.durationButtons == null)
            ? Container()
            : _rowOfButtons()
      ]),
    );
  }
}

class _rowOfButtons extends StatelessWidget {
  const _rowOfButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
