import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/gs_widgets.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Component Catalogue',
          style: TextStyle(color: AppColors.onSurface, fontSize: 16),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.surfaceVariant),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _SectionHeader('GsButton'),
          _GsButtonSection(),
          SizedBox(height: 32),
          _SectionHeader('GsTextField'),
          _GsTextFieldSection(),
          SizedBox(height: 32),
          _SectionHeader('GsCard'),
          _GsCardSection(),
          SizedBox(height: 32),
          _SectionHeader('GsTreeNode'),
          _GsTreeNodeSection(),
          SizedBox(height: 32),
          _SectionHeader('GsBadge'),
          _GsBadgeSection(),
          SizedBox(height: 32),
          _SectionHeader('GsProgressBar'),
          _GsProgressBarSection(),
          SizedBox(height: 32),
          _SectionHeader('GsEmptyState'),
          _GsEmptyStateSection(),
          SizedBox(height: 32),
          _SectionHeader('GsIconButton'),
          _GsIconButtonSection(),
          SizedBox(height: 32),
          _SectionHeader('GsBottomSheet + GsDialog'),
          _GsOverlaySection(),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _GsButtonSection extends StatelessWidget {
  const _GsButtonSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        GsButton(label: 'Primary', onPressed: () {}),
        GsButton(
          label: 'Secondary',
          onPressed: () {},
          variant: GsButtonVariant.secondary,
        ),
        GsButton(
          label: 'Ghost',
          onPressed: () {},
          variant: GsButtonVariant.ghost,
        ),
        GsButton(
          label: 'Destructive',
          onPressed: () {},
          variant: GsButtonVariant.destructive,
        ),
        GsButton(
          label: 'With Icon',
          onPressed: () {},
          icon: Icons.add,
        ),
        const GsButton(label: 'Loading', onPressed: null, isLoading: true),
        const GsButton(label: 'Disabled', onPressed: null),
      ],
    );
  }
}

class _GsTextFieldSection extends StatelessWidget {
  const _GsTextFieldSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GsTextField(label: 'Single-line', hint: 'Enter text…'),
        SizedBox(height: 12),
        GsTextField(
          label: 'With error',
          hint: 'Enter text…',
          error: 'This field is required',
        ),
        SizedBox(height: 12),
        GsTextField(
          label: 'Multiline',
          hint: 'Enter longer text…',
          multiline: true,
        ),
      ],
    );
  }
}

class _GsCardSection extends StatelessWidget {
  const _GsCardSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GsCard(
          child: const Text('Card with border (default)'),
        ),
        const SizedBox(height: 12),
        GsCard(
          showBorder: false,
          child: const Text('Card without border'),
        ),
        const SizedBox(height: 12),
        GsCard(
          onTap: () {},
          actions: [
            GsButton(
              label: 'Action',
              onPressed: () {},
              variant: GsButtonVariant.ghost,
            ),
          ],
          child: const Text('Card with tap + action slot'),
        ),
      ],
    );
  }
}

class _GsTreeNodeSection extends StatelessWidget {
  const _GsTreeNodeSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        children: [
          GsTreeNode(
            label: 'Root node (expanded)',
            hasChildren: true,
            isExpanded: true,
            onToggle: () {},
            onTap: () {},
          ),
          GsTreeNode(
            label: 'Child node (indent 1)',
            indentLevel: 1,
            hasChildren: true,
            isExpanded: false,
            onToggle: () {},
            onTap: () {},
          ),
          GsTreeNode(
            label: 'Child node (indent 2, selected)',
            indentLevel: 2,
            isSelected: true,
            onTap: () {},
          ),
          GsTreeNode(
            label: 'Node with trailing badge',
            indentLevel: 1,
            onTap: () {},
            trailing: const GsBadge(status: GsBadgeStatus.complete),
          ),
        ],
      ),
    );
  }
}

class _GsBadgeSection extends StatelessWidget {
  const _GsBadgeSection();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GsBadge(status: GsBadgeStatus.complete),
        GsBadge(status: GsBadgeStatus.incomplete),
        GsBadge(status: GsBadgeStatus.locked),
        GsBadge(status: GsBadgeStatus.complete, label: 'Custom label'),
      ],
    );
  }
}

class _GsProgressBarSection extends StatelessWidget {
  const _GsProgressBarSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GsProgressBar(progress: 0.0, label: 'Empty'),
        SizedBox(height: 12),
        GsProgressBar(progress: 0.45, label: 'In progress'),
        SizedBox(height: 12),
        GsProgressBar(
          progress: 0.75,
          label: 'With milestones',
          milestoneThresholds: [0.25, 0.5, 0.75, 1.0],
        ),
        SizedBox(height: 12),
        GsProgressBar(progress: 1.0, label: 'Complete'),
      ],
    );
  }
}

class _GsEmptyStateSection extends StatelessWidget {
  const _GsEmptyStateSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: GsEmptyState(
        icon: Icons.description_outlined,
        title: 'No dialogue nodes yet',
        subtitle: 'Create your first node to get started.',
        ctaLabel: 'Add Node',
        onCta: () {},
      ),
    );
  }
}

class _GsIconButtonSection extends StatelessWidget {
  const _GsIconButtonSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GsIconButton(
          icon: Icons.add,
          onPressed: () {},
          tooltip: 'Add',
          size: GsIconButtonSize.small,
        ),
        GsIconButton(
          icon: Icons.edit_outlined,
          onPressed: () {},
          tooltip: 'Edit',
        ),
        GsIconButton(
          icon: Icons.delete_outline,
          onPressed: () {},
          tooltip: 'Delete',
          color: AppColors.error,
          size: GsIconButtonSize.large,
        ),
        GsIconButton(
          icon: Icons.settings_outlined,
          onPressed: null,
          tooltip: 'Disabled',
        ),
      ],
    );
  }
}

class _GsOverlaySection extends StatelessWidget {
  const _GsOverlaySection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        GsButton(
          label: 'Open Bottom Sheet',
          variant: GsButtonVariant.secondary,
          onPressed: () => GsBottomSheet.show(
            context: context,
            title: 'Example Sheet',
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'This is the GsBottomSheet content area.',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ),
        ),
        GsButton(
          label: 'Confirm Dialog',
          variant: GsButtonVariant.secondary,
          onPressed: () => GsDialog.showConfirm(
            context: context,
            title: 'Delete project?',
            body: 'This action cannot be undone.',
            confirmLabel: 'Delete',
          ),
        ),
        GsButton(
          label: 'Input Dialog',
          variant: GsButtonVariant.secondary,
          onPressed: () => GsDialog.showInput(
            context: context,
            title: 'New Project',
            inputLabel: 'Project name',
            inputHint: 'My Narrative…',
          ),
        ),
      ],
    );
  }
}
