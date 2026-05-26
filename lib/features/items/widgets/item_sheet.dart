import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/item.dart';
import '../../../shared/widgets/gs_bottom_sheet.dart';
import '../../../shared/widgets/gs_button.dart';
import '../../../shared/widgets/gs_text_field.dart';

class ItemSheet extends StatefulWidget {
  const ItemSheet({super.key, this.item});

  final Item? item;

  static Future<void> show(BuildContext context, {Item? item}) {
    return GsBottomSheet.show(
      context: context,
      title: item == null ? 'Add Item' : 'Edit Item',
      child: ItemSheet(item: item),
    );
  }

  @override
  State<ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends State<ItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descController =
        TextEditingController(text: widget.item?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GsTextField(
          label: 'Item Name',
          hint: 'e.g. Iron Sword',
          controller: _nameController,
          autofocus: !isEdit,
        ),
        const SizedBox(height: 16),
        GsTextField(
          label: 'Description',
          hint: 'What does this item do or represent?',
          controller: _descController,
          multiline: true,
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            if (isEdit) ...[
              GsButton(
                label: 'Delete',
                variant: GsButtonVariant.destructive,
                icon: Icons.delete_outline,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: GsButton(
                label: 'Cancel',
                variant: GsButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GsButton(
                label: isEdit ? 'Save Changes' : 'Add Item',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Changes will be persisted in Milestone 3.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}
