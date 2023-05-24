import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/settings/color_palettes.dart';
import 'package:minimal_time_tracker/settings/settings_bloc/settings_bloc.dart';
import 'package:minimal_time_tracker/widgets/activity_card.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import '../helper_test_material_app.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

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

//файндер, ищущий кнопки OutlinedButton, на которые можно нажать
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

//добавление файндера EnabledButtons в класс CommonFinders
extension EnabledButtons on CommonFinders {
  Finder byEnabledButtons({bool skipOffstage = true}) => EnabledButtonsFinder();
}

void main() {
  SettingsBloc settingsBloc = MockSettingsBloc();

  group('ActivityCard tests', () {

    test('testing stubbing the bloc stream and emitting one state', () async {
      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pale',
          fontSize: 12,
          showArchive: true,
          status: Status.normal));
      expect(
          settingsBloc.state,
          equals(SettingsState(
              locale: Locale('en', ''),
              theme: 'Pale',
              fontSize: 12,
              showArchive: true,
              status: Status.normal)));
    });

    testWidgets('activity only with title, not in archive',
        (widgetTester) async {
      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pale',
          themeMode: false,
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      await widgetTester.pumpWidget(TestMaterialApp(
        child: ActivityCard(
          activity: Activity(title: 'test title'),
          activityIndex: 0,
          archived: false,
        ),
        settingsBloc: settingsBloc,
      ));

      expect(find.byKey(Key('title of activity')), findsOneWidget);
      expect(find.text('test title, total = 0 m'), findsOneWidget);
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

      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pastel',
          themeMode: false,
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      await widgetTester.pumpWidget(TestMaterialApp(
        child: ActivityCard(
            activity: testActivity, activityIndex: 0, archived: false),
        settingsBloc: settingsBloc,
      ));

      final card = widgetTester.widget<Card>(find.byType(Card));
      expect(card.color, pastel[1]);

      expect(find.byKey(Key('title of activity')), findsOneWidget);
      expect(find.text('test title, total = 3 h'), findsOneWidget);

      expect(find.byKey(Key('subtitle of activity')), findsOneWidget);
      expect(find.text('test subtitle'), findsOneWidget);

      expect(find.byKey(Key('tableOfButtons')), findsOneWidget);
      expect(find.text('Checked cells: 3'), findsOneWidget);
      expect(find.text('Total: $maxNum'), findsOneWidget);

      expect(find.byType(OutlinedButton), findsNWidgets(maxNum));
      //нажатые ранее кнопки в таблице меняют цвет, ищем кнопки такого цвета
      //pastelDark[1] из color_palettes.dart
      expect(find.byPressedButtons(color: pastelDark[1]), findsNWidgets(3));
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

      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pastel',
          themeMode: false,
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      await widgetTester.pumpWidget(TestMaterialApp(
        child: ActivityCard(
            activity: testActivity, activityIndex: 0, archived: true),
        settingsBloc: settingsBloc,
      ));

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.byIcon(Icons.archive), findsNothing);
      expect(find.byIcon(Icons.unarchive), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byKey(Key('rowOfButtons')), findsOneWidget);
      expect(find.byKey(Key('tableOfButtons')), findsNothing);

      final card = widgetTester.widget<Card>(find.byType(Card));
      expect(card.color, pastelInactive[1]);

      expect(find.byKey(Key('title of activity')), findsOneWidget);
      expect(find.text('test title, total = 1 h 40 m'), findsOneWidget);

      expect(find.byKey(Key('subtitle of activity')), findsOneWidget);
      expect(find.text('test subtitle'), findsOneWidget);

      expect(find.byType(OutlinedButton), findsNWidgets(2));
      //в архиве нельзя нажимать кнопки
      expect(find.byEnabledButtons(), findsNothing);
    });
  });
}
