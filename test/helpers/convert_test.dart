import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:minimal_time_tracker/helpers/convert.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//проверка функции преобразования Duration в строку
//stringDuration(Duration d, BuildContext context) из /helpers/convert.dart
//с учетом текущей локали

//TestMaterialApp и LocalizedText - виджеты для тестирования,
//необходимые для получения контекста с локалью
class TestMaterialApp extends StatelessWidget {
  final Widget child;
  final Locale locale;

  const TestMaterialApp({Key? key, required this.child, required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [locale],
      home: child,
    );
  }
}

class LocalizedText extends StatelessWidget {
  const LocalizedText({Key? key, required this.d}) : super(key: key);
  final Duration d;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(stringDuration(d, context)),
    );
  }
}

void main() {
  Locale enLocale = const Locale('en', '');
  Locale ruLocale = const Locale('ru', '');

  Duration testDuration0 = Duration(days: 0, hours: 0, minutes: 0, seconds: 0);

  testWidgets('return 0 m for duration with all parameters = 0 for en locale',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      TestMaterialApp(
        locale: enLocale,
        child: LocalizedText(
          d: testDuration0,
        ),
      ),
    );
    expect(find.text('0 m'), findsOneWidget);
  });

  testWidgets('return 0 м for duration with all parameters = 0 for ru locale',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      TestMaterialApp(
        locale: ruLocale,
        child: LocalizedText(
          d: testDuration0,
        ),
      ),
    );
    expect(find.text('0 м'), findsOneWidget);
  });

  Duration testDuration1 = Duration(days: 2, hours: 15, minutes: 30, seconds: 13);
  testWidgets('return 2 d 15 h 30 m 13 s for duration for en locale',
          (widgetTester) async {
        await widgetTester.pumpWidget(
          TestMaterialApp(
            locale: enLocale,
            child: LocalizedText(
              d: testDuration1,
            ),
          ),
        );
        expect(find.text('2 d 15 h 30 m 13 s'), findsOneWidget);
      });

  testWidgets('return 2 д 15 ч 30 м 13 с for duration for ru locale',
          (widgetTester) async {
        await widgetTester.pumpWidget(
          TestMaterialApp(
            locale: ruLocale,
            child: LocalizedText(
              d: testDuration1,
            ),
          ),
        );
        expect(find.text('2 д 15 ч 30 м 13 с'), findsOneWidget);
      });

  Duration testDuration2 = Duration(microseconds: 30);
  testWidgets('return 0 m for duration for en locale',
          (widgetTester) async {
        await widgetTester.pumpWidget(
          TestMaterialApp(
            locale: enLocale,
            child: LocalizedText(
              d: testDuration2,
            ),
          ),
        );
        expect(find.text('0 m'), findsOneWidget);
      });

  Duration testDuration3 = Duration(minutes: 0, seconds: 40);
  testWidgets('return 40 s for duration for en locale',
          (widgetTester) async {
        await widgetTester.pumpWidget(
          TestMaterialApp(
            locale: enLocale,
            child: LocalizedText(
              d: testDuration3,
            ),
          ),
        );
        expect(find.text('40 s'), findsOneWidget);
      });
}
