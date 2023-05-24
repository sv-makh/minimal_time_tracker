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

class AddActivityScreen extends StatefulWidget {
  //экран открывается для создания активности
  AddActivityScreen({Key? key}) : super(key: key) {
    editedActivity = null;
  }

  //экран открывается для редактирования существующей активности
  AddActivityScreen.editActivity({Key? key, required this.editedActivity})
      : super(key: key);

  Activity? editedActivity;

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  //заголовок активности
  String titleOfEditedActivity = '';
  //подзаголовок активности
  String subtitleOfEditedActivity = '';
  //количество ячеек таблицы в случае табличного представления
  String numOfCells = '0';

  @override
  void initState() {
    Activity? editedActivity = widget.editedActivity;
    super.initState();
    if (editedActivity != null) {
      //заголовок у активности есть всегда
      titleOfEditedActivity = editedActivity!.title;
      titleController.text = titleOfEditedActivity;

      //подзаголовка может не быть
      subtitleOfEditedActivity =
          (editedActivity!.subtitle == null) ? '' : editedActivity!.subtitle!;
      subtitleController.text = subtitleOfEditedActivity;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Activity? editedActivity = widget.editedActivity;

    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
      return BlocBuilder<ActivitiesBloc, ActivitiesState>(
          builder: (context, state) {
        if (state is NormalActivitiesState) {
          //кнопки для добавления времени к активности
          //значение bool в map - выбраны ли эти кнопки
          Map<Duration, bool> durations = state.durationButtons;

          //табличное/кнопочное добавление времени
          bool presentationValue;

          if (state.presentation == Presentation.BUTTONS) {
            presentationValue = true;
          } else {
            presentationValue = false;
          }

          //тёмный/светлый вариант темы
          int themeMode = settingsState.themeMode ? 1 : 0;

          //количество ячеек таблицы
          numOfCells = state.numOfCells.toString();

          //в теме Pale нет выбора цвета для карточки активности
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
                    _savingActivity(state, durations, editedActivity);
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
                        key: Key('title text field'),
                        controller: titleController,
                        onChanged: (value) => titleOfEditedActivity = value,
                      ),
                      const SpacerBox(),
                      Text(AppLocalizations.of(context)!.subtitleActivity),
                      TextField(
                        key: Key('subtitle text field'),
                        controller: subtitleController,
                        onChanged: (value) => subtitleOfEditedActivity = value,
                      ),
                      const SpacerBox(),
                      noColorPicker
                          ? Container()
                          : Text(AppLocalizations.of(context)!.color),
                      noColorPicker
                          ? Container()
                          : _colorPicker(context, state.color,
                              settingsState.theme!, themeMode),
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
                          : _editActivityData(
                              context,
                              state.color,
                              settingsState.theme!,
                              themeMode,
                              state.intervals,
                              state.editedActivity!),
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

  //метод с логикой сохранения активности после внесённых пользователем изменений
  void _savingActivity(NormalActivitiesState state,
      Map<Duration, bool> durations, Activity? editedActivity) {
    //название обязательно должно быть; если его нет сохранения не происходит,
    //выводится сообщение пользователю
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: Key('noTitleSnackBar'),
        content: Text(AppLocalizations.of(context)!.enterTitle),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.black,
          onPressed: () {},
        ),
      ));
    } else {
      //заполняются поля активности для сохранения
      Activity activity = Activity(
        title: titleController.text,
        subtitle: subtitleController.text,
        color: state.color,
        presentation: state.presentation,
      );

      //заполняется поле со списком кнопок добавления времени
      if (state.presentation == Presentation.BUTTONS) {
        for (MapEntry<Duration, bool> d in durations.entries) {
          if (d.value) activity.addDurationButton(d.key);
        }
      } else {
        int currentNum = int.tryParse(numOfCells) ?? 0;
        //в случае табличного отображения, заполняется поле с количеством ячеек таблицы
        activity.maxNum = currentNum;
        if (currentNum != 0) {
          Duration currentDuration = durations.keys.toList().first;
          for (int i = 0; i < currentNum; i++) {
            activity.addDurationButton(currentDuration);
          }
        }
      }

      //в случае редактирования существующей активности
      //заполняется оставшееся поле - список отмеченных интервалов
      if (editedActivity != null) {
        int length = state.intervals.length;
        for (int i = 0; i < length; i++) {
          int intervalIndex = state.intervals[i];
          TimeInterval interval =
              state.editedActivity!.intervalsList[intervalIndex];
          activity.addInterval(interval);
        }
      }

      durations.clear();

      Navigator.pop(
        context,
        activity,
      );
    }
  }

  //контейнер с рамкой, в котором находится добавленные интервалы
  //редактируемой активности;
  //и под контейнером кнопка для удаления всех интервлов
  Widget _editActivityData(BuildContext context, int colorIndex, String theme,
      int themeMode, List<int> intervals, Activity editedActivity) {
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
              itemCount: intervals.length,
              itemBuilder: (context, int index) {
                //индекс интервала в списке интервалов редактируемой активности
                //(editedActivity.intervalsList)
                int intervalIndex = intervals[index];
                return Card(
                  key: Key('editActivityDataCard'),
                  child: ListTile(
                    //substring отсекает миллисекунды
                    title: Text(
                        '${editedActivity.intervalsList[intervalIndex].start.toString().substring(0, 19)}, '
                        '${stringDuration(editedActivity.intervalsList[intervalIndex].duration, context)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        BlocProvider.of<ActivitiesBloc>(context)
                            .add(DeleteIntervalScreen(index: index));
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
                  .add(DeleteAllIntervalsScreen());
            },
            child: Text(AppLocalizations.of(context)!.deleteAllIntervals)),
      ],
    );
  }

  //строка (Wrap) кнопок для выбора цвета карточки с активностью
  //выбор - из цветов конкретного варианта (themeMode - светлый/тёмный) темы theme
  //colorIndex - выбранный в данный момент цвет, при создании новой активности
  //по умолчанию colorIndex = 0
  Widget _colorPicker(
      BuildContext context, int colorIndex, String theme, int themeMode) {
    List<Color> palette = themePalettes[theme]![themeMode][0];
    List<Color> paletteDark = themePalettes[theme]![themeMode][1];

    return Wrap(spacing: 5, runSpacing: 2.5, children: [
      for (int i = 0; i < palette.length; i++)
        InkWell(
          child: Container(
            width: 30,
            height: 30,
            //выбранный цвет выделяется рамкой
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

  //настройки кнопок добавления времени к активности
  Widget _buttonSettings(BuildContext context, Map<Duration, bool> durations) {
    return Column(
      key: Key('_buttonSettings'),
      children: [
        Text(AppLocalizations.of(context)!.addButtons),
        Wrap(
          spacing: 5,
          runSpacing: 2.5,
          children: [
            //уже добавленные кнопки, по умолчанию 1 ч и 30 м
            for (MapEntry<Duration, bool> d in durations.entries)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: d.value ? Colors.black12 : Colors.white12,
                ),
                child: Text(stringDuration(d.key, context)),
                //выбор/отключение кнопки производится надатием на неё, при этом
                //она меняет цвет: нажатый Colors.black12 и ненажатый Colors.white12
                onPressed: () {
                  BlocProvider.of<ActivitiesBloc>(context)
                      .add(PressedDurationButton(duration: d.key));
                },
              ),
            //вызов BottomSheet для выбора времени для кнопки
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

  //настройки табличного добавления времени к активности
  Widget _tableSettings(BuildContext context, Map<Duration, bool> durations) {
    return Column(
      key: Key('_tableSettings'),
      children: [
        Text(AppLocalizations.of(context)!.numberOfCellsInTable),
        //количество ячеек в таблице
        Container(
          width: 50,
          child: TextField(
            textAlign: TextAlign.center,
            //установка курсора в конец поля
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: numOfCells,
                selection: TextSelection.collapsed(offset: numOfCells.length),
              ),
            ),
            onChanged: (value) {
              numOfCells = value;
              BlocProvider.of<ActivitiesBloc>(context)
                  .add(ChangeNumOfCells(num: int.tryParse(value) ?? 0));
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
          ),
        ),
        Text(AppLocalizations.of(context)!.timeOfCell),
        //выбор времени, которому соответствует одна ячейка
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
