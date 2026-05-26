import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsButton', () {
    testWidgets('renders primary variant label', (tester) async {
      await tester.pumpWidget(_wrap(
        GsButton(label: 'Primary', onPressed: () {}),
      ));
      expect(find.text('Primary'), findsOneWidget);
    });

    testWidgets('renders secondary variant', (tester) async {
      await tester.pumpWidget(_wrap(
        GsButton(
          label: 'Secondary',
          onPressed: () {},
          variant: GsButtonVariant.secondary,
        ),
      ));
      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('renders ghost variant', (tester) async {
      await tester.pumpWidget(_wrap(
        GsButton(
          label: 'Ghost',
          onPressed: () {},
          variant: GsButtonVariant.ghost,
        ),
      ));
      expect(find.text('Ghost'), findsOneWidget);
    });

    testWidgets('renders destructive variant', (tester) async {
      await tester.pumpWidget(_wrap(
        GsButton(
          label: 'Destructive',
          onPressed: () {},
          variant: GsButtonVariant.destructive,
        ),
      ));
      expect(find.text('Destructive'), findsOneWidget);
    });

    testWidgets('onPressed fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        GsButton(label: 'Tap me', onPressed: () => tapped = true),
      ));
      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('isLoading shows spinner and ignores taps', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        GsButton(
          label: 'Loading',
          onPressed: () => tapped = true,
          isLoading: true,
        ),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(GsButton));
      expect(tapped, isFalse);
    });

    testWidgets('null onPressed disables button', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsButton(label: 'Disabled', onPressed: null),
      ));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('renders icon alongside label', (tester) async {
      await tester.pumpWidget(_wrap(
        GsButton(
          label: 'With Icon',
          onPressed: () {},
          icon: Icons.add,
        ),
      ));
      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });
  });
}
