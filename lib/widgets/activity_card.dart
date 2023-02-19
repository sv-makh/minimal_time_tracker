import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_bloc.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/helpers/convert.dart';
import 'package:minimal_time_tracker/settings/themes.dart';
import 'package:minimal_time_tracker/screens/add_activity_screen.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final int activityIndex;

  const ActivityCard({
    Key? key,
    required this.activity,
    required this.activityIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, SettingsState settingsState) {
      List<Color> palette = themePalettes[settingsState.theme]![0];
      List<Color> paletteDark = themePalettes[settingsState.theme]![1];

      return BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, ActivitiesState state) {
          return Card(
            color: palette[activity.color ?? 0],
            child: Column(children: [
              ListTile(
                  title: Text(
                    '${activity.title}, ${AppLocalizations.of(context)!.total} = '
                    '${stringDuration(activity.totalTime(), context)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: (activity.subtitle != null)
                      ? Text(
                          activity.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      : Container(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteDialog(context);
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          _editActivity(context);
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  )),
              //добавление времени к активности происходит в виджетах
              //в зависимости от того, какое представление для этой активности
              //выбрано
              (activity.presentation == Presentation.BUTTONS)
                  ? _rowOfButtons(context)
                  : _table(context, settingsState.theme!)
            ]),
          );
        },
      );
    });
  }

  Future<void> _editActivity(BuildContext context) async {
    BlocProvider.of<ActivitiesBloc>(context)
        .add(EditActivity(activity: activity));

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityScreen.editActivity(
          editedActivity: activity,
        ),
      ),
    ).then((value) => BlocProvider.of<ActivitiesBloc>(context)
        .add(SaveEditedActivity(activity: value, index: activityIndex)));
  }

  Future<void> _deleteDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteActivity),
            content: Text(AppLocalizations.of(context)!.deleteWarning),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancel)),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<ActivitiesBloc>(context)
                        .add(ActivityDeleted(index: activityIndex));
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.delete)),
            ],
          );
        });
  }

  Widget _rowOfButtons(BuildContext context) {
    return (activity.durationButtons.isEmpty)
        ? Container()
        : Column(
            children: [
              Text(
                '${AppLocalizations.of(context)!.addedIntervals} ${activity.intervalsList.length}',
              ),
              Wrap(
                spacing: 5,
                runSpacing: 2.5,
                children: [
                  for (var d in activity.durationButtons)
                    OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<ActivitiesBloc>(context)
                            .add(ActivityAddedTime(
                          index: activityIndex,
                          interval: TimeInterval.duration(
                              end: DateTime.now(), duration: d),
                        ));
                      },
                      child: Text('+ ${stringDuration(d, context)}'),
                    )
                ],
              ),
            ],
          );
  }

  Widget _table(BuildContext context, String theme) {
    //кнопку в таблице можно нажать, только если это первая кнопка после всех нажатых,
    //(т.е. после всего списка intervalsList )
    bool isInactive(int index) {
      if (index != activity.intervalsList.length) return true;
      return false;
    }

    //проверка была ли нажата кнопка
    //(т.е. в intervalsList был занес>н интервал)
    bool wasPressed(int index) {
      if (index < activity.intervalsList.length) return true;
      return false;
    }

    //количество ненажатых кнопок в таблице
    int numOfLeftCells() {
      int num = activity.maxNum! - activity.intervalsList.length;
      if (num >= 0) {
        return num;
      } else {
        return 0;
      }
    }

    List<Color> palette = themePalettes[theme]![0];
    List<Color> paletteDark = themePalettes[theme]![1];

    return (activity.durationButtons.isEmpty)
        ? Container()
        : Column(
            children: [
              Text('${AppLocalizations.of(context)!.timeOfCell}: '
                  '${stringDuration(activity.durationButtons.first, context)}'),
              Text('${AppLocalizations.of(context)!.checkedCells} '
                  '${activity.intervalsList.length}'),
              Text('${AppLocalizations.of(context)!.leftCells} '
                  '${numOfLeftCells()}'),
              Wrap(
                spacing: 5,
                runSpacing: 2.5,
                children: [
                  for (int i = 0; i < activity.durationButtons.length; i++)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: wasPressed(i)
                            ? paletteDark[activity.color!]
                            : palette[activity.color!],
                        side: isInactive(i)
                            ? null
                            : BorderSide(
                                color: paletteDark[activity.color!],
                                width: 3.0),
                      ),
                      onPressed: isInactive(i)
                          ? null
                          : () {
                              BlocProvider.of<ActivitiesBloc>(context)
                                  .add(ActivityAddedTime(
                                index: activityIndex,
                                interval: TimeInterval.duration(
                                    end: DateTime.now(),
                                    duration: activity.durationButtons[i]),
                              ));
                            },
                      onLongPress: wasPressed(i)
                          ? () {
                              //здесь индекс i кнопки из durationButtons можно использовать
                              //как индекс интервала из intervalsList, т.к.
                              //условие _wasPressed(i) обеспечивает выполнение
                              //i < длины intervalsList
                              BlocProvider.of<ActivitiesBloc>(context).add(
                                  DeleteIntervalWithIndex(
                                      activityIndex: activityIndex,
                                      intervalIndex: i));
                            }
                          : null,
                      child: const Text(''),
                    )
                ],
              ),
            ],
          );
  }
}
