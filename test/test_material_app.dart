import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_time_tracker/data/activity_bloc.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestMaterialApp extends StatelessWidget {
  final Widget child;
  final String boxName;
  final String archiveName;
  final SettingsBloc settingsBloc;

  const TestMaterialApp({
    Key? key,
    required this.child,
    required this.boxName,
    required this.archiveName,
    required this.settingsBloc,
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
          BlocProvider<ActivitiesBloc>(
              create: (_) => ActivitiesBloc(boxName, archiveName)),
          BlocProvider.value(value: settingsBloc),
        ],
        child: child,
      ),
    );
  }
}