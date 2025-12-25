import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/match_local_data_source.dart';
import '../../data/repositories/match_repository_impl.dart';
import '../../domain/entities/secret_santa_match.dart';
import '../../domain/repositories/match_repository.dart';
import '../../domain/usecases/generate_matches.dart';
import '../../../../core/utils/hive_init.dart';

part 'matching_providers.g.dart';

/// Provider for matches Hive box
@riverpod
Box<dynamic> matchesBox(Ref ref) {
  return HiveInit.matchesBox;
}

/// Provider for match local data source
@riverpod
MatchLocalDataSource matchLocalDataSource(Ref ref) {
  final box = ref.watch(matchesBoxProvider);
  return MatchLocalDataSourceImpl(box);
}

/// Provider for match repository
@riverpod
MatchRepository matchRepository(Ref ref) {
  final dataSource = ref.watch(matchLocalDataSourceProvider);
  return MatchRepositoryImpl(dataSource);
}

/// Provider for GenerateMatches use case
@riverpod
GenerateMatches generateMatches(Ref ref) {
  return GenerateMatches();
}

/// Provider for matches list by event
@riverpod
Future<List<SecretSantaMatch>> matchesByEvent(Ref ref, String eventId) async {
  final repository = ref.watch(matchRepositoryProvider);
  final result = await repository.getMatchesByEventId(eventId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (matches) => matches,
  );
}
