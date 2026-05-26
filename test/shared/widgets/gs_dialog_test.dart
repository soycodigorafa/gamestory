import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_dialog.dart';

void main() {
  group('GsDialog', () {
    testWidgets('confirm dialog shows title and body', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GsDialog(title: 'Delete?', body: 'Cannot be undone.'),
          ),
        ),
      );
      expect(find.text('Delete?'), findsOneWidget);
      expect(find.text('Cannot be undone.'), findsOneWidget);
    });

    testWidgets('confirm dialog fires onConfirm callback', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GsDialog(
              title: 'Confirm',
              confirmLabel: 'OK',
              onConfirm: (_) => confirmed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('OK'));
      expect(confirmed, isTrue);
    });

    testWidgets('confirm dialog fires onCancel callback', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GsDialog(
              title: 'Confirm',
              cancelLabel: 'No',
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('No'));
      expect(cancelled, isTrue);
    });

    testWidgets('input variant shows TextField', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GsDialog(
              title: 'New Project',
              variant: GsDialogVariant.input,
              inputLabel: 'Name',
            ),
          ),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('input variant passes entered text to onConfirm', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GsDialog(
              title: 'New Project',
              variant: GsDialogVariant.input,
              confirmLabel: 'Save',
              onConfirm: (v) => result = v,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'My Game');
      await tester.tap(find.text('Save'));
      expect(result, 'My Game');
    });

    testWidgets('showConfirm displays dialog via navigator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => GsDialog.showConfirm(
                context: context,
                title: 'Are you sure?',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Are you sure?'), findsOneWidget);
    });
  });
}
