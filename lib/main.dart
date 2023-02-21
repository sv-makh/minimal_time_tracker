import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:minimal_time_tracker/data/activity_bloc.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/screens/main_activities_view.dart';
import 'package:minimal_time_tracker/settings/settings_data.dart';
import 'package:minimal_time_tracker/settings/themes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(TimeIntervalAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(PresentationAdapter());
  await Hive.openBox<Activity>(boxName);
  await Hive.openBox<Activity>(archiveName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ActivitiesBloc>(create: (_) => ActivitiesBloc()),
        BlocProvider<SettingsBloc>(create: (_) => SettingsBloc()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, SettingsState state) {
        BlocProvider.of<SettingsBloc>(context).add(SetInitialSetting());

        return MaterialApp(
          locale: state.locale,
          title: 'Minimal Time Tracker',
          theme: appTheme(state.theme!, state.fontSize!),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          home: const MainActivitiesView(),
        );
      }),
    );
  }
}
