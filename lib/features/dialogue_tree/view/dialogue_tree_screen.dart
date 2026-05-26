import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../shared/utils/stub_data.dart';
import '../../../shared/widgets/gs_badge.dart';
import '../../../shared/widgets/gs_button.dart';
import '../../../shared/widgets/gs_empty_state.dart';
import '../../../shared/widgets/gs_tree_node.dart';
import '../widgets/node_detail_sheet.dart';

class DialogueTreeScreen extends StatefulWidget {
  const DialogueTreeScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<DialogueTreeScreen> createState() => _DialogueTreeScreenState();
}

class _DialogueTreeScreenState extends State<DialogueTreeScreen> {
  late List<DialogueNode> _nodes;
  final Set<String> _expandedIds = {};
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _nodes = StubData.nodesForProject(widget.projectId);
    _expandedIds.addAll(
      _nodes.where((n) => n.parentId == null).map((n) => n.id),
    );
  }

  List<DialogueNode> get _roots =>
      _nodes.where((n) => n.parentId == null).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<DialogueNode> _childrenOf(String parentId) =>
      _nodes.where((n) => n.parentId == parentId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  bool _hasChildren(String id) => _nodes.any((n) => n.parentId == id);

  void _toggle(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  void _select(DialogueNode node) {
    setState(() => _selectedId = node.id);
    NodeDetailSheet.show(
      context,
      node: node,
      projectId: widget.projectId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _nodes.isEmpty
          ? GsEmptyState(
              title: 'No dialogue nodes',
              subtitle: 'Add your first node to start building the tree.',
              icon: Icons.account_tree_outlined,
              ctaLabel: 'Add Root Node',
              onCta: () {},
            )
          : Column(
              children: [
                _TreeToolbar(
                  nodeCount: _nodes.length,
                  onAddRoot: () {},
                ),
                const Divider(height: 1, color: AppColors.surfaceVariant),
                Expanded(
                  child: ListView(
                    children: [
                      for (final root in _roots) ...[
                        _buildNode(root, 0),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNode(DialogueNode node, int depth) {
    final hasChildren = _hasChildren(node.id);
    final isExpanded = _expandedIds.contains(node.id);
    final isSelected = _selectedId == node.id;
    final hasUnlocks = node.unlockedItemIds.isNotEmpty;
    final hasConditions = node.conditionIds.isNotEmpty;
    final isComplete = hasUnlocks || hasConditions;

    final trailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GsBadge(
          status: isComplete
              ? GsBadgeStatus.complete
              : GsBadgeStatus.incomplete,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GsTreeNode(
          label: '${node.speakerName}: ${node.dialogueText}',
          indentLevel: depth,
          isExpanded: isExpanded,
          hasChildren: hasChildren,
          isSelected: isSelected,
          onToggle: () => _toggle(node.id),
          onTap: () => _select(node),
          trailing: trailing,
        ),
        if (isExpanded)
          for (final child in _childrenOf(node.id))
            _buildNode(child, depth + 1),
      ],
    );
  }
}

class _TreeToolbar extends StatelessWidget {
  const _TreeToolbar({
    required this.nodeCount,
    required this.onAddRoot,
  });

  final int nodeCount;
  final VoidCallback onAddRoot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            '$nodeCount node${nodeCount == 1 ? '' : 's'}',
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const Spacer(),
          GsButton(
            label: 'Add Node',
            icon: Icons.add,
            variant: GsButtonVariant.secondary,
            onPressed: onAddRoot,
          ),
        ],
      ),
    );
  }
}
