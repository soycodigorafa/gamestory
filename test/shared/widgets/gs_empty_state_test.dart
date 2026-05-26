import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_button.dart';
import 'package:gamestory/shared/widgets/gs_empty_state.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsEmptyState', () {
    testWidgets('shows title', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsEmptyState(title: 'Nothing here'),
      ));
      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('shows subtitle when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsEmptyState(
          title: 'Empty',
          subtitle: 'Add something to get started.',
        ),
      ));
      expect(find.text('Add something to get started.'), findsOneWidget);
    });

    testWidgets('does not show subtitle when omitted', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsEmptyState(title: 'Empty'),
      ));
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('CTA button fires callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        GsEmptyState(
          title: 'Empty',
          ctaLabel: 'Add Node',
          onCta: () => tapped = true,
        ),
      ));
      await tester.tap(find.widgetWithText(GsButton, 'Add Node'));
      expect(tapped, isTrue);
    });

    testWidgets('no CTA button when ctaLabel is null', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsEmptyState(title: 'Empty'),
      ));
      expect(find.byType(GsButton), findsNothing);
    });

    testWidgets('renders custom icon', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsEmptyState(
          title: 'Empty',
          icon: Icons.description_outlined,
        ),
      ));
      expect(find.byType(GsEmptyState), findsOneWidget);
    });
  });
}
