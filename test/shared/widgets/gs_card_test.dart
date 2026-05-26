import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/app/theme/app_colors.dart';
import 'package:gamestory/shared/widgets/gs_card.dart';
import 'package:gamestory/shared/widgets/gs_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsCard(child: Text('Card content')),
      ));
      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('onTap fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        GsCard(onTap: () => tapped = true, child: const Text('Tap me')),
      ));
      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('renders border when showBorder is true', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsCard(showBorder: true, child: Text('Bordered')),
      ));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GsCard),
          matching: find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration! as BoxDecoration).border != null,
          ),
        ),
      );
      final border = (container.decoration! as BoxDecoration).border! as Border;
      expect(border.top.color, AppColors.surfaceVariant);
    });

    testWidgets('no border when showBorder is false', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsCard(showBorder: false, child: Text('No border')),
      ));
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) =>
              c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).border != null)
          .toList();
      expect(containers, isEmpty);
    });

    testWidgets('renders actions slot', (tester) async {
      await tester.pumpWidget(_wrap(
        GsCard(
          actions: [GsButton(label: 'Save', onPressed: () {})],
          child: const Text('With actions'),
        ),
      ));
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
