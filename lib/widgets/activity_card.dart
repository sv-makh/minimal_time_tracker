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
  final bool archived;

  const ActivityCard({
    Key? key,
    required this.activity,
    required this.activityIndex,
    required this.archived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, SettingsState settingsState) {
        List<Color> palette = themePalettes[settingsState.theme]![0];
        List<Color> paletteDark = themePalettes[settingsState.theme]![1];
        List<Color> paletteInactive = themePalettes[settingsState.theme]![2];

        //цвет фона карточки активности берётся из разных палитр
        //в зависимости от того, находится ли эта активность в архиве
        Color _cardColor(bool activityArchived) {
          if (activityArchived) {
            return paletteInactive[activity.color ?? 0];
          } else {
            return palette[activity.color ?? 0];
          }
        }

        return Card(
          color: _cardColor(archived),
          child: Column(children: [
            ListTile(
                title: Text(
                  key: Key('title of activity'),
                  '${activity.title}, ${AppLocalizations.of(context)!.total} = '
                  '${stringDuration(activity.totalTime(), context)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: (activity.subtitle != null)
                    ? Text(
                        key: Key('subtitle of activity'),
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
                    archived
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              _editActivity(context);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                    archived
                        ? IconButton(
                            onPressed: () {
                              _unarchiveActivity(context);
                            },
                            icon: const Icon(Icons.unarchive),
                          )
                        : IconButton(
                            onPressed: () {
                              _archiveActivity(context);
                            },
                            icon: const Icon(Icons.archive),
                          ),
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

  void _unarchiveActivity(BuildContext context) {
    BlocProvider.of<ActivitiesBloc>(context)
        .add(ActivityUnarchived(index: activityIndex));
  }

  Future<void> _archiveActivity(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.moveToArchive),
          content: Text(AppLocalizations.of(context)!.archiveWarning),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel)),
            TextButton(
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context)
                      .add(ActivityArchived(index: activityIndex));
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.archive)),
          ],
        );
      },
    );
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
            key: Key('rowOfButtons'),
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
                      onPressed: !archived
                          ? () {
                              BlocProvider.of<ActivitiesBloc>(context)
                                  .add(ActivityAddedTime(
                                index: activityIndex,
                                interval: TimeInterval.duration(
                                    end: DateTime.now(), duration: d),
                              ));
                            }
                          : null,
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
    bool _isInactive(int index) {
      if (index != activity.intervalsList.length) return true;
      return false;
    }

    //проверка была ли нажата кнопка
    //(т.е. в intervalsList был занес>н интервал)
    bool _wasPressed(int index) {
      if (index < activity.intervalsList.length) return true;
      return false;
    }

    //количество ненажатых кнопок в таблице
    int _numOfLeftCells() {
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
            key: Key('tableOfButtons'),
            children: [
              Text('${AppLocalizations.of(context)!.checkedCells} '
                  '${activity.intervalsList.length}'),
              Text('${AppLocalizations.of(context)!.totalCap}: '
                  '${activity.maxNum}'),
              Wrap(
                spacing: 5,
                runSpacing: 2.5,
                children: [
                  for (int i = 0; i < activity.durationButtons.length; i++)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _wasPressed(i)
                            ? paletteDark[activity.color!]
                            : palette[activity.color!],
                        side: _isInactive(i) || archived
                            ? null
                            : BorderSide(
                                color: paletteDark[activity.color!],
                                width: 3.0),
                      ),
                      onPressed: _isInactive(i) || archived
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
                      onLongPress: _wasPressed(i) && !archived
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
                      child: _isInactive(i)
                          ? const Text('')
                          : Text('+ ${stringDuration(activity.durationButtons[0], context)}'),
                    )
                ],
              ),
            ],
          );
  }
}
