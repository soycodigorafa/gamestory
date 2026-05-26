import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class GsCard extends StatelessWidget {
  const GsCard({
    super.key,
    required this.child,
    this.actions,
    this.showBorder = true,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final List<Widget>? actions;
  final bool showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!
                .expand((a) => [a, const SizedBox(width: 8)])
                .toList()
              ..removeLast(),
          ),
        ],
      ],
    );

    content = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: content,
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: showBorder
                ? Border.all(color: AppColors.surfaceVariant)
                : null,
          ),
          child: content,
        ),
      ),
    );
  }
}
