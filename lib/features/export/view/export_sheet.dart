import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/export_provider.dart';

class ExportSheet extends ConsumerWidget {
  const ExportSheet({super.key, required this.npcId});

  final String npcId;

  static Future<void> show(BuildContext context, {required String npcId}) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => ExportSheet(npcId: npcId),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportProvider);
    final isLoading = exportState.isLoading;

    ref.listen(exportProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Text(
                    'Export dialogue',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.data_object_outlined),
              title: const Text('Export as JSON'),
              subtitle: const Text('.gamestory.json — full graph, importable'),
              enabled: !isLoading,
              onTap: () async {
                await ref.read(exportProvider.notifier).exportJson(npcId);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Export as CSV'),
              subtitle: const Text('.csv — flat dialogue table for spreadsheets'),
              enabled: !isLoading,
              onTap: () async {
                await ref.read(exportProvider.notifier).exportCsv(npcId);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
