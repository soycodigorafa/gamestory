import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum GsIconButtonSize { small, medium, large }

class GsIconButton extends StatelessWidget {
  const GsIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = GsIconButtonSize.medium,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final GsIconButtonSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final (iconSize, padding) = switch (size) {
      GsIconButtonSize.small => (14.0, const EdgeInsets.all(6.0)),
      GsIconButtonSize.medium => (18.0, const EdgeInsets.all(8.0)),
      GsIconButtonSize.large => (22.0, const EdgeInsets.all(10.0)),
    };

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: padding,
          child: Icon(
            icon,
            size: iconSize,
            color: onPressed == null
                ? AppColors.muted
                : (color ?? AppColors.onSurface),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
