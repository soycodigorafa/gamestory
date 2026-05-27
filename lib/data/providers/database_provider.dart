import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/app_database.dart';
import '../repositories/drift_condition_repository.dart';
import '../repositories/drift_dialogue_node_repository.dart';
import '../repositories/drift_item_repository.dart';
import '../repositories/drift_milestone_repository.dart';
import '../repositories/drift_project_repository.dart';
import '../sync/no_op_cloud_sync_service.dart';
import '../../domain/repositories/cloud_sync_service.dart';
import '../../domain/repositories/condition_repository.dart';
import '../../domain/repositories/dialogue_node_repository.dart';
import '../../domain/repositories/item_repository.dart';
import '../../domain/repositories/milestone_repository.dart';
import '../../domain/repositories/project_repository.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
ProjectRepository projectRepository(Ref ref) =>
    DriftProjectRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
DialogueNodeRepository dialogueNodeRepository(Ref ref) =>
    DriftDialogueNodeRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
ItemRepository itemRepository(Ref ref) =>
    DriftItemRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
ConditionRepository conditionRepository(Ref ref) =>
    DriftConditionRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
MilestoneRepository milestoneRepository(Ref ref) =>
    DriftMilestoneRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
CloudSyncService cloudSyncService(Ref ref) => const NoOpCloudSyncService();
