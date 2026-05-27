import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogueEditorScreen extends ConsumerWidget {
  const DialogueEditorScreen({super.key, required this.npcId});

  final String npcId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Dialogue Editor — NPC $npcId')),
      body: const Center(
        child: Text('Dialogue Editor — coming in M3'),
      ),
    );
  }
}
