import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class GsTextField extends StatelessWidget {
  const GsTextField({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.onChanged,
    this.multiline = false,
    this.autofocus = false,
    this.enabled = true,
  });

  final String? label;
  final String? hint;
  final String? error;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool multiline;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: multiline ? null : 1,
      minLines: multiline ? 3 : 1,
      keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
      autofocus: autofocus,
      enabled: enabled,
      style: const TextStyle(color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: error,
      ),
    );
  }
}
