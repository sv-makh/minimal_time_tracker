import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/helpers/convert.dart';
import 'package:minimal_time_tracker/duration_bottom_sheet.dart';
import 'package:minimal_time_tracker/themes/color_palettes.dart';

import 'activity_bloc.dart';

class AddActivityScreen extends StatelessWidget {
  AddActivityScreen({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  int palette = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, ActivitiesState state) {
      Map<Duration, bool> _durations = state.durationButtons;
      return Scaffold(
        backgroundColor: palettes[palette][state.color],
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addNewActivity),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!.enterTitle),
                    duration: const Duration(seconds: 3),
                    //backgroundColor: messageColor,
                    action: SnackBarAction(
                      label: 'Ok',
                      textColor: Colors.black,
                      onPressed: () {},
                    ),
                  ));
                } else {
                  Activity _activity = Activity(
                    title: _titleController.text,
                    subtitle: _subtitleController.text,
                    color: state.color,//colorForCard,
                  );

                  for (MapEntry<Duration, bool> d in _durations.entries) {
                    if (d.value) _activity.addDurationButton(d.key);
                  }

                  _durations.clear();

                  Navigator.pop(
                    context,
                    _activity,
                  );
                }
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
                Text(AppLocalizations.of(context)!.color),

                Wrap(
                  spacing: 5,
                  runSpacing: 2.5,
                  children: [
                    for (int i = 0; i < palettes[palette].length; i++)
                      InkWell(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: (i == state.color)
                              ? BoxDecoration(
                                  color: palettes[palette][i],
                                  border: Border.all(
                                    color: palettesDark[palette][i],
                                    width: 3,
                                  ))
                              : BoxDecoration(
                                  color: palettes[palette][i],
                                ),
                        ),
                        onTap: () {
                          BlocProvider.of<ActivitiesBloc>(context)
                              .add(ChangeColor(color: i));
                        },
                      ),
                  ],
                ),

                //add choice - buttons or table
                Text(AppLocalizations.of(context)!.addButtons),

                Wrap(
                  spacing: 5,
                  runSpacing: 2.5,
                  children: [
                    for (MapEntry<Duration, bool> d in _durations.entries)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              d.value ? Colors.black12 : Colors.white,
                        ),
                        child: Text(stringDuration(d.key, context)),
                        onPressed: () {
                          BlocProvider.of<ActivitiesBloc>(context)
                              .add(PressedDurationButton(duration: d.key));
                        },
                      ),
                    OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => DurationBottomSheet(
                            context: context,
                          ),
                        ).then((value) => null);
                      },
                      child: Text('+'),
                    ),
                  ],
                ),
                //colorpicker
              ],
            ),
          ),
        ),
      );
    });
  }
}
