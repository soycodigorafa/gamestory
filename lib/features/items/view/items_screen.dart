import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/item.dart';
import '../../../shared/utils/stub_data.dart';
import '../../../shared/widgets/gs_button.dart';
import '../../../shared/widgets/gs_card.dart';
import '../../../shared/widgets/gs_empty_state.dart';
import '../widgets/item_sheet.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final items = StubData.itemsForProject(projectId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: items.isEmpty
          ? GsEmptyState(
              title: 'No items yet',
              subtitle:
                  'Define items that dialogue nodes can unlock during gameplay.',
              icon: Icons.inventory_2_outlined,
              ctaLabel: 'Add Item',
              onCta: () => ItemSheet.show(context),
            )
          : _ItemList(items: items, projectId: projectId),
      floatingActionButton: items.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              tooltip: 'Add Item',
              onPressed: () => ItemSheet.show(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({required this.items, required this.projectId});

  final List<Item> items;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _ItemRow(
        item: items[i],
        onTap: () => ItemSheet.show(context, item: items[i]),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.onTap});

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GsCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.secondary,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          GsButton(
            label: 'Edit',
            variant: GsButtonVariant.ghost,
            icon: Icons.edit_outlined,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
