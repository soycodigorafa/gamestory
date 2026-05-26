import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_bottom_sheet.dart';

void main() {
  group('GsBottomSheet', () {
    testWidgets('show() opens sheet and displays title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => GsBottomSheet.show(
                context: context,
                title: 'Test Sheet',
                child: const Text('Sheet content'),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Test Sheet'), findsOneWidget);
    });

    testWidgets('sheet shows child content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => GsBottomSheet.show(
                context: context,
                title: 'Sheet',
                child: const Text('Inner content'),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Inner content'), findsOneWidget);
    });

    testWidgets('GsBottomSheet widget renders title directly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GsBottomSheet(
              title: 'Direct Title',
              child: Text('Direct content'),
            ),
          ),
        ),
      );
      expect(find.text('Direct Title'), findsOneWidget);
      expect(find.text('Direct content'), findsOneWidget);
    });
  });
}
