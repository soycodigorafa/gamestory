import '../../domain/repositories/cloud_sync_service.dart';

class NoOpCloudSyncService implements CloudSyncService {
  const NoOpCloudSyncService();

  @override
  Future<void> push(String projectId) async {}

  @override
  Future<void> pull(String projectId) async {}

  @override
  Stream<SyncStatus> watchStatus(String projectId) =>
      Stream.value(SyncStatus.idle);
}
