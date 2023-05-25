import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:minimal_time_tracker/main.dart' as app;
import 'package:minimal_time_tracker/widgets/activity_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group('end-to-end tests', () {
    testWidgets('create new activity, add data to it, delete activity',
        (widgetTester) async {
      //запуск приложения
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pump(const Duration(seconds: 2));

      //активностей нет
      expect(find.byKey(const Key('noActivitiesText')), findsOneWidget);

      //найти и нажать кнопку создания новой активности
      final Finder fab = find.byType(FloatingActionButton);
      await widgetTester.tap(fab);
      await widgetTester.pumpAndSettle();

      //найти textfield для заголовка и ввести заголовок
      final Finder titleTextField = find.byKey(const Key('title text field'));
      expect(titleTextField, findsOneWidget);
      await widgetTester.enterText(titleTextField, 'test title');
      await widgetTester.pumpAndSettle();
      await widgetTester.pump(const Duration(seconds: 2));

      //найти кнопки добавления времени, нажать первую
      final Finder durationButtons = find.byType(OutlinedButton);
      expect(durationButtons, findsNWidgets(3));
      await widgetTester.tap(durationButtons.first);
      await widgetTester.pumpAndSettle();
      await widgetTester.pump(const Duration(seconds: 2));
      final states = <MaterialState>{};
      //определяем что она была нажата по новому цвету
      Finder pressedButton = find.byWidgetPredicate((widget) =>
          widget is OutlinedButton &&
          (widget.style?.backgroundColor?.resolve(states) == Colors.black12));
      expect(pressedButton, findsOneWidget);

      //найти кнопку сохранения, сохранить активность
      final saveButton = find.widgetWithIcon(IconButton, Icons.save);
      expect(saveButton, findsOneWidget);
      await widgetTester.tap(saveButton);
      await widgetTester.pumpAndSettle();
      await widgetTester.pump(const Duration(seconds: 2));

      //убедиться, что на экране карточка с активностью с введёнными данными:
      //заголовком и выбранной кнопкой
      expect(find.byType(ActivityCard), findsOneWidget);
      expect(find.text('test title, total = 0 m'), findsOneWidget);
      Text buttonText = widgetTester.firstWidget(find.descendant(
          of: find.byType(OutlinedButton), matching: find.byType(Text)));
      expect(buttonText.data, '+ 1 h');

      //найти и нажать кнопку добавления времени
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle();
      await widgetTester.pump(const Duration(seconds: 2));
      //убедиться, что данные у активности изменились
      expect(find.text('test title, total = 1 h'), findsOneWidget);

      //найти кнопку удаления активности, нажать на неё
      await widgetTester.tap(find.widgetWithIcon(IconButton, Icons.delete));
      await widgetTester.pumpAndSettle();
      await widgetTester.pump(const Duration(seconds: 2));
      //нажать на кнопку подтверждения удаления
      await widgetTester.tap(find.byKey(const Key('deleteTextButton')));
      await widgetTester.pumpAndSettle();
      await widgetTester.pump(const Duration(seconds: 2));

      //убедиться, что активность удалена
      expect(find.byType(ActivityCard), findsNothing);
    });
  });
}
