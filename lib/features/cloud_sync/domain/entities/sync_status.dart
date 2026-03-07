import 'package:equatable/equatable.dart';

enum SyncState { idle, syncing, synced, error }

class SyncStatus extends Equatable {
  final SyncState state;
  final DateTime? lastSyncedAt;
  final String? errorMessage;
  final int pendingChanges;

  const SyncStatus({
    this.state = SyncState.idle,
    this.lastSyncedAt,
    this.errorMessage,
    this.pendingChanges = 0,
  });

  @override
  List<Object?> get props => [state, lastSyncedAt, errorMessage, pendingChanges];
}
