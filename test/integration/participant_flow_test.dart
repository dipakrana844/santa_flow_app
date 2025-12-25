import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../lib/core/utils/hive_init.dart';
import '../../lib/features/participants/data/datasources/participant_local_data_source.dart';
import '../../lib/features/participants/data/models/participant_model.dart';
import '../../lib/features/participants/data/repositories/participant_repository_impl.dart';
import '../../lib/features/participants/domain/entities/participant.dart';
import '../../lib/features/participants/domain/usecases/add_participant.dart';
import '../../lib/features/participants/domain/usecases/get_participants.dart';
import '../../lib/features/participants/domain/usecases/remove_participant.dart';
import '../../lib/features/participants/domain/usecases/validate_participant.dart';
import '../helpers/hive_test_helper.dart';
import '../helpers/mock_data.dart';

void main() {
  late Box<dynamic> testBox;
  late ParticipantLocalDataSource dataSource;
  late ParticipantRepositoryImpl repository;
  late GetParticipants getParticipants;
  late AddParticipant addParticipant;
  late RemoveParticipant removeParticipant;

  setUpAll(() async {
    await HiveTestHelper.init();
  });

  setUp(() async {
    testBox = await HiveTestHelper.createTestBox('test_participants');
    dataSource = ParticipantLocalDataSourceImpl(testBox);
    repository = ParticipantRepositoryImpl(dataSource);
    getParticipants = GetParticipants(repository);
    addParticipant = AddParticipant(repository, ValidateParticipant());
    removeParticipant = RemoveParticipant(repository);
  });

  tearDown(() async {
    await HiveTestHelper.clearBox(testBox);
    await HiveTestHelper.closeBox(testBox);
  });

  tearDownAll(() async {
    await HiveTestHelper.cleanup();
  });

  group('Participant Flow Integration Tests', () {
    test('should add, retrieve, and remove participants', () async {
      // Arrange
      final participant = MockDataFactory.createParticipant(
        name: 'Test User',
        email: 'test@example.com',
      );

      // Act - Add participant
      final addResult = await addParticipant(participant);
      expect(addResult.isRight(), true);

      // Act - Get participants
      final getResult = await getParticipants();
      expect(getResult.isRight(), true);

      getResult.fold((failure) => fail('Should not fail'), (participants) {
        expect(participants.length, 1);
        expect(participants[0].name, 'Test User');
        expect(participants[0].email, 'test@example.com');
      });

      // Act - Remove participant
      final removeResult = await removeParticipant(participant.id);
      expect(removeResult.isRight(), true);

      // Act - Verify removed
      final getAfterRemove = await getParticipants();
      getAfterRemove.fold(
        (failure) => fail('Should not fail'),
        (participants) => expect(participants.isEmpty, true),
      );
    });

    test('should handle multiple participants', () async {
      // Arrange
      final participants = MockDataFactory.createParticipants(count: 5);

      // Act - Add all participants
      for (final participant in participants) {
        final result = await addParticipant(participant);
        expect(result.isRight(), true);
      }

      // Act - Get all participants
      final getResult = await getParticipants();
      expect(getResult.isRight(), true);

      getResult.fold(
        (failure) => fail('Should not fail'),
        (retrieved) => expect(retrieved.length, 5),
      );
    });
  });
}
