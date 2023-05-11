import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:minimal_time_tracker/data/bloc/activity_bloc.dart';
import 'package:minimal_time_tracker/settings/bloc/settings_bloc.dart';
import 'package:minimal_time_tracker/screens/main_activities_view.dart';
import 'package:minimal_time_tracker/settings/settings_data.dart';
import 'package:minimal_time_tracker/settings/themes.dart';
import 'package:minimal_time_tracker/data/activity_repository.dart';
import 'package:minimal_time_tracker/settings/settings_repository.dart';

void main() async {
  ActivityRepository activityRepository = ActivityRepository();
  await activityRepository.initRepository();

  SettingsRepository settingsRepository = SettingsRepository();
  await settingsRepository.initRepository();

  runApp(MyApp(
    activityRepository: activityRepository,
    settingsRepository: settingsRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ActivityRepository activityRepository;
  final SettingsRepository settingsRepository;

  const MyApp(
      {Key? key,
      required this.activityRepository,
      required this.settingsRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ActivitiesBloc>(
            create: (_) =>
                ActivitiesBloc(activityRepository: activityRepository)),
        BlocProvider<SettingsBloc>(
            create: (_) =>
                SettingsBloc(settingsRepository: settingsRepository)),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, SettingsState state) {
        BlocProvider.of<SettingsBloc>(context).add(SetInitialSetting(context: context));

        ThemeMode themeMode = state.themeMode ? ThemeMode.dark : ThemeMode.light;

        return MaterialApp(
          locale: state.locale,
          title: 'Minimal Time Tracker',
          theme: appTheme(state.theme!, state.fontSize!),
          darkTheme: appThemeDark(state.theme!, state.fontSize!),
          themeMode: themeMode,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          home: MainActivitiesView(activityRepository: activityRepository),
        );
      }),
    );
  }
}
