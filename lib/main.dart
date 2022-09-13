import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:minimal_time_tracker/data/mock_data.dart';
import 'package:minimal_time_tracker/add_activity_screen.dart';
import 'package:minimal_time_tracker/activity_card.dart';
import 'package:minimal_time_tracker/activity_bloc.dart';
import 'package:minimal_time_tracker/data/activity.dart';

//const String boxName = 'activitiesBox';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(TimeIntervalAdapter());
  Hive.registerAdapter(DurationAdapter());
  await Hive.openBox<Activity>(boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Activity> activitiesBox = Hive.box<Activity>(boxName);

    return BlocProvider(
      create: (_) => ActivitiesBloc(),
      child: const ActivitiesView(),
    );
  }
}

class ActivitiesView extends StatelessWidget {
  const ActivitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Activity> activitiesBox = Hive.box<Activity>(boxName);

    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, ActivitiesState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.title),
          ),
          body: activitiesBox.values.isEmpty
              ? SafeArea(
                  child: Center(
                    child: Text('No activities'),
                  ),
                )
              : SafeArea(
                  child: ListView.builder(
                    itemCount: state.activitiesBox.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ActivityCard(
                        activity: state.activitiesBox.getAt(index)!,
                        activityIndex: index,
                      );
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _addActivity(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _addActivity(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddActivityScreen()),
    ).then((value) => BlocProvider.of<ActivitiesBloc>(context)
        .add(ActivityAdded(activity: value)));
  }
}
