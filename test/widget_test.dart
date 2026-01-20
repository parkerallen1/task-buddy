import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_buddy/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskBuddyApp());
    expect(find.text('My Tasks'), findsOneWidget);
  });
}
