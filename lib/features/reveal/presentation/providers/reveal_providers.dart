import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/hive_init.dart';
import '../../data/datasources/reveal_token_local_data_source.dart';
import '../../data/repositories/reveal_token_repository_impl.dart';
import '../../domain/repositories/reveal_token_repository.dart';
import '../../domain/usecases/validate_reveal_token.dart';
import '../../domain/usecases/get_match_by_token.dart';
import '../../data/datasources/reveal_history_local_data_source.dart';
import '../../data/repositories/reveal_history_repository_impl.dart';
import '../../domain/repositories/reveal_history_repository.dart';
import '../../domain/entities/reveal_history.dart';
import '../../../matching/presentation/providers/matching_providers.dart';

part 'reveal_providers.g.dart';

/// Provider for reveal tokens Hive box
@riverpod
Box<dynamic> revealTokensBox(Ref ref) {
  return HiveInit.revealTokensBox;
}

/// Provider for reveal token local data source
@riverpod
RevealTokenLocalDataSource revealTokenLocalDataSource(Ref ref) {
  final box = ref.watch(revealTokensBoxProvider);
  return RevealTokenLocalDataSourceImpl(box);
}

/// Provider for reveal token repository
@riverpod
RevealTokenRepository revealTokenRepository(Ref ref) {
  final dataSource = ref.watch(revealTokenLocalDataSourceProvider);
  return RevealTokenRepositoryImpl(dataSource);
}

/// Provider for ValidateRevealToken use case
@riverpod
ValidateRevealToken validateRevealToken(Ref ref) {
  final repository = ref.watch(revealTokenRepositoryProvider);
  return ValidateRevealToken(repository);
}

/// Provider for GetMatchByToken use case
@riverpod
GetMatchByToken getMatchByToken(Ref ref) {
  final revealTokenRepository = ref.watch(revealTokenRepositoryProvider);
  final matchRepository = ref.watch(matchRepositoryProvider);
  return GetMatchByToken(revealTokenRepository, matchRepository);
}

/// Provider for reveal history Hive box
@riverpod
Box<dynamic> revealHistoryBox(Ref ref) {
  return HiveInit.revealHistoryBox;
}

/// Provider for reveal history local data source
@riverpod
RevealHistoryLocalDataSource revealHistoryLocalDataSource(Ref ref) {
  final box = ref.watch(revealHistoryBoxProvider);
  return RevealHistoryLocalDataSourceImpl(box);
}

/// Provider for reveal history repository
@riverpod
RevealHistoryRepository revealHistoryRepository(Ref ref) {
  final dataSource = ref.watch(revealHistoryLocalDataSourceProvider);
  return RevealHistoryRepositoryImpl(dataSource);
}

/// Provider for reveal history list
@riverpod
Future<List<RevealHistory>> revealHistory(Ref ref) async {
  final repository = ref.watch(revealHistoryRepositoryProvider);
  final result = await repository.getHistory();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (history) => history,
  );
}
