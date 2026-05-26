import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/utils/stub_data.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../shared/widgets/gs_button.dart';
import '../../conditions/view/conditions_screen.dart';
import '../../dialogue_tree/view/dialogue_tree_screen.dart';
import '../../items/view/items_screen.dart';
import '../../milestones/view/milestones_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    (label: 'Tree', icon: Icons.account_tree_outlined),
    (label: 'Items', icon: Icons.inventory_2_outlined),
    (label: 'Conditions', icon: Icons.rule_outlined),
    (label: 'Milestones', icon: Icons.flag_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  List<DialogueNode> _rootNodes(String projectId) =>
      StubData.nodesForProject(projectId)
          .where((n) => n.parentId == null)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = StubData.projects.firstWhere(
      (p) => p.id == widget.projectId,
      orElse: () => StubData.projects.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (_rootNodes(widget.projectId).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GsButton(
                label: 'Play',
                icon: Icons.play_arrow,
                variant: GsButtonVariant.primary,
                onPressed: () => context.push(
                  AppRoutes.playbackPath(
                    widget.projectId,
                    _rootNodes(widget.projectId).first.id,
                  ),
                ),
              ),
            ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              project.description,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.muted,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: AppColors.surfaceVariant,
          tabs: [
            for (final tab in _tabs)
              Tab(
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tab.icon, size: 16),
                    const SizedBox(width: 6),
                    Text(tab.label, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DialogueTreeScreen(projectId: widget.projectId),
          ItemsScreen(projectId: widget.projectId),
          ConditionsScreen(projectId: widget.projectId),
          MilestonesScreen(projectId: widget.projectId),
        ],
      ),
    );
  }
}
