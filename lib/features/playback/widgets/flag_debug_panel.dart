import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class FlagDebugPanel extends StatefulWidget {
  const FlagDebugPanel({super.key, required this.flagMap});

  final Map<String, bool> flagMap;

  @override
  State<FlagDebugPanel> createState() => _FlagDebugPanelState();
}

class _FlagDebugPanelState extends State<FlagDebugPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondary =
        isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final errorColor = isDark ? AppColors.darkError : AppColors.lightError;

    final activeCount =
        widget.flagMap.values.where((v) => v == true).length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: surface,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkSurfaceVariant
                : AppColors.lightSurfaceVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.flag_rounded, size: 16, color: primary),
                  const SizedBox(width: 8),
                  Text(
                    widget.flagMap.isEmpty
                        ? 'No flags set'
                        : '$activeCount / ${widget.flagMap.length} flags true',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (widget.flagMap.isNotEmpty)
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 18,
                      color: mutedColor,
                    ),
                ],
              ),
            ),
          ),
          if (_expanded && widget.flagMap.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Column(
                children: widget.flagMap.entries.map((entry) {
                  final isTrue = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Icon(
                          isTrue
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          size: 14,
                          color: isTrue ? secondary : errorColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isTrue
                                ? secondary.withValues(alpha: 0.15)
                                : errorColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isTrue ? 'true' : 'false',
                            style: TextStyle(
                              color: isTrue ? secondary : errorColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
