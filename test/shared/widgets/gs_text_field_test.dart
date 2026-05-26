import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_text_field.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsTextField', () {
    testWidgets('shows label text', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTextField(label: 'Project name'),
      ));
      expect(find.text('Project name'), findsOneWidget);
    });

    testWidgets('shows hint text', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTextField(hint: 'Enter text…'),
      ));
      expect(find.text('Enter text…'), findsOneWidget);
    });

    testWidgets('shows error text', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTextField(error: 'Required field'),
      ));
      expect(find.text('Required field'), findsOneWidget);
    });

    testWidgets('multiline allows multiple lines', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTextField(multiline: true, label: 'Notes'),
      ));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLines, isNull);
      expect(field.minLines, greaterThan(1));
    });

    testWidgets('calls onChanged callback', (tester) async {
      String? captured;
      await tester.pumpWidget(_wrap(
        GsTextField(onChanged: (v) => captured = v),
      ));
      await tester.enterText(find.byType(TextField), 'hello');
      expect(captured, 'hello');
    });

    testWidgets('disabled field ignores input', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTextField(enabled: false, label: 'Read only'),
      ));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });
  });
}
