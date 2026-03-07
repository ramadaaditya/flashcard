abstract class SyncRemoteDataSource {
  Future<void> uploadTasks(List<Map<String, dynamic>> tasks);
  Future<List<Map<String, dynamic>>> downloadTasks();
  Future<void> uploadFocusSessions(List<Map<String, dynamic>> sessions);
  Future<List<Map<String, dynamic>>> downloadFocusSessions();
  Future<void> uploadAnalytics(List<Map<String, dynamic>> analytics);
  Future<List<Map<String, dynamic>>> downloadAnalytics();
}

/// TODO: Replace with actual cloud implementation (e.g., Firebase, Supabase)
class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  @override
  Future<void> uploadTasks(List<Map<String, dynamic>> tasks) async {
    throw UnimplementedError('Connect to your cloud backend');
  }

  @override
  Future<List<Map<String, dynamic>>> downloadTasks() async {
    throw UnimplementedError('Connect to your cloud backend');
  }

  @override
  Future<void> uploadFocusSessions(List<Map<String, dynamic>> sessions) async {
    throw UnimplementedError('Connect to your cloud backend');
  }

  @override
  Future<List<Map<String, dynamic>>> downloadFocusSessions() async {
    throw UnimplementedError('Connect to your cloud backend');
  }

  @override
  Future<void> uploadAnalytics(List<Map<String, dynamic>> analytics) async {
    throw UnimplementedError('Connect to your cloud backend');
  }

  @override
  Future<List<Map<String, dynamic>>> downloadAnalytics() async {
    throw UnimplementedError('Connect to your cloud backend');
  }
}
