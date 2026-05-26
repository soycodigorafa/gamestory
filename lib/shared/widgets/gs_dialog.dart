import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'gs_button.dart';
import 'gs_text_field.dart';

enum GsDialogVariant { confirm, input }

class GsDialog extends StatefulWidget {
  const GsDialog({
    super.key,
    required this.title,
    this.body,
    this.variant = GsDialogVariant.confirm,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.inputHint,
    this.inputLabel,
  });

  final String title;
  final String? body;
  final GsDialogVariant variant;
  final String confirmLabel;
  final String cancelLabel;
  final ValueChanged<String?>? onConfirm;
  final VoidCallback? onCancel;
  final String? inputHint;
  final String? inputLabel;

  static Future<String?> showConfirm({
    required BuildContext context,
    required String title,
    String? body,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<String?>(
      context: context,
      builder: (_) => GsDialog(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: (_) => Navigator.of(context).pop('confirmed'),
        onCancel: () => Navigator.of(context).pop(null),
      ),
    );
  }

  static Future<String?> showInput({
    required BuildContext context,
    required String title,
    String? inputLabel,
    String? inputHint,
    String confirmLabel = 'Save',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<String?>(
      context: context,
      builder: (_) => GsDialog(
        title: title,
        variant: GsDialogVariant.input,
        inputLabel: inputLabel,
        inputHint: inputHint,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: (value) => Navigator.of(context).pop(value),
        onCancel: () => Navigator.of(context).pop(null),
      ),
    );
  }

  @override
  State<GsDialog> createState() => _GsDialogState();
}

class _GsDialogState extends State<GsDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.surfaceVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.body != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.body!,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
            ],
            if (widget.variant == GsDialogVariant.input) ...[
              const SizedBox(height: 16),
              GsTextField(
                controller: _controller,
                label: widget.inputLabel,
                hint: widget.inputHint,
                autofocus: true,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GsButton(
                  label: widget.cancelLabel,
                  variant: GsButtonVariant.ghost,
                  onPressed: widget.onCancel,
                ),
                const SizedBox(width: 8),
                GsButton(
                  label: widget.confirmLabel,
                  onPressed: () => widget.onConfirm?.call(
                    widget.variant == GsDialogVariant.input
                        ? _controller.text
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
