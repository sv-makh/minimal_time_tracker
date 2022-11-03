import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/activity_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/helpers/convert.dart';
import 'package:minimal_time_tracker/themes/color_palettes.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final int activityIndex;

  const ActivityCard(
      {Key? key, required this.activity, required this.activityIndex})
      : super(key: key);

  final int palette = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, ActivitiesState state) {
        return Card(
          color: palettes[palette][activity.color ?? 0],
          child: Column(children: [
            ListTile(
              title: Text(
                  '${activity.title}, ${AppLocalizations.of(context)!.total} = '
                  '${stringDuration(activity.totalTime(), context)}'),
              subtitle: (activity.subtitle != null)
                  ? Text(activity.subtitle!)
                  : Container(),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context)
                      .add(ActivityDeleted(index: activityIndex));
                },
              ),
            ),
            //добавление времени к активности происходит в виджетах
            //в зависимости от того, какое представление для этой активности
            //выбрано
            (activity.presentation == Presentation.BUTTONS)
                ? _rowOfButtons(context)
                : _table(context)
          ]),
        );
      },
    );
  }

  Widget _rowOfButtons(BuildContext context) {
    return (activity.durationButtons.isEmpty)
        ? Container()
        : Wrap(
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
          );
  }

  Widget _table(BuildContext context) {
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
                            ? palettesDark[palette][activity.color!]
                            : palettes[palette][activity.color!],
                        side: isInactive(i)
                            ? null
                            : BorderSide(
                                color: palettesDark[palette][activity.color!],
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
