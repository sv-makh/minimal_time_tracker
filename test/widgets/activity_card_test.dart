import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/settings/bloc/settings_bloc.dart';
import 'package:minimal_time_tracker/widgets/activity_card.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import '../test_material_app.dart';
import 'package:mocktail/mocktail.dart';

//файндер, ищущий кнопки OutlinedButton заданного цвета
//также у них не активно простое нажатие и активно долгое нажатие
class PressedButtonsFinder extends MatchFinder {
  Color color;

  PressedButtonsFinder({bool skipOffstage = true, required this.color})
      : super(skipOffstage: skipOffstage);

  @override
  String get description => 'Finds earlier pressed Outlined buttons';

  @override
  bool matches(Element candidate) {
    final Widget widget = candidate.widget;
    final states = <MaterialState>{};
    return (widget is OutlinedButton) &&
        (widget.style?.backgroundColor?.resolve(states) == color) &&
        (widget.onPressed == null) &&
        (widget.onLongPress != null);
  }
}

//добавление файндера PressedButtons в класс CommonFinders
//(чтобы его можно было использовать: find.byPressedButtons)
extension PressedButton on CommonFinders {
  Finder byPressedButtons({bool skipOffstage = true, required Color color}) =>
      PressedButtonsFinder(color: color);
}

class EnabledButtonsFinder extends MatchFinder {
  EnabledButtonsFinder({bool skipOffstage = true})
      : super(skipOffstage: skipOffstage);

  @override
  String get description => 'Finds enabled Outlined buttons';

  @override
  bool matches(Element candidate) {
    final Widget widget = candidate.widget;
    return (widget is OutlinedButton) && (widget.onPressed != null);
  }
}

extension EnabledButtons on CommonFinders {
  Finder byEnabledButtons({bool skipOffstage = true}) => EnabledButtonsFinder();
}

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  late SettingsBloc settingsBloc;

  group('ActivityCard tests', () {
    String boxName = 'mockBox';
    String archiveName = 'mockArchive';
    late Box<Activity> testActivitiesBox;
    late Box<Activity> testArchiveBox;

    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(TimeIntervalAdapter());
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(PresentationAdapter());

    setUp(() async {
      settingsBloc = MockSettingsBloc();
      await setUpTestHive();
      testActivitiesBox = await Hive.openBox<Activity>(boxName);
      testArchiveBox = await Hive.openBox<Activity>(archiveName);
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('testing stubbing the bloc stream and emitting one state', () async {
      when(() => settingsBloc.state)
          .thenReturn(SettingsState(Locale('en', ''), 'Pale', 12, true));
      expect(settingsBloc.state,
          equals(SettingsState(Locale('en', ''), 'Pale', 12, true)));
    });

    testWidgets('activity only with title, not in archive',
        (widgetTester) async {
      when(() => settingsBloc.state)
          .thenReturn(SettingsState(Locale('en', ''), 'Pale', 12, true));

      await widgetTester.pumpWidget(TestMaterialApp(
        child: ActivityCard(
            activity: Activity(title: 'test title'),
            activityIndex: 0,
            archived: false),
        boxName: boxName,
        archiveName: archiveName,
        settingsBloc: settingsBloc,
      ));

      expect(find.byKey(Key('title of activity')), findsOneWidget);
      expect(find.text('test title, total = 0m'), findsOneWidget);

      expect(find.byKey(Key('subtitle of activity')), findsNothing);

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.archive), findsOneWidget);
      expect(find.byIcon(Icons.unarchive), findsNothing);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byKey(Key('rowOfButtons')), findsNothing);
      expect(find.byKey(Key('tableOfButtons')), findsNothing);
    });

    testWidgets('activity with table buttons, not in archive',
        (widgetTester) async {
      int maxNum = 10;
      Activity testActivity = Activity(
        title: 'test title',
        subtitle: 'test subtitle',
        presentation: Presentation.TABLE,
        color: 1,
        maxNum: maxNum,
      );
      for (int i = 0; i < maxNum; i++) {
        testActivity.addDurationButton(Duration(hours: 1));
      }
      for (int i = 0; i < 3; i++) {
        testActivity.addInterval(TimeInterval.duration(
            end: DateTime.now(), duration: Duration(hours: 1)));
      }

      when(() => settingsBloc.state)
          .thenReturn(SettingsState(Locale('en', ''), 'Olive', 12, true));

      await widgetTester.pumpWidget(TestMaterialApp(
        child: ActivityCard(
            activity: testActivity, activityIndex: 0, archived: false),
        boxName: boxName,
        archiveName: archiveName,
        settingsBloc: settingsBloc,
      ));

      final card = widgetTester.widget<Card>(find.byType(Card));
      expect(card.color, Color(0xFF615A3B));

      expect(find.byKey(Key('title of activity')), findsOneWidget);
      expect(find.text('test title, total = 3h'), findsOneWidget);

      expect(find.byKey(Key('subtitle of activity')), findsOneWidget);
      expect(find.text('test subtitle'), findsOneWidget);

      expect(find.byKey(Key('tableOfButtons')), findsOneWidget);
      expect(find.text('Checked cells: 3'), findsOneWidget);
      expect(find.text('Total: $maxNum'), findsOneWidget);

      expect(find.byType(OutlinedButton), findsNWidgets(maxNum));
      //нажатые ранее кнопки в таблице меняют цвет, ищем кнопки такого цвета
      //oliveDark[1] из color_palettes.dart
      expect(find.byPressedButtons(color: Color(0xFF47422B)), findsNWidgets(3));
      //для простого нажатия активна одна кнопка
      expect(find.byEnabledButtons(), findsOneWidget);
    });

    testWidgets('activity with row of buttons, archived', (widgetTester) async {
      Activity testActivity = Activity(
        title: 'test title',
        subtitle: 'test subtitle',
        presentation: Presentation.BUTTONS,
        color: 1,
      );
      testActivity.addDurationButton(Duration(hours: 1));
      testActivity.addDurationButton(Duration(minutes: 40));
      testActivity.addInterval(TimeInterval.duration(
          end: DateTime.now(), duration: Duration(hours: 1)));
      testActivity.addInterval(TimeInterval.duration(
          end: DateTime.now(), duration: Duration(minutes: 40)));

      when(() => settingsBloc.state)
          .thenReturn(SettingsState(Locale('en', ''), 'Pastel', 12, true));

      await widgetTester.pumpWidget(TestMaterialApp(
        child: ActivityCard(
            activity: testActivity, activityIndex: 0, archived: true),
        boxName: boxName,
        archiveName: archiveName,
        settingsBloc: settingsBloc,
      ));

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.byIcon(Icons.archive), findsNothing);
      expect(find.byIcon(Icons.unarchive), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byKey(Key('rowOfButtons')), findsOneWidget);
      expect(find.byKey(Key('tableOfButtons')), findsNothing);

      final card = widgetTester.widget<Card>(find.byType(Card));
      expect(card.color, Color(0xFFCAD7B2));

      expect(find.byKey(Key('title of activity')), findsOneWidget);
      expect(find.text('test title, total = 1h 40m'), findsOneWidget);

      expect(find.byKey(Key('subtitle of activity')), findsOneWidget);
      expect(find.text('test subtitle'), findsOneWidget);

      expect(find.byType(OutlinedButton), findsNWidgets(2));
      //в архиве нельзя нажимать кнопки
      expect(find.byEnabledButtons(), findsNothing);
    });
  });
}
