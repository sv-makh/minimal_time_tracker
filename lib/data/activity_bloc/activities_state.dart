part of 'activity_bloc.dart';

//без наследования от Equatable и без переопределения == и hashCode
//чтобы блок ребилдил виджеты для каждого состояния
//https://bloclibrary.dev/#/faqs?id=when-to-use-equatable

abstract class ActivitiesState {
  ActivitiesState();
}

class NormalActivitiesState extends ActivitiesState {
  //кнопки добавления времени (ключ время Duration) к активности
  //значение bool: на экране редактирования/создания активности они могут быть
  //выбраны либо не выбраны (от этого зависит их цвет)
  Map<Duration, bool> durationButtons;
  //цвет карточки активности - индекс цвета из массивов цветов для темы
  int color;
  //варианты добавления времени к активности: кнопочное/табличное
  Presentation presentation;
  //количество ячеек в случает табличного представления
  int numOfCells;
  //добавленные пользователем интервалы времени у редактируемой активности
  List<int> intervals;
  //редактиремая активность, в случае создания новой - null
  Activity? editedActivity;

  NormalActivitiesState(this.durationButtons,
      this.color, this.presentation, this.numOfCells, this.intervals,
      [this.editedActivity]);
}

class ActivitiesError extends ActivitiesState {
}