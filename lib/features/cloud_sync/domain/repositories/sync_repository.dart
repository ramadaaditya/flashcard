import 'package:flashcard/core/utils/typedefs.dart';
import 'package:flashcard/features/cloud_sync/domain/entities/sync_status.dart';

abstract class SyncRepository {
  ResultFuture<SyncStatus> syncAll();

  ResultFuture<SyncStatus> getSyncStatus();

  ResultVoid syncTasks();

  ResultVoid syncFocusSessions();

  ResultVoid syncAnalytics();

  ResultFuture<DateTime?> getLastSyncTime();
}
