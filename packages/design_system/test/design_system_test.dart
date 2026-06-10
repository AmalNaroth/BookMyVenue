import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/design_system.dart';

void main() {
  testWidgets('AuthTextField renders label text', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthTextField(
            controller: controller,
            labelText: 'Email address',
          ),
        ),
      ),
    );

    expect(find.text('Email address'), findsOneWidget);
  });
}
