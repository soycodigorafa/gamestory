import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaybackScreen extends ConsumerWidget {
  const PlaybackScreen({super.key, required this.npcId});

  final String npcId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Playback — NPC $npcId')),
      body: const Center(
        child: Text('Playback — coming in M5'),
      ),
    );
  }
}
