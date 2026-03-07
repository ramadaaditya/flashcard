import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class SyncRequested extends SyncEvent {
  const SyncRequested();
}

class CheckSyncStatus extends SyncEvent {
  const CheckSyncStatus();
}
