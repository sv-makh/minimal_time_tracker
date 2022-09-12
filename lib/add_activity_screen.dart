import 'package:flutter/material.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddActivityScreen extends StatelessWidget {
  AddActivityScreen({Key? key}) : super(key: key);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addNewActivity),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.pop(
                context,
                Activity(
                  title: _titleController.text,
                  subtitle: _subtitleController.text,
                ),
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
              Text('${AppLocalizations.of(context)!.titleActivity}'),
              TextField(
                controller: _titleController,
              ),
              Text('${AppLocalizations.of(context)!.subtitleActivity}'),
              TextField(
                controller: _subtitleController,
              ),
              //adding buttons with duration
              //colorpicker
            ],
          ),
        ),
      ),
    );
  }
}
