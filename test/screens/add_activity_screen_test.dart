import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_time_tracker/data/activity.dart';
import 'package:minimal_time_tracker/data/activity_bloc/activity_bloc.dart';
import 'package:minimal_time_tracker/settings/color_palettes.dart';
import 'package:minimal_time_tracker/settings/settings_bloc/settings_bloc.dart';
import 'package:mocktail/mocktail.dart';
import '../helper_test_material_app.dart';
import 'package:minimal_time_tracker/screens/add_activity_screen.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockActivitiesBloc extends MockBloc<ActivityEvent, ActivitiesState>
    implements ActivitiesBloc {}

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
  SettingsBloc settingsBloc = MockSettingsBlock();
  ActivitiesBloc activitiesBloc = MockActivitiesBloc();

  group('new activity screen', () {
    setUp(() {
      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pastel',
          themeMode: false,
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      when(() => activitiesBloc.state).thenReturn(NormalActivitiesState(
          {Duration(hours: 1): false, Duration(minutes: 30): false},
          0,
          Presentation.BUTTONS,
          0, []));
    });

    testWidgets('default new activity screen', (widgetTester) async {
      await widgetTester.pumpWidget(TestMaterialApp(
          settingsBloc: settingsBloc,
          activitiesBloc: activitiesBloc,
          child: AddActivityScreen()));

      final titleTextFinder = find.ancestor(
          of: find.text(''), matching: find.byKey(Key('title text field')));
      expect(titleTextFinder, findsOneWidget);
      final subtitleTextFinder = find.ancestor(
          of: find.text(''), matching: find.byKey(Key('subtitle text field')));
      expect(subtitleTextFinder, findsOneWidget);

      expect(find.byBoxDecorationColored(color: pastel[0]), findsOneWidget);
      expect(find.byBoxDecorationColored(color: pastel[1]), findsOneWidget);
      expect(find.byBoxDecorationColored(color: pastel[2]), findsOneWidget);
      expect(find.byBoxDecorationColored(color: pastel[3]), findsOneWidget);
      expect(find.byBoxDecorationColored(color: pastel[4]), findsOneWidget);

      final switchFinder = find.byWidgetPredicate(
          (widget) => widget is Switch && widget.value == true,
          description: 'Switch is switched for BUTTONS');
      expect(switchFinder, findsOneWidget);

      expect(find.byKey(Key('_buttonSettings')), findsOneWidget);
      expect(find.byKey(Key('_tableSettings')), findsNothing);

      final states = <MaterialState>{};
      final buttonFinder = find.byWidgetPredicate((widget) =>
          widget is OutlinedButton &&
          (widget.style?.backgroundColor?.resolve(states) == Colors.white12));
      expect(buttonFinder, findsNWidgets(2));
      expect(find.text('1 h'), findsOneWidget);
      expect(find.text('30 m'), findsOneWidget);
    });

    testWidgets('show SnackBar when trying to save with no title',
        (widgetTester) async {
      await widgetTester.pumpWidget(TestMaterialApp(
          settingsBloc: settingsBloc,
          activitiesBloc: activitiesBloc,
          child: AddActivityScreen()));

      await widgetTester.tap(find.byIcon(Icons.save));
      await widgetTester.pump();
      expect(find.byKey(Key('noTitleSnackBar')), findsOneWidget);
    });
  });

  group('screen with edited activity', () {
    late Activity testActivity;

    setUp(() {
      when(() => settingsBloc.state).thenReturn(SettingsState(
          locale: Locale('en', ''),
          theme: 'Pastel',
          themeMode: false,
          fontSize: 12,
          showArchive: true,
          status: Status.normal));

      int testColor = 1;
      Presentation testPresentation = Presentation.BUTTONS;
      Map<Duration, bool> testDurationButtons = {
        Duration(minutes: 15): true,
        Duration(minutes: 10): true
      };
      testActivity = Activity(
        title: 'test title',
        subtitle: 'test subtitle',
        durationButtons: [Duration(minutes: 15), Duration(minutes: 10)],
        presentation: testPresentation,
        color: testColor,
      );

      testActivity.addInterval(TimeInterval.duration(
          end: DateTime.now(), duration: Duration(minutes: 15)));
      testActivity.addInterval(TimeInterval.duration(
          end: DateTime.now(), duration: Duration(minutes: 10)));
      testActivity.addInterval(TimeInterval.duration(
          end: DateTime.now(), duration: Duration(minutes: 10)));

      when(() => activitiesBloc.state).thenReturn(NormalActivitiesState(
          testDurationButtons, testColor, testPresentation, 2, [0, 1, 2], testActivity));
    });

    testWidgets('screen with edited activity', (widgetTester) async {
      await widgetTester.pumpWidget(TestMaterialApp(
          settingsBloc: settingsBloc,
          activitiesBloc: activitiesBloc,
          child: AddActivityScreen.editActivity(editedActivity: testActivity)));

      final titleTextFinder = find.ancestor(
          of: find.text('test title'), matching: find.byKey(Key('title text field')));
      expect(titleTextFinder, findsOneWidget);
      final subtitleTextFinder = find.ancestor(
          of: find.text('test subtitle'), matching: find.byKey(Key('subtitle text field')));
      expect(subtitleTextFinder, findsOneWidget);

      final states = <MaterialState>{};
      final buttonFinder = find.byWidgetPredicate((widget) =>
          widget is OutlinedButton &&
          (widget.style?.backgroundColor?.resolve(states) == Colors.black12));
      expect(buttonFinder, findsNWidgets(2));
      expect(find.text('15 m'), findsOneWidget);
      expect(find.text('10 m'), findsOneWidget);

      expect(find.byKey(Key('editActivityData')), findsOneWidget);
      expect(find.byKey(Key('editActivityDataCard')), findsNWidgets(3));
      expect(find.byKey(Key('editActivityDataButton')), findsOneWidget);
      expect(find.text('Total: 35 m'), findsOneWidget);
    });
  });
}
