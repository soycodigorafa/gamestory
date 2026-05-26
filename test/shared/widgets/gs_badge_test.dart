import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/app/theme/app_colors.dart';
import 'package:gamestory/shared/widgets/gs_badge.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsBadge', () {
    testWidgets('complete status shows default label', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsBadge(status: GsBadgeStatus.complete),
      ));
      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('incomplete status shows default label', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsBadge(status: GsBadgeStatus.incomplete),
      ));
      expect(find.text('Incomplete'), findsOneWidget);
    });

    testWidgets('locked status shows default label', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsBadge(status: GsBadgeStatus.locked),
      ));
      expect(find.text('Locked'), findsOneWidget);
    });

    testWidgets('custom label overrides default', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsBadge(status: GsBadgeStatus.complete, label: 'Done!'),
      ));
      expect(find.text('Done!'), findsOneWidget);
      expect(find.text('Complete'), findsNothing);
    });

    testWidgets('complete badge text uses secondary color', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsBadge(status: GsBadgeStatus.complete),
      ));
      final text = tester.widget<Text>(find.text('Complete'));
      expect(text.style?.color, AppColors.secondary);
    });

    testWidgets('locked badge text uses error color', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsBadge(status: GsBadgeStatus.locked),
      ));
      final text = tester.widget<Text>(find.text('Locked'));
      expect(text.style?.color, AppColors.error);
    });
  });
}
