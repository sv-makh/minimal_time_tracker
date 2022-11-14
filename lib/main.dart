import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:minimal_time_tracker/data/activity_bloc.dart';
import 'package:minimal_time_tracker/data/language_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/screens/main_activities_view.dart';
import 'package:minimal_time_tracker/settings/settings_data.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(TimeIntervalAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(PresentationAdapter());
  await Hive.openBox<Activity>(boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ActivitiesBloc>(create: (_) => ActivitiesBloc()),
        BlocProvider<LanguageBloc>(create: (_) => LanguageBloc()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, LanguageState state) {

          BlocProvider.of<LanguageBloc>(context).add(SetInitialLocale());

          return MaterialApp(
            locale: state.locale,
            title: 'Minimal Time Tracker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: supportedLocales,
            home: const MainActivitiesView(),
          );
        }
      ),
    );
  }
}
