import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/reveal_token_model.dart';

/// Abstract class defining the contract for reveal token local data source
abstract class RevealTokenLocalDataSource {
  /// Get reveal token by token string
  Future<RevealTokenModel?> getTokenByTokenString(String token);

  /// Get reveal token by ID
  Future<RevealTokenModel?> getTokenById(String id);

  /// Get all tokens for a participant
  Future<List<RevealTokenModel>> getTokensByParticipantId(String participantId);

  /// Get all tokens for a match
  Future<List<RevealTokenModel>> getTokensByMatchId(String matchId);

  /// Add a new reveal token
  Future<void> addToken(RevealTokenModel token);

  /// Update a reveal token
  Future<void> updateToken(RevealTokenModel token);

  /// Mark token as revealed
  Future<void> markTokenAsRevealed(String tokenId, DateTime revealedAt);

  /// Clear all tokens
  Future<void> clearTokens();

  /// Remove all tokens for a specific match
  Future<void> removeTokensByMatchId(String matchId);
}

/// Implementation of RevealTokenLocalDataSource using Hive
class RevealTokenLocalDataSourceImpl implements RevealTokenLocalDataSource {
  final Box<dynamic> _box;

  RevealTokenLocalDataSourceImpl(this._box);

  @override
  Future<RevealTokenModel?> getTokenByTokenString(String token) async {
    try {
      final keys = _box.keys.toList();
      for (final key in keys) {
        try {
          final data = _box.get(key);
          if (data != null) {
            Map<String, dynamic> json;
            if (data is String) {
              json = jsonDecode(data) as Map<String, dynamic>;
            } else if (data is Map<String, dynamic>) {
              json = data;
            } else {
              continue;
            }
            final model = RevealTokenModel.fromJson(json);
            if (model.token == token) {
              return model;
            }
          }
        } catch (e) {
          continue;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get token: $e');
    }
  }

  @override
  Future<RevealTokenModel?> getTokenById(String id) async {
    try {
      final data = _box.get(id);
      if (data != null) {
        Map<String, dynamic> json;
        if (data is String) {
          json = jsonDecode(data) as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          json = data;
        } else {
          return null;
        }
        return RevealTokenModel.fromJson(json);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get token by id: $e');
    }
  }

  @override
  Future<List<RevealTokenModel>> getTokensByParticipantId(
    String participantId,
  ) async {
    try {
      final tokensList = <RevealTokenModel>[];
      final keys = _box.keys.toList();

      for (final key in keys) {
        try {
          final data = _box.get(key);
          if (data != null) {
            Map<String, dynamic> json;
            if (data is String) {
              json = jsonDecode(data) as Map<String, dynamic>;
            } else if (data is Map<String, dynamic>) {
              json = data;
            } else {
              continue;
            }
            final model = RevealTokenModel.fromJson(json);
            if (model.participantId == participantId) {
              tokensList.add(model);
            }
          }
        } catch (e) {
          continue;
        }
      }

      return tokensList;
    } catch (e) {
      throw Exception('Failed to get tokens by participant: $e');
    }
  }

  @override
  Future<List<RevealTokenModel>> getTokensByMatchId(String matchId) async {
    try {
      final tokensList = <RevealTokenModel>[];
      final keys = _box.keys.toList();

      for (final key in keys) {
        try {
          final data = _box.get(key);
          if (data != null) {
            Map<String, dynamic> json;
            if (data is String) {
              json = jsonDecode(data) as Map<String, dynamic>;
            } else if (data is Map<String, dynamic>) {
              json = data;
            } else {
              continue;
            }
            final model = RevealTokenModel.fromJson(json);
            if (model.matchId == matchId) {
              tokensList.add(model);
            }
          }
        } catch (e) {
          continue;
        }
      }

      return tokensList;
    } catch (e) {
      throw Exception('Failed to get tokens by match: $e');
    }
  }

  @override
  Future<void> addToken(RevealTokenModel token) async {
    try {
      final json = token.toJson();
      final jsonString = jsonEncode(json);
      await _box.put(token.id, jsonString);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to add token: $e');
    }
  }

  @override
  Future<void> updateToken(RevealTokenModel token) async {
    try {
      final json = token.toJson();
      final jsonString = jsonEncode(json);
      await _box.put(token.id, jsonString);
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to update token: $e');
    }
  }

  @override
  Future<void> markTokenAsRevealed(String tokenId, DateTime revealedAt) async {
    try {
      final token = await getTokenById(tokenId);
      if (token != null) {
        final updatedToken = token.copyWith(
          isRevealed: true,
          revealedAt: revealedAt,
        );
        await updateToken(updatedToken);
      }
    } catch (e) {
      throw Exception('Failed to mark token as revealed: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('Failed to clear tokens: $e');
    }
  }

  @override
  Future<void> removeTokensByMatchId(String matchId) async {
    try {
      final tokens = await getTokensByMatchId(matchId);
      for (final token in tokens) {
        await _box.delete(token.id);
      }
      await _box.flush(); // Ensure data is written to disk
    } catch (e) {
      throw Exception('Failed to remove tokens by match: $e');
    }
  }
}
