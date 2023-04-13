import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

import 'package:minimal_time_tracker/data/activity.dart';

part 'main_view_event.dart';

part 'main_view_state.dart';

class MainViewBloc extends Bloc<MainViewEvent, MainViewState> {
  String boxName;
  String archiveName;

  MainViewBloc({required this.boxName, required this.archiveName})
      : super(NormalMainViewState()) {

    Box<Activity> activitiesBox = Hive.box<Activity>(boxName);
    Box<Activity> archiveBox = Hive.box<Activity>(archiveName);


  }
}
