import 'package:dartz/dartz.dart';
import 'package:flashcard/core/error/failures.dart';
import 'package:flashcard/core/network/network_info.dart';
import 'package:flashcard/features/cloud_sync/data/datasources/sync_local_datasource.dart';
import 'package:flashcard/features/cloud_sync/domain/entities/sync_status.dart';
import 'package:flashcard/features/cloud_sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final SyncLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SyncRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SyncStatus>> syncAll() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      // TODO: Implement actual sync logic with remote datasource
      await localDataSource.saveLastSyncTime(DateTime.now());
      return Right(SyncStatus(
        state: SyncState.synced,
        lastSyncedAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SyncStatus>> getSyncStatus() async {
    try {
      final lastSync = await localDataSource.getLastSyncTime();
      return Right(SyncStatus(
        state: lastSync != null ? SyncState.synced : SyncState.idle,
        lastSyncedAt: lastSync,
      ));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncTasks() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    // TODO: Implement task sync
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> syncFocusSessions() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    // TODO: Implement focus session sync
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> syncAnalytics() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    // TODO: Implement analytics sync
    return const Right(null);
  }

  @override
  Future<Either<Failure, DateTime?>> getLastSyncTime() async {
    try {
      final time = await localDataSource.getLastSyncTime();
      return Right(time);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
