import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class GsTreeNode extends StatelessWidget {
  const GsTreeNode({
    super.key,
    required this.label,
    this.indentLevel = 0,
    this.isExpanded = false,
    this.hasChildren = false,
    this.onToggle,
    this.onTap,
    this.trailing,
    this.isSelected = false,
  });

  final String label;
  final int indentLevel;
  final bool isExpanded;
  final bool hasChildren;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isSelected;

  static const double _indentWidth = 20.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: indentLevel * _indentWidth + 8.0,
            right: 8.0,
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: hasChildren
                    ? GestureDetector(
                        onTap: onToggle,
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          size: 14,
                          color: AppColors.muted,
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                    fontSize: 14,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
