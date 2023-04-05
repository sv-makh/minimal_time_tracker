import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/screens/add_activity_screen.dart';
import 'package:minimal_time_tracker/settings/settings_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'test_material_app.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class BoxDecorationColoredFinder extends MatchFinder {
  Color color;

  BoxDecorationColoredFinder({bool skipOffstage = true, required this.color})
      : super(skipOffstage: skipOffstage);

  @override
  String get description => 'Finds BoxDecoration with color';

  @override
  bool matches(Element candidate) {
    final Widget widget = candidate.widget;
    return (widget is Container) &&
        (widget.decoration != null) &&
        ((widget.decoration as BoxDecoration).color == color);
  }
}

extension BoxDecorationColored on CommonFinders {
  Finder byBoxDecorationColored(
          {bool skipOffstage = true, required Color color}) =>
      BoxDecorationColoredFinder(color: color);
}

void main() {
  group('AddActivityScreen tests', () {
    String boxName = 'mockBox';
    String archiveName = 'mockArchive';
    late Box<Activity> testActivitiesBox;
    late Box<Activity> testArchiveBox;
    late SettingsBloc settingsBloc;

    setUpAll(() {
      Hive.registerAdapter(ActivityAdapter());
      Hive.registerAdapter(TimeIntervalAdapter());
      Hive.registerAdapter(DurationAdapter());
      Hive.registerAdapter(PresentationAdapter());
    });

    setUp(() async {
      settingsBloc = MockSettingsBloc();
      await setUpTestHive();
      testActivitiesBox = await Hive.openBox<Activity>(boxName);
      testArchiveBox = await Hive.openBox<Activity>(archiveName);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    testWidgets('default new activity screen',
        (widgetTester) async {
      when(() => settingsBloc.state)
          .thenReturn(SettingsState(Locale('en', ''), 'Olive', 12, true));

      await widgetTester.pumpWidget(TestMaterialApp(
          child: AddActivityScreen(),
          boxName: boxName,
          archiveName: archiveName,
          settingsBloc: settingsBloc));

      expect(titleController.text, '');
      expect(subtitleController.text, '');

      expect(find.byBoxDecorationColored(color: Color(0xFF584D32)),
          findsOneWidget);
      expect(find.byBoxDecorationColored(color: Color(0xFF615A3B)),
          findsOneWidget);
      expect(find.byBoxDecorationColored(color: Color(0xFF457863)),
          findsOneWidget);
      expect(find.byBoxDecorationColored(color: Color(0xFF69B8A6)),
          findsOneWidget);
      expect(find.byBoxDecorationColored(color: Color(0xFFCFF8E5)),
          findsOneWidget);

      final switchFinder = find.byWidgetPredicate(
          (widget) => widget is Switch && widget.value == true,
          description: 'Switch is switched for BUTTONS');
      expect(switchFinder, findsOneWidget);

      expect(find.byKey(Key('_buttonSettings')), findsOneWidget);
      expect(find.byKey(Key('_tableSettings')), findsNothing);

      final states = <MaterialState>{};
      final buttonFinder = find.byWidgetPredicate((widget) =>
          widget is OutlinedButton &&
          (widget.style?.backgroundColor?.resolve(states) == Colors.white));
      expect(buttonFinder, findsNWidgets(2));
      expect(find.text('1h'), findsOneWidget);
      expect(find.text('30m'), findsOneWidget);
    });

    testWidgets('show SnackBar when trying to save with no title',
        (widgetTester) async {
      when(() => settingsBloc.state)
          .thenReturn(SettingsState(Locale('en', ''), 'Olive', 12, true));

      await widgetTester.pumpWidget(TestMaterialApp(
          child: AddActivityScreen(),
          boxName: boxName,
          archiveName: archiveName,
          settingsBloc: settingsBloc));

      await widgetTester.tap(find.byIcon(Icons.save));
      await widgetTester.pump();
      expect(find.byKey(Key('noTitleSnackBar')), findsOneWidget);
    });

    testWidgets('switch to table buttons',
            (widgetTester) async {
          when(() => settingsBloc.state)
              .thenReturn(SettingsState(Locale('en', ''), 'Olive', 12, true));

          await widgetTester.pumpWidget(TestMaterialApp(
              child: AddActivityScreen(),
              boxName: boxName,
              archiveName: archiveName,
              settingsBloc: settingsBloc));

          await widgetTester.tap(find.byType(Switch));
          await widgetTester.pump();
          expect(find.text('+'), findsOneWidget);

          final states = <MaterialState>{};
          final buttonFinder = find.byWidgetPredicate((widget) =>
          widget is OutlinedButton &&
              (widget.style?.backgroundColor?.resolve(states) == Colors.white));
          expect(buttonFinder, findsNothing);
          expect(find.text('1h'), findsNothing);
          expect(find.text('30m'), findsNothing);
          expect(find.text('0'), findsOneWidget);
        });
  });
}
