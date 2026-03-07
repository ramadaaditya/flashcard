import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/cloud_sync/domain/usecases/get_sync_status.dart';
import 'package:flashcard/features/cloud_sync/domain/usecases/sync_data.dart';
import 'package:flashcard/features/cloud_sync/presentation/bloc/sync_event.dart';
import 'package:flashcard/features/cloud_sync/presentation/bloc/sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncBlocState> {
  final SyncData _syncData;
  final GetSyncStatus _getSyncStatus;

  SyncBloc({
    required SyncData syncData,
    required GetSyncStatus getSyncStatus,
  })  : _syncData = syncData,
        _getSyncStatus = getSyncStatus,
        super(const SyncInitial()) {
    on<SyncRequested>(_onSyncRequested);
    on<CheckSyncStatus>(_onCheckStatus);
  }

  Future<void> _onSyncRequested(
    SyncRequested event,
    Emitter<SyncBlocState> emit,
  ) async {
    emit(const SyncInProgress());
    final result = await _syncData(const NoParams());
    result.fold(
      (failure) => emit(SyncFailed(failure.message)),
      (status) => emit(SyncComplete(status)),
    );
  }

  Future<void> _onCheckStatus(
    CheckSyncStatus event,
    Emitter<SyncBlocState> emit,
  ) async {
    final result = await _getSyncStatus(const NoParams());
    result.fold(
      (failure) => emit(SyncFailed(failure.message)),
      (status) => emit(SyncComplete(status)),
    );
  }
}
