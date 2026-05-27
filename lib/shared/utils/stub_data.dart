import '../../domain/entities/condition.dart';
import '../../domain/entities/dialogue_node.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/milestone.dart';
import '../../domain/entities/project.dart';

abstract final class StubData {
  static final List<Project> projects = [
    Project(
      id: 'proj_1',
      name: 'The Forgotten Kingdom',
      description:
          'An epic fantasy RPG with branching political intrigue and multiple endings.',
      createdAt: DateTime(2025, 1, 10),
      updatedAt: DateTime(2025, 3, 22),
    ),
    Project(
      id: 'proj_2',
      name: 'Neon Citadel',
      description:
          'Cyberpunk noir thriller — hacker protagonist unravels a corporate conspiracy.',
      createdAt: DateTime(2025, 2, 5),
      updatedAt: DateTime(2025, 4, 14),
    ),
    Project(
      id: 'proj_3',
      name: 'Verdant Echoes',
      description:
          'Cozy exploration game with a cast of woodland spirits and ancient puzzles.',
      createdAt: DateTime(2025, 4, 1),
      updatedAt: DateTime(2025, 5, 10),
    ),
  ];

  static List<DialogueNode> nodesForProject(String projectId) => [
        DialogueNode(
          id: 'node_1',
          projectId: projectId,
          parentId: null,
          speakerName: 'NPC_Blacksmith',
          dialogueText: 'Welcome, traveller. What brings you to my forge?',
          sortOrder: 0,
          unlockedItemIds: ['item_1'],
          conditionIds: [],
        ),
        DialogueNode(
          id: 'node_2',
          projectId: projectId,
          parentId: 'node_1',
          speakerName: 'Player',
          dialogueText: "I'm looking for the legendary blade.",
          sortOrder: 0,
          unlockedItemIds: [],
          conditionIds: ['cond_1'],
        ),
        DialogueNode(
          id: 'node_3',
          projectId: projectId,
          parentId: 'node_1',
          speakerName: 'Player',
          dialogueText: 'Just browsing your wares.',
          sortOrder: 1,
          unlockedItemIds: [],
          conditionIds: [],
        ),
        DialogueNode(
          id: 'node_4',
          projectId: projectId,
          parentId: 'node_2',
          speakerName: 'NPC_Blacksmith',
          dialogueText:
              "The Stormcleaver? Aye, I know of it. But you'll need the crest first.",
          sortOrder: 0,
          unlockedItemIds: ['item_2'],
          conditionIds: ['cond_1', 'cond_2'],
        ),
        DialogueNode(
          id: 'node_5',
          projectId: projectId,
          parentId: 'node_3',
          speakerName: 'NPC_Blacksmith',
          dialogueText: 'Take your time. Everything here is hand-forged.',
          sortOrder: 0,
          unlockedItemIds: [],
          conditionIds: [],
        ),
        DialogueNode(
          id: 'node_6',
          projectId: projectId,
          parentId: null,
          speakerName: 'Guard_Captain',
          dialogueText: 'Halt! State your business at the city gates.',
          sortOrder: 1,
          unlockedItemIds: [],
          conditionIds: ['cond_2'],
        ),
      ];

  static List<Item> itemsForProject(String projectId) => [
        Item(
          id: 'item_1',
          projectId: projectId,
          name: 'Forge Pass',
          description: 'Grants access to the master forge room.',
        ),
        Item(
          id: 'item_2',
          projectId: projectId,
          name: 'Stormcleaver Blueprint',
          description: 'Schematics for the legendary sword Stormcleaver.',
        ),
        Item(
          id: 'item_3',
          projectId: projectId,
          name: 'City Crest',
          description: 'Official crest of the city — grants passage through checkpoints.',
        ),
      ];

  static List<Condition> conditionsForProject(String projectId) => [
        Condition(
          id: 'cond_1',
          projectId: projectId,
          expression: 'quest_started == true',
          conditionType: ConditionType.flag,
        ),
        Condition(
          id: 'cond_2',
          projectId: projectId,
          expression: 'player.reputation >= 50',
          conditionType: ConditionType.stat,
        ),
        Condition(
          id: 'cond_3',
          projectId: projectId,
          expression: 'inventory.contains("city_crest")',
          conditionType: ConditionType.inventory,
        ),
      ];

  static List<Milestone> milestonesForProject(String projectId) => [
        Milestone(
          id: 'ms_1',
          projectId: projectId,
          label: 'First Steps',
          targetCount: 25,
          completedAt: DateTime(2025, 2, 1),
        ),
        Milestone(
          id: 'ms_2',
          projectId: projectId,
          label: 'Halfway There',
          targetCount: 50,
          completedAt: DateTime(2025, 3, 15),
        ),
        Milestone(
          id: 'ms_3',
          projectId: projectId,
          label: 'Almost Complete',
          targetCount: 75,
          completedAt: null,
        ),
        Milestone(
          id: 'ms_4',
          projectId: projectId,
          label: 'Narrative Complete',
          targetCount: 100,
          completedAt: null,
        ),
      ];

  static double progressForProject(String projectId) {
    final nodes = nodesForProject(projectId);
    if (nodes.isEmpty) return 0.0;
    final completed = nodes
        .where((n) => n.unlockedItemIds.isNotEmpty || n.conditionIds.isNotEmpty)
        .length;
    return completed / nodes.length;
  }
}
