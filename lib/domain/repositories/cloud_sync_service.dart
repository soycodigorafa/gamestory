enum SyncStatus { idle, syncing, error }

abstract interface class CloudSyncService {
  Future<void> push(String projectId);
  Future<void> pull(String projectId);
  Stream<SyncStatus> watchStatus(String projectId);
}
