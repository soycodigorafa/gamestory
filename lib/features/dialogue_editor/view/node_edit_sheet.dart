import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/dialogue_choice.dart';
import '../../../domain/entities/dialogue_node.dart';
import '../../../shared/widgets/gs_text_field.dart';
import '../providers/dialogue_graph_provider.dart';
import 'node_picker_modal.dart';
import 'requirement_flag_sheet.dart';

class NodeEditSheet extends ConsumerStatefulWidget {
  const NodeEditSheet({
    super.key,
    required this.node,
    required this.choices,
    required this.npcId,
    required this.allNodes,
  });

  final DialogueNode node;
  final List<DialogueChoice> choices;
  final String npcId;
  final List<DialogueNode> allNodes;

  static Future<void> show(
    BuildContext context, {
    required DialogueNode node,
    required List<DialogueChoice> choices,
    required String npcId,
    required List<DialogueNode> allNodes,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => NodeEditSheet(
        node: node,
        choices: choices,
        npcId: npcId,
        allNodes: allNodes,
      ),
    );
  }

  @override
  ConsumerState<NodeEditSheet> createState() => _NodeEditSheetState();
}

class _NodeEditSheetState extends ConsumerState<NodeEditSheet> {
  late final TextEditingController _speakerCtrl;
  late final TextEditingController _dialogueCtrl;
  final List<_ChoiceState> _choices = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _speakerCtrl = TextEditingController(text: widget.node.speakerName);
    _dialogueCtrl = TextEditingController(text: widget.node.dialogueText);
    _choices.addAll(widget.choices.map(_ChoiceState.from));
  }

  @override
  void dispose() {
    _speakerCtrl.dispose();
    _dialogueCtrl.dispose();
    for (final c in _choices) {
      c.textCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: mutedColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Edit Node',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GsTextField(
              controller: _speakerCtrl,
              label: 'Speaker',
              hint: 'e.g. Village Elder',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dialogueCtrl,
              maxLines: 4,
              minLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                labelText: 'Dialogue text',
                hintText: 'What does the character say?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Choices',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  onPressed: _addChoice,
                ),
              ],
            ),
            const SizedBox(height: 4),
            ..._choices
                .asMap()
                .entries
                .map((e) => _buildChoiceRow(e.key, e.value)),
            if (_choices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No choices — this is a leaf node.',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceRow(int index, _ChoiceState choice) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    final targetNode = choice.targetNodeId != null
        ? widget.allNodes
            .where((n) => n.id == choice.targetNodeId)
            .firstOrNull
        : null;
    final targetLabel =
        targetNode?.speakerName.isEmpty == true ? 'Unnamed' : targetNode?.speakerName;

    final hasSavedId = choice.originalId != null;
    final flagsAsync = hasSavedId
        ? ref.watch(requirementFlagsByChoiceProvider(choice.originalId!))
        : null;
    final hasFlags =
        flagsAsync?.valueOrNull?.isNotEmpty == true;

    return Padding(
      key: ValueKey(choice.key),
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${index + 1}.',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: choice.textCtrl,
              decoration: const InputDecoration(
                hintText: 'Choice text',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 6),
          OutlinedButton(
            onPressed: () => _pickTarget(index, choice),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              targetLabel ?? '+ node',
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 2),
          IconButton(
            icon: Icon(
              hasFlags ? Icons.lock_rounded : Icons.lock_outline,
              size: 16,
              color: hasSavedId
                  ? (hasFlags ? primary : mutedColor)
                  : mutedColor.withValues(alpha: 0.4),
            ),
            tooltip: hasSavedId ? 'Requirement flags' : 'Save first to add flags',
            onPressed: hasSavedId
                ? () => RequirementFlagSheet.show(
                      context,
                      choiceId: choice.originalId!,
                      choiceText: choice.textCtrl.text,
                    )
                : null,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => _removeChoice(index, choice),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Future<void> _removeChoice(int index, _ChoiceState choice) async {
    if (choice.originalId != null) {
      await ref
          .read(requirementFlagRepositoryProvider)
          .deleteByChoiceId(choice.originalId!);
    }
    setState(() => _choices.removeAt(index));
  }

  Future<void> _pickTarget(int index, _ChoiceState choice) async {
    final result = await NodePickerModal.show(
      context,
      allNodes: widget.allNodes,
      currentNodeId: widget.node.id,
      selectedNodeId: choice.targetNodeId,
    );
    if (result == null) return;
    setState(() {
      _choices[index].targetNodeId = result.isEmpty ? null : result;
    });
  }

  void _addChoice() {
    setState(() {
      _choices.add(_ChoiceState(sortOrder: _choices.length));
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final nodeRepo = ref.read(dialogueNodeRepositoryProvider);
      final choiceRepo = ref.read(dialogueChoiceRepositoryProvider);

      await nodeRepo.update(UpdateNodeInput(
        id: widget.node.id,
        speakerName: _speakerCtrl.text.trim(),
        dialogueText: _dialogueCtrl.text.trim(),
      ));

      final existingIds = widget.choices.map((c) => c.id).toSet();
      final keptIds = _choices
          .where((c) => c.originalId != null)
          .map((c) => c.originalId!)
          .toSet();

      final flagRepo = ref.read(requirementFlagRepositoryProvider);
      for (final id in existingIds.difference(keptIds)) {
        await flagRepo.deleteByChoiceId(id);
        await choiceRepo.delete(id);
      }

      for (int i = 0; i < _choices.length; i++) {
        final c = _choices[i];
        final text = c.textCtrl.text.trim();
        if (c.originalId != null) {
          await choiceRepo.update(UpdateChoiceInput(
            id: c.originalId!,
            choiceText: text,
            sortOrder: i,
            toNodeId: c.targetNodeId,
            clearToNodeId: c.targetNodeId == null,
          ));
        } else {
          await choiceRepo.create(CreateChoiceInput(
            fromNodeId: widget.node.id,
            choiceText: text,
            sortOrder: i,
            toNodeId: c.targetNodeId,
          ));
        }
      }

      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _ChoiceState {
  _ChoiceState({
    this.originalId,
    required this.sortOrder,
    String? initialText,
    this.targetNodeId,
  })  : textCtrl = TextEditingController(text: initialText ?? ''),
        key = UniqueKey();

  factory _ChoiceState.from(DialogueChoice choice) => _ChoiceState(
        originalId: choice.id,
        sortOrder: choice.sortOrder,
        initialText: choice.choiceText,
        targetNodeId: choice.toNodeId,
      );

  final String? originalId;
  final int sortOrder;
  final TextEditingController textCtrl;
  String? targetNodeId;
  final Key key;
}
