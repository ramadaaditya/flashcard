import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/usecases/usecase.dart';
import 'package:flashcard/features/cloud_sync/domain/entities/sync_status.dart';
import 'package:flashcard/features/cloud_sync/domain/repositories/sync_repository.dart';

class GetSyncStatus extends UseCase<SyncStatus, NoParams> {
  final SyncRepository repository;

  GetSyncStatus(this.repository);

  @override
  Future<Either<Failure, SyncStatus>> call(NoParams params) {
    return repository.getSyncStatus();
  }
}
