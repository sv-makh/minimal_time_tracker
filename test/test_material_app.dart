import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/bloc/activity_bloc.dart';
import 'package:minimal_time_tracker/settings/bloc/settings_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//вспомогательная обёртка для тестируемых виджетов

class MockActivitiesBloc extends MockBloc<ActivityEvent, ActivitiesState> implements ActivitiesBloc {}

class TestMaterialApp extends StatelessWidget {
  final Widget child;
  //final String boxName;
  //final String archiveName;
  final SettingsBloc settingsBloc;
  final ActivitiesBloc? activitiesBloc;

  const TestMaterialApp({
    Key? key,
    required this.child,
    //required this.boxName,
    //required this.archiveName,
    required this.settingsBloc,
    ActivitiesBloc? this.activitiesBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', '')],
      home: MultiBlocProvider(
        providers: [
          if (activitiesBloc != null) BlocProvider.value(value: activitiesBloc!)
          else BlocProvider<ActivitiesBloc>(
              create: (_) => MockActivitiesBloc()),
          BlocProvider.value(value: settingsBloc),
        ],
        child: child,
      ),
    );
  }
}