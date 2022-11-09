import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:minimal_time_tracker/screens/add_activity_screen.dart';
import 'package:minimal_time_tracker/widgets/activity_card.dart';
import 'package:minimal_time_tracker/data/activity_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/screens/main_activities_view.dart';

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
    return BlocProvider(
      create: (_) => ActivitiesBloc(),
      child: MaterialApp(
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
        supportedLocales: [
          Locale('en', ''), // English, no country code
          Locale('ru', ''), // Russian, no country code
        ],
        home: const MainActivitiesView(),
      ),
    );
  }
}

