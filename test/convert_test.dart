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

  testWidgets('return 0m for duration with all parameters = 0 for en locale',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      TestMaterialApp(
        locale: enLocale,
        child: LocalizedText(
          d: testDuration0,
        ),
      ),
    );
    expect(find.text('0m'), findsOneWidget);
  });

  testWidgets('return 0м for duration with all parameters = 0 for ru locale',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      TestMaterialApp(
        locale: ruLocale,
        child: LocalizedText(
          d: testDuration0,
        ),
      ),
    );
    expect(find.text('0м'), findsOneWidget);
  });

  Duration testDuration1 = Duration(days: 2, hours: 15, minutes: 30, seconds: 13);
  testWidgets('return 2d 15h 30m 13s for duration for en locale',
          (widgetTester) async {
        await widgetTester.pumpWidget(
          TestMaterialApp(
            locale: enLocale,
            child: LocalizedText(
              d: testDuration1,
            ),
          ),
        );
        expect(find.text('2d 15h 30m 13s'), findsOneWidget);
      });

  testWidgets('return 2д 15ч 30м 13с for duration for ru locale',
          (widgetTester) async {
        await widgetTester.pumpWidget(
          TestMaterialApp(
            locale: ruLocale,
            child: LocalizedText(
              d: testDuration1,
            ),
          ),
        );
        expect(find.text('2д 15ч 30м 13с'), findsOneWidget);
      });

  Duration testDuration2 = Duration(microseconds: 30);
  testWidgets('return 0m for duration for en locale',
          (widgetTester) async {
        await widgetTester.pumpWidget(
          TestMaterialApp(
            locale: enLocale,
            child: LocalizedText(
              d: testDuration2,
            ),
          ),
        );
        expect(find.text('0m'), findsOneWidget);
      });
}
