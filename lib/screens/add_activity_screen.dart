//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:minimal_time_tracker/helpers/convert.dart';
import 'package:minimal_time_tracker/widgets/duration_bottom_sheet.dart';
import 'package:minimal_time_tracker/settings/themes.dart';
import '../data/activity_bloc/activity_bloc.dart';
import '../settings/settings_bloc/settings_bloc.dart';
import 'package:minimal_time_tracker/widgets/spacer_box.dart';

TextEditingController cellsNumber = TextEditingController();
TextEditingController titleController = TextEditingController();
TextEditingController subtitleController = TextEditingController();

class AddActivityScreen extends StatelessWidget {
  AddActivityScreen({Key? key}) : super(key: key) {
    editedActivity = null;
    titleController.clear();
    subtitleController.clear();
  }

  AddActivityScreen.editActivity({Key? key, required this.editedActivity})
      : super(key: key);

  String _numOfCells = '0';
  String _titleOfEditedActivity = '';
  String _subtitleOfEditedActivity = '';

  Activity? editedActivity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
      return BlocBuilder<ActivitiesBloc, ActivitiesState>(
          builder: (context, state) {
        if (state is NormalActivitiesState) {
          Map<Duration, bool> durations = state.durationButtons;

          bool presentationValue;

          if (state.presentation == Presentation.BUTTONS) {
            presentationValue = true;
          } else {
            presentationValue = false;
          }

          if (editedActivity != null) {
            //заголовок у активности есть всегда
            _titleOfEditedActivity = editedActivity!.title;
            titleController.text = _titleOfEditedActivity;

            //подзаголовка может не быть
            _subtitleOfEditedActivity = (editedActivity!.subtitle == null)
                ? ''
                : editedActivity!.subtitle!;
            subtitleController.text = _subtitleOfEditedActivity;
          }

          _numOfCells = state.numOfCells.toString();

          int themeMode = settingsState.themeMode ? 1 : 0;

          bool noColorPicker = (settingsState.theme == 'Pale');

          return Scaffold(
            backgroundColor: themePalettes[settingsState.theme]![themeMode][0]
                [state.color],
            appBar: AppBar(
              title: (editedActivity == null)
                  ? Text(AppLocalizations.of(context)!.addNewActivity)
                  : Text(AppLocalizations.of(context)!.editActivity),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        key: Key('noTitleSnackBar'),
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
                        title: titleController.text,
                        subtitle: subtitleController.text,
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
                          Duration currentDuration =
                              durations.keys.toList().first;
                          for (int i = 0; i < currentNum; i++) {
                            activity.addDurationButton(currentDuration);
                          }
                        }
                      }

                      //в случае редактирования существующей активности
                      //заполняются недостающие поля
                      if (editedActivity != null) {
                        for (var interval
                            in state.editedActivity!.intervalsList) {
                          activity.addInterval(interval);
                        }
                        //activity.durationButtons =
                        //    editedActivity!.durationButtons;
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
                        controller: titleController,
                        onChanged: (value) => _titleOfEditedActivity = value,
                      ),
                      const SpacerBox(),
                      Text(AppLocalizations.of(context)!.subtitleActivity),
                      TextField(
                        controller: subtitleController,
                        onChanged: (value) => _subtitleOfEditedActivity = value,
                      ),
                      const SpacerBox(),
                      noColorPicker ? Container() : Text(AppLocalizations.of(context)!.color),
                      noColorPicker ? Container() : _colorPicker(context, state.color, settingsState.theme!, themeMode),
                      noColorPicker ? Container() : const SpacerBox(),
                      Text(AppLocalizations.of(context)!.addNewIntervals),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          Text(AppLocalizations.of(context)!
                              .presentationIntervals),
                        ],
                      ),
                      const SpacerBox(),
                      //виджет для настройки того как будет добавляться время к активности
                      //с помощью кнопок либо таблицы
                      (state.presentation == Presentation.BUTTONS)
                          ? _buttonSettings(context, durations)
                          : _tableSettings(context, durations),
                      const SpacerBox(),
                      //если эта страница открыта для редактирования существующей активности
                      //ниже выводится виджет для редактирования запомненных интервалов
                      (editedActivity == null)
                          ? Container()
                          : _editActivityData(context, state.color,
                              settingsState.theme!, themeMode, state.editedActivity!),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Text(AppLocalizations.of(context)!.somethingWrong);
      });
    });
  }

  Widget _editActivityData(BuildContext context, int colorIndex, String theme, int themeMode,
      Activity editedActivity) {
    List<Color> paletteDark = themePalettes[theme]![themeMode][1];

    return Column(
      key: Key('editActivityData'),
      children: [
        Text(AppLocalizations.of(context)!.addedIntervals),
        Container(
          height: 250,
          decoration: BoxDecoration(
              border: Border.all(
            color: paletteDark[colorIndex],
          )),
          child: ListView.builder(
              itemCount: editedActivity.intervalsList.length,
              itemBuilder: (context, int index) {
                return Card(
                  key: Key('editActivityDataCard'),
                  child: ListTile(
                    //substring отсекает миллисекунды
                    title: Text(
                        '${editedActivity.intervalsList[index].start.toString().substring(0, 19)}, '
                        '${stringDuration(editedActivity.intervalsList[index].duration, context)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        BlocProvider.of<ActivitiesBloc>(context)
                            .add(DeleteIntervalEditedActivity(index: index));
                      },
                    ),
                  ),
                );
              }),
        ),
        Text(
            '${AppLocalizations.of(context)!.totalCap}: ${stringDuration(editedActivity.totalTime(), context)}'),
        OutlinedButton(
            key: Key('editActivityDataButton'),
            onPressed: () {
              BlocProvider.of<ActivitiesBloc>(context)
                  .add(DeleteAllIntervalsEditedActivity());
            },
            child: Text(AppLocalizations.of(context)!.deleteAllIntervals)),
      ],
    );
  }

  Widget _colorPicker(BuildContext context, int colorIndex, String theme, int themeMode) {
    List<Color> palette = themePalettes[theme]![themeMode][0];
    List<Color> paletteDark = themePalettes[theme]![themeMode][1];

    return Wrap(spacing: 5, runSpacing: 2.5, children: [
      for (int i = 0; i < palette.length; i++)
        InkWell(
          child: Container(
            width: 30,
            height: 30,
            decoration: (i == colorIndex)
                ? BoxDecoration(
                    color: palette[i],
                    border: Border.all(
                      color: paletteDark[i],
                      width: 3.0,
                    ))
                : BoxDecoration(
                    color: palette[i],
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
      key: Key('_buttonSettings'),
      children: [
        Text(AppLocalizations.of(context)!.addButtons),
        Wrap(
          spacing: 5,
          runSpacing: 2.5,
          children: [
            for (MapEntry<Duration, bool> d in durations.entries)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: d.value ? Colors.black12 : Colors.white12,
                ),
                child: Text(stringDuration(d.key, context)),
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context)
                      .add(PressedDurationButton(duration: d.key));
                },
              ),
            OutlinedButton(
              key: Key('buttonsShowModalBottomSheet'),
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
      key: Key('_tableSettings'),
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
          key: Key('tableShowModalBottomSheet'),
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
