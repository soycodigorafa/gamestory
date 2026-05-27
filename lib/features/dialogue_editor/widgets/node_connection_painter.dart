import 'dart:math' show max;

import 'package:flutter/material.dart';

import '../../../domain/entities/dialogue_choice.dart';

class NodeConnectionPainter extends CustomPainter {
  const NodeConnectionPainter({
    required this.nodeRects,
    required this.choices,
    required this.direction,
    required this.strokeColor,
  });

  final Map<String, Rect> nodeRects;
  final List<DialogueChoice> choices;
  final Axis direction;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = strokeColor.withValues(alpha: 0.65)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = strokeColor.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    for (final choice in choices) {
      if (choice.toNodeId == null) continue;
      final sourceRect = nodeRects[choice.fromNodeId];
      final targetRect = nodeRects[choice.toNodeId!];
      if (sourceRect == null || targetRect == null) continue;
      if (choice.fromNodeId == choice.toNodeId) continue;

      _drawConnection(canvas, linePaint, fillPaint, sourceRect, targetRect);
    }
  }

  void _drawConnection(
    Canvas canvas,
    Paint linePaint,
    Paint fillPaint,
    Rect source,
    Rect target,
  ) {
    Offset start;
    Offset end;
    Offset arrowDir;

    if (direction == Axis.vertical) {
      start = source.bottomCenter;
      end = target.topCenter;
      arrowDir = const Offset(0, 1);
    } else {
      start = source.centerRight;
      end = target.centerLeft;
      arrowDir = const Offset(1, 0);
    }

    final isForward = direction == Axis.vertical
        ? end.dy > start.dy + 10
        : end.dx > start.dx + 10;

    final path = Path();
    path.moveTo(start.dx, start.dy);

    if (isForward) {
      final spread = direction == Axis.vertical
          ? max(50.0, (end.dy - start.dy) * 0.4)
          : max(50.0, (end.dx - start.dx) * 0.4);

      if (direction == Axis.vertical) {
        path.cubicTo(
          start.dx, start.dy + spread,
          end.dx, end.dy - spread,
          end.dx, end.dy,
        );
      } else {
        path.cubicTo(
          start.dx + spread, start.dy,
          end.dx - spread, end.dy,
          end.dx, end.dy,
        );
      }
    } else {
      const offset = 90.0;
      if (direction == Axis.vertical) {
        arrowDir = const Offset(-1, 0);
        path.cubicTo(
          start.dx - offset, start.dy,
          end.dx - offset, end.dy,
          end.dx, end.dy,
        );
      } else {
        arrowDir = const Offset(0, -1);
        path.cubicTo(
          start.dx, start.dy - offset,
          end.dx, end.dy - offset,
          end.dx, end.dy,
        );
      }
    }

    canvas.drawPath(path, linePaint);
    _drawArrowhead(canvas, fillPaint, end, arrowDir);
  }

  void _drawArrowhead(
      Canvas canvas, Paint paint, Offset tip, Offset direction) {
    const size = 7.0;
    final perp = Offset(-direction.dy, direction.dx);
    final arrowPath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(
        (tip - direction * size + perp * (size * 0.5)).dx,
        (tip - direction * size + perp * (size * 0.5)).dy,
      )
      ..lineTo(
        (tip - direction * size - perp * (size * 0.5)).dx,
        (tip - direction * size - perp * (size * 0.5)).dy,
      )
      ..close();
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(NodeConnectionPainter old) =>
      old.nodeRects != nodeRects ||
      old.choices != choices ||
      old.direction != direction ||
      old.strokeColor != strokeColor;
}
