import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamestory/shared/widgets/gs_animated_card.dart';

void main() {
  const testDuration = Duration(milliseconds: 100);

  Widget buildSubject({bool isExiting = false, VoidCallback? onExitComplete}) {
    return MaterialApp(
      home: GsAnimatedCard(
        isExiting: isExiting,
        duration: testDuration,
        onExitComplete: onExitComplete,
        child: const Text('card'),
      ),
    );
  }

  testWidgets('renders child immediately', (tester) async {
    await tester.pumpWidget(buildSubject());
    expect(find.text('card'), findsOneWidget);
  });

  testWidgets('entrance: starts at low opacity and reaches full opacity',
      (tester) async {
    await tester.pumpWidget(buildSubject());

    // At t=0, animation just started — opacity should be near 0
    final opacityWidget =
        tester.firstWidget<Opacity>(find.byType(Opacity));
    expect(opacityWidget.opacity, lessThan(0.2));

    // After full duration, opacity should be 1
    await tester.pump(testDuration);
    await tester.pump();

    final opacityAfter =
        tester.firstWidget<Opacity>(find.byType(Opacity));
    expect(opacityAfter.opacity, moreOrLessEquals(1.0, epsilon: 0.01));
  });

  testWidgets('exit: opacity decreases when isExiting flips to true',
      (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump(testDuration); // complete entrance

    await tester.pumpWidget(buildSubject(isExiting: true));
    await tester.pump(testDuration ~/ 2); // halfway through exit

    final opacity = tester.firstWidget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, lessThan(0.9));
  });

  testWidgets('exit: onExitComplete fires after animation finishes',
      (tester) async {
    var called = false;
    await tester.pumpWidget(buildSubject());
    await tester.pump(testDuration); // complete entrance

    await tester.pumpWidget(
      buildSubject(isExiting: true, onExitComplete: () => called = true),
    );
    await tester.pumpAndSettle(); // run exit animation to completion

    expect(called, isTrue);
  });

  testWidgets('no error when isExiting is true on first build', (tester) async {
    await tester.pumpWidget(buildSubject(isExiting: true));
    await tester.pump(testDuration);
    expect(find.text('card'), findsOneWidget);
  });
}
