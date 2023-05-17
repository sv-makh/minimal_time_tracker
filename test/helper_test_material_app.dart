import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_time_tracker/data/activity_bloc/activity_bloc.dart';
import 'package:minimal_time_tracker/data/statistics_bloc/statistics_bloc.dart';
import 'package:minimal_time_tracker/settings/settings_bloc/settings_bloc.dart';

class MockActivitiesBloc extends MockBloc<ActivityEvent, ActivitiesState>
    implements ActivitiesBloc {}

class MockSettingsBlock extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockStatisticsBloc extends MockBloc<StatisticsEvent, StatisticsState>
    implements StatisticsBloc {}

class TestMaterialApp extends StatelessWidget {
  final Widget child;
  SettingsBloc? settingsBloc;
  ActivitiesBloc? activitiesBloc;
  StatisticsBloc? statisticsBloc;

  TestMaterialApp({
    Key? key,
    required this.child,
    SettingsBloc? this.settingsBloc,
    ActivitiesBloc? this.activitiesBloc,
    StatisticsBloc? this.statisticsBloc,
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
        supportedLocales: [
          Locale('en', '')
        ],
        home: MultiBlocProvider(
          providers: [
            if (activitiesBloc != null)
              BlocProvider.value(value: activitiesBloc!)
            else
              BlocProvider<ActivitiesBloc>(create: (_) => MockActivitiesBloc()),
            if (settingsBloc != null)
              BlocProvider.value(value: settingsBloc!)
            else
              BlocProvider<SettingsBloc>(create: (_) => MockSettingsBlock()),
            if (statisticsBloc != null)
              BlocProvider.value(value: statisticsBloc!)
            else
              BlocProvider<StatisticsBloc>(create: (_) => MockStatisticsBloc()),
          ],
          child: child,
        ));
  }
}
