import 'package:equatable/equatable.dart';
import 'package:flashcard/features/cloud_sync/domain/entities/sync_status.dart';

abstract class SyncBlocState extends Equatable {
  const SyncBlocState();

  @override
  List<Object?> get props => [];
}

class SyncInitial extends SyncBlocState {
  const SyncInitial();
}

class SyncInProgress extends SyncBlocState {
  const SyncInProgress();
}

class SyncComplete extends SyncBlocState {
  final SyncStatus status;

  const SyncComplete(this.status);

  @override
  List<Object?> get props => [status];
}

class SyncFailed extends SyncBlocState {
  final String message;

  const SyncFailed(this.message);

  @override
  List<Object?> get props => [message];
}
