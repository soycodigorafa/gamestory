import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_progress_bar.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsProgressBar', () {
    testWidgets('shows label and 0% text when progress is 0', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsProgressBar(progress: 0.0, label: 'Progress'),
      ));
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('shows 100% text when progress is 1', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsProgressBar(progress: 1.0, label: 'Complete'),
      ));
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('shows 45% text when progress is 0.45', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsProgressBar(progress: 0.45, label: 'Mid'),
      ));
      expect(find.text('45%'), findsOneWidget);
    });

    testWidgets('milestone tick marks match threshold count', (tester) async {
      const thresholds = [0.25, 0.5, 0.75];
      await tester.pumpWidget(_wrap(
        const SizedBox(
          width: 300,
          child: GsProgressBar(
            progress: 0.6,
            milestoneThresholds: thresholds,
          ),
        ),
      ));
      final ticks = tester.widgetList<Positioned>(find.byType(Positioned));
      expect(ticks.length, thresholds.length);
    });

    testWidgets('does not render label row when label is null', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsProgressBar(progress: 0.5),
      ));
      expect(find.byType(Row), findsNothing);
    });

    testWidgets('clamps progress above 1 to 100%', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsProgressBar(progress: 1.5, label: 'Over'),
      ));
      expect(find.text('100%'), findsOneWidget);
    });
  });
}
