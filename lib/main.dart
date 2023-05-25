import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/statistics_bloc/statistics_bloc.dart';
import '../bloc/activity_bloc/activity_bloc.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../screens/main_activities_view.dart';
import '../data/settings/settings_data.dart';
import '../data/settings/themes.dart';
import '../data/activity_repository.dart';
import '../data/settings/settings_repository.dart';

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
        BlocProvider<StatisticsBloc>(
          create: (_) => StatisticsBloc(activityRepository: activityRepository),
        )
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, SettingsState state) {
        BlocProvider.of<SettingsBloc>(context)
            .add(SetInitialSetting(context: context));

        ThemeMode themeMode =
            state.themeMode ? ThemeMode.dark : ThemeMode.light;

        return MaterialApp(
          locale: state.locale,
          title: 'Minimal Time Tracker',
          theme: appTheme(state.theme, state.fontSize),
          darkTheme: appThemeDark(state.theme, state.fontSize),
          themeMode: themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          home: MainActivitiesView(activityRepository: activityRepository),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
