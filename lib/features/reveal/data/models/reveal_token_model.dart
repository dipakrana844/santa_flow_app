import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/reveal_token.dart';

part 'reveal_token_model.freezed.dart';
part 'reveal_token_model.g.dart';

/// Data model for RevealToken with Freezed and JSON serialization
@freezed
abstract class RevealTokenModel with _$RevealTokenModel {
  const factory RevealTokenModel({
    required String id,
    required String participantId,
    required String matchId,
    required String token,
    required DateTime expiresAt,
    @Default(false) bool isRevealed,
    DateTime? revealedAt,
  }) = _RevealTokenModel;

  factory RevealTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RevealTokenModelFromJson(json);
}

/// Extension to convert between Model and Entity
extension RevealTokenModelX on RevealTokenModel {
  /// Convert model to domain entity
  RevealToken toEntity() {
    return RevealToken(
      id: id,
      participantId: participantId,
      matchId: matchId,
      token: token,
      expiresAt: expiresAt,
      isRevealed: isRevealed,
      revealedAt: revealedAt,
    );
  }
}

/// Extension to convert Entity to Model
extension RevealTokenEntityX on RevealToken {
  /// Convert entity to data model
  RevealTokenModel toModel() {
    return RevealTokenModel(
      id: id,
      participantId: participantId,
      matchId: matchId,
      token: token,
      expiresAt: expiresAt,
      isRevealed: isRevealed,
      revealedAt: revealedAt,
    );
  }
}
