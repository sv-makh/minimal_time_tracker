//import 'dart:html';

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

TextEditingController cellsNumber = TextEditingController();

class AddActivityScreen extends StatelessWidget {
  AddActivityScreen({Key? key}) : super(key: key) {
    editedActivity = null;
  }

  AddActivityScreen.editActivity({Key? key, required this.editedActivity})
      : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  String _numOfCells = '0';

  int palette = 0;

  Activity? editedActivity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, ActivitiesState state) {
      Map<Duration, bool> durations = state.durationButtons;

      bool presentationValue;

      if (state.presentation == Presentation.BUTTONS) {
        presentationValue = true;
      } else {
        presentationValue = false;
      }

      _numOfCells = state.numOfCells.toString();

      return Scaffold(
        backgroundColor: palettes[palette][state.color],
        appBar: AppBar(
          title: (editedActivity == null)
              ? Text(AppLocalizations.of(context)!.addNewActivity)
              : Text(AppLocalizations.of(context)!.editActivity),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
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
                  Activity activity = Activity(
                    title: _titleController.text,
                    subtitle: _subtitleController.text,
                    color: state.color,
                    presentation: state.presentation,
                  );

                  if (state.presentation == Presentation.BUTTONS) {
                    for (MapEntry<Duration, bool> d in durations.entries) {
                      if (d.value) activity.addDurationButton(d.key);
                    }
                  } else {
                    int currentNum = int.tryParse(_numOfCells) ?? 0;
                    activity.maxNum = currentNum;
                    if (currentNum != 0) {
                      Duration currentDuration = durations.keys.toList().first;
                      for (int i = 0; i < currentNum; i++) {
                        activity.addDurationButton(currentDuration);
                      }
                    }
                  }

                  durations.clear();

                  Navigator.pop(
                    context,
                    activity,
                  );
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
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
                  _colorPicker(context, state.color),
                  Text(AppLocalizations.of(context)!.addNewIntervals),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.presentaionTable),
                      Switch(
                          value: presentationValue,
                          onChanged: (bool value) {
                            Presentation p = value
                                ? Presentation.BUTTONS
                                : Presentation.TABLE;
                            BlocProvider.of<ActivitiesBloc>(context)
                                .add(ChangePresentation(presentation: p));
                          }),
                      Text(AppLocalizations.of(context)!.presentationIntervals),
                    ],
                  ),
                  //виджет для настройки того как будет добавляться время к активности
                  //с помощью кнопок либо таблицы
                  (state.presentation == Presentation.BUTTONS)
                      ? _buttonSettings(context, durations)
                      : _tableSettings(context, durations),
                  //если эта страница открыта для редактирования существующей активности
                  //ниже выводится виджет для редактирования запомненных интервалов
                  (editedActivity == null) ? Container() : _editActivityData(context),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _editActivityData(BuildContext context) {
    return Column(
      children: [
        Text(editedActivity!.title),
      ],
    );
  }

  Widget _colorPicker(BuildContext context, int colorIndex) {
    return Wrap(spacing: 5, runSpacing: 2.5, children: [
      for (int i = 0; i < palettes[palette].length; i++)
        InkWell(
          child: Container(
            width: 30,
            height: 30,
            decoration: (i == colorIndex)
                ? BoxDecoration(
                    color: palettes[palette][i],
                    border: Border.all(
                      color: palettesDark[palette][i],
                      width: 3.0,
                    ))
                : BoxDecoration(
                    color: palettes[palette][i],
                  ),
          ),
          onTap: () {
            BlocProvider.of<ActivitiesBloc>(context).add(ChangeColor(color: i));
          },
        ),
    ]);
  }

  Widget _buttonSettings(BuildContext context, Map<Duration, bool> durations) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.addButtons),
        Wrap(
          spacing: 5,
          runSpacing: 2.5,
          children: [
            for (MapEntry<Duration, bool> d in durations.entries)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: d.value ? Colors.black12 : Colors.white,
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
                ).then((value) {
                  if (value.inSeconds != 0) {
                    BlocProvider.of<ActivitiesBloc>(context)
                        .add(AddedDurationButton(duration: value));
                  }
                });
              },
              child: Text('+'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableSettings(BuildContext context, Map<Duration, bool> durations) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.numberOfCellsInTable),
        TextField(
          //установка курсора в конец поля
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: _numOfCells,
              selection: TextSelection.collapsed(offset: _numOfCells.length),
            ),
          ),
          onChanged: (value) {
            _numOfCells = value;
            BlocProvider.of<ActivitiesBloc>(context)
                .add(ChangeNumOfCells(num: int.tryParse(value) ?? 0));
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        ),
        Text(AppLocalizations.of(context)!.timeOfCell),
        OutlinedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => DurationBottomSheet(
                context: context,
              ),
            ).then((value) {
              if (value.inSeconds != 0) {
                BlocProvider.of<ActivitiesBloc>(context)
                    .add(AddedDurationForTable(duration: value));
              }
            });
          },
          child: (durations.isEmpty)
              ? Text('+')
              : Text(stringDuration(durations.keys.toList().first, context)),
        ),
      ],
    );
  }
}
