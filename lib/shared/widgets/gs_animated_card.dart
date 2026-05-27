import 'package:flutter/material.dart';

/// Wraps a child widget with a fade + scale entrance animation.
///
/// Set [isExiting] to `true` to trigger the reverse (exit) animation.
/// The [onExitComplete] callback fires when the exit animation finishes.
class GsAnimatedCard extends StatefulWidget {
  const GsAnimatedCard({
    super.key,
    required this.child,
    this.isExiting = false,
    this.onExitComplete,
    this.duration = const Duration(milliseconds: 280),
  });

  final Widget child;
  final bool isExiting;
  final VoidCallback? onExitComplete;
  final Duration duration;

  @override
  State<GsAnimatedCard> createState() => _GsAnimatedCardState();
}

class _GsAnimatedCardState extends State<GsAnimatedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(GsAnimatedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExiting && !oldWidget.isExiting) {
      _controller.reverse().then((_) {
        if (mounted) widget.onExitComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: _scale.value,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
