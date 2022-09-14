import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/helpers/convert.dart';

class AddActivityScreen extends StatelessWidget {
  AddActivityScreen({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  Set<Duration> _durationButtons = Set<Duration>();
  List<Duration> _durations = [
    Duration(hours: 1),
    Duration(minutes: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addNewActivity),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Activity _activity = Activity(
                title: _titleController.text,
                subtitle: _subtitleController.text,
              );

              for (var d in _durationButtons) _activity.addDurationButton(d);

              Navigator.pop(
                context,
                _activity,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.titleActivity),
              TextField(
                controller: _titleController,
              ),
              Text(AppLocalizations.of(context)!.subtitleActivity),
              TextField(
                controller: _subtitleController,
              ),
              //add choise - buttons or table
              Text(AppLocalizations.of(context)!.addButtons),
              Row(
                children: [
                  for (var d in _durations)
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: OutlinedButton(
                        child: Text(stringDuration(d, context)),
                        onPressed: () {
                          _durationButtons.add(d);
                        },
                      ),
                    ),
                ],
              ),
              //colorpicker
            ],
          ),
        ),
      ),
    );
  }
}
