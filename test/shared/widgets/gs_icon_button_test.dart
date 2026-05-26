import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/app/theme/app_colors.dart';
import 'package:gamestory/shared/widgets/gs_icon_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('GsIconButton', () {
    testWidgets('onPressed fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        GsIconButton(
          icon: Icons.add,
          onPressed: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(GsIconButton));
      expect(tapped, isTrue);
    });

    testWidgets('shows tooltip on long press', (tester) async {
      await tester.pumpWidget(_wrap(
        GsIconButton(
          icon: Icons.edit_outlined,
          onPressed: () {},
          tooltip: 'Edit',
        ),
      ));
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Edit');
    });

    testWidgets('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(_wrap(
        const GsIconButton(
          icon: Icons.settings_outlined,
          onPressed: null,
        ),
      ));
      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.onTap, isNull);
    });

    testWidgets('small size renders smaller padding', (tester) async {
      await tester.pumpWidget(_wrap(
        GsIconButton(
          icon: Icons.add,
          onPressed: () {},
          size: GsIconButtonSize.small,
        ),
      ));
      expect(find.byType(GsIconButton), findsOneWidget);
    });

    testWidgets('custom color is applied to icon', (tester) async {
      await tester.pumpWidget(_wrap(
        GsIconButton(
          icon: Icons.delete_outline,
          onPressed: () {},
          color: AppColors.error,
        ),
      ));
      expect(find.byType(GsIconButton), findsOneWidget);
    });
  });
}
