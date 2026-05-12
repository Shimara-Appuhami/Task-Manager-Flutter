import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:global_tna_app/main.dart';
import 'package:global_tna_app/storage/todo_storage.dart';

void main() {
  testWidgets('logs in and adds a todo item', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(storage: MemoryTodoStorage()));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);

    await tester.tap(find.text('Login').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('Pending: 1'), findsOneWidget);
  });
}
