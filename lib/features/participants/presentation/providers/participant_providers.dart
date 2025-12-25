import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/hive_init.dart';
import '../../data/datasources/participant_local_data_source.dart';
import '../../data/repositories/participant_repository_impl.dart';
import '../../domain/entities/participant.dart';
import '../../domain/repositories/participant_repository.dart';
import '../../domain/usecases/add_participant.dart';
import '../../domain/usecases/get_participants.dart';
import '../../domain/usecases/remove_participant.dart';
import '../../domain/usecases/validate_participant.dart';

part 'participant_providers.g.dart';

/// Provider for participants Hive box
@riverpod
Box<dynamic> participantsBox(Ref ref) {
  return HiveInit.participantsBox;
}

/// Provider for participant local data source
@riverpod
ParticipantLocalDataSource participantLocalDataSource(Ref ref) {
  final box = ref.watch(participantsBoxProvider);
  return ParticipantLocalDataSourceImpl(box);
}

/// Provider for participant repository
@riverpod
ParticipantRepository participantRepository(Ref ref) {
  final dataSource = ref.watch(participantLocalDataSourceProvider);
  return ParticipantRepositoryImpl(dataSource);
}

/// Provider for GetParticipants use case
@riverpod
GetParticipants getParticipants(Ref ref) {
  final repository = ref.watch(participantRepositoryProvider);
  return GetParticipants(repository);
}

/// Provider for AddParticipant use case
@riverpod
AddParticipant addParticipant(Ref ref) {
  final repository = ref.watch(participantRepositoryProvider);
  final validateParticipant = ValidateParticipant();
  return AddParticipant(repository, validateParticipant);
}

/// Provider for RemoveParticipant use case
@riverpod
RemoveParticipant removeParticipant(Ref ref) {
  final repository = ref.watch(participantRepositoryProvider);
  return RemoveParticipant(repository);
}

/// Provider for ValidateParticipant use case
@riverpod
ValidateParticipant validateParticipant(Ref ref) {
  return ValidateParticipant();
}

/// Provider for participants list
@riverpod
Future<List<Participant>> participants(Ref ref) async {
  final getParticipants = ref.watch(getParticipantsProvider);
  final result = await getParticipants();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (participants) => participants,
  );
}

/// Provider for participants filtered by event ID
@riverpod
Future<List<Participant>> participantsByEvent(Ref ref, String eventId) async {
  final repository = ref.watch(participantRepositoryProvider);
  final result = await repository.getParticipantsByEventId(eventId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (participants) => participants,
  );
}
