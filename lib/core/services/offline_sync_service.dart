class OfflineSyncService {
  Future<void> syncPendingChanges() async {
    // Sync all pending changes to server
  }

  Future<void> savePendingExpense(Map<String, dynamic> expense) async {
    // Save expense locally for later sync
  }

  Future<List<Map<String, dynamic>>> getPendingChanges() async {
    // Get all pending changes
    return [];
  }

  Future<bool> isOnline() async {
    // Check internet connectivity
    return true;
  }

  Future<void> clearSyncedData() async {
    // Clear synced data from local storage
  }
}
