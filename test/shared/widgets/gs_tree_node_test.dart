import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_tree_node.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsTreeNode', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTreeNode(label: 'Root node'),
      ));
      expect(find.text('Root node'), findsOneWidget);
    });

    testWidgets('deeper indent level adds more left padding', (tester) async {
      await tester.pumpWidget(_wrap(
        Column(
          children: const [
            GsTreeNode(label: 'Level 0'),
            GsTreeNode(label: 'Level 2', indentLevel: 2),
          ],
        ),
      ));

      final paddingWidgets = tester
          .widgetList<Padding>(
            find.descendant(
              of: find.byType(GsTreeNode),
              matching: find.byType(Padding),
            ),
          )
          .toList();

      expect(paddingWidgets.length, greaterThanOrEqualTo(2));
    });

    testWidgets('onToggle fires when caret tapped', (tester) async {
      var toggled = false;
      await tester.pumpWidget(_wrap(
        GsTreeNode(
          label: 'Expandable',
          hasChildren: true,
          isExpanded: false,
          onToggle: () => toggled = true,
        ),
      ));
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
      expect(toggled, isTrue);
    });

    testWidgets('onTap fires when row tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        GsTreeNode(
          label: 'Tappable',
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Tappable'));
      expect(tapped, isTrue);
    });

    testWidgets('trailing widget is rendered', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTreeNode(
          label: 'With trailing',
          trailing: Text('trailing'),
        ),
      ));
      expect(find.text('trailing'), findsOneWidget);
    });

    testWidgets('no caret icon shown when hasChildren is false', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsTreeNode(label: 'Leaf', hasChildren: false),
      ));
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
    });
  });
}
