import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/core/error/failures.dart';
import '../../../../../lib/features/reveal/domain/entities/reveal_token.dart';
import '../../../../../lib/features/reveal/domain/repositories/reveal_token_repository.dart';
import '../../../../../lib/features/reveal/domain/usecases/validate_reveal_token.dart';
import '../../../../helpers/mock_data.dart';

class MockRevealTokenRepository extends Mock implements RevealTokenRepository {}

void main() {
  late ValidateRevealToken validateRevealToken;
  late MockRevealTokenRepository mockRepository;

  setUp(() {
    mockRepository = MockRevealTokenRepository();
    validateRevealToken = ValidateRevealToken(mockRepository);
  });

  group('ValidateRevealToken', () {
    test('should return Right for valid token', () async {
      // Arrange
      const tokenString = 'valid-token-123';
      final validToken = MockDataFactory.createRevealToken(
        token: tokenString,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        isRevealed: false,
      );

      when(
        () => mockRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => Right(validToken));

      // Act
      final result = await validateRevealToken(tokenString);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (token) {
        expect(token.token, tokenString);
        expect(token.isValid, true);
      });
      verify(() => mockRepository.getTokenByTokenString(tokenString)).called(1);
    });

    test('should return ValidationFailure when token not found', () async {
      // Arrange
      const tokenString = 'non-existent-token';
      when(
        () => mockRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await validateRevealToken(tokenString);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Token not found or invalid');
      }, (_) => fail('Should return failure'));
      verify(() => mockRepository.getTokenByTokenString(tokenString)).called(1);
    });

    test('should return ValidationFailure when token is expired', () async {
      // Arrange
      const tokenString = 'expired-token';
      final expiredToken = MockDataFactory.createRevealToken(
        token: tokenString,
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        isRevealed: false,
      );

      when(
        () => mockRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => Right(expiredToken));

      // Act
      final result = await validateRevealToken(tokenString);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Token has expired');
      }, (_) => fail('Should return failure'));
      verify(() => mockRepository.getTokenByTokenString(tokenString)).called(1);
    });

    test(
      'should return ValidationFailure when token is already revealed',
      () async {
        // Arrange
        const tokenString = 'revealed-token';
        final revealedToken =
            MockDataFactory.createRevealToken(
              token: tokenString,
              expiresAt: DateTime.now().add(const Duration(days: 30)),
              isRevealed: true,
            ).copyWith(
              revealedAt: DateTime.now().subtract(const Duration(hours: 1)),
            );

        when(
          () => mockRepository.getTokenByTokenString(any()),
        ).thenAnswer((_) async => Right(revealedToken));

        // Act
        final result = await validateRevealToken(tokenString);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Token has already been revealed');
        }, (_) => fail('Should return failure'));
        verify(
          () => mockRepository.getTokenByTokenString(tokenString),
        ).called(1);
      },
    );

    test(
      'should return ValidationFailure when repository returns failure',
      () async {
        // Arrange
        const tokenString = 'error-token';
        const failure = CacheFailure('Database error');
        when(
          () => mockRepository.getTokenByTokenString(any()),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await validateRevealToken(tokenString);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Database error');
        }, (_) => fail('Should return failure'));
        verify(
          () => mockRepository.getTokenByTokenString(tokenString),
        ).called(1);
      },
    );

    test(
      'should return ValidationFailure for token that expires exactly now',
      () async {
        // Arrange
        const tokenString = 'just-expired-token';
        // Use a time slightly in the past to ensure it's expired
        final justExpiredToken = MockDataFactory.createRevealToken(
          token: tokenString,
          expiresAt: DateTime.now().subtract(const Duration(milliseconds: 1)),
          isRevealed: false,
        );

        when(
          () => mockRepository.getTokenByTokenString(any()),
        ).thenAnswer((_) async => Right(justExpiredToken));

        // Act
        final result = await validateRevealToken(tokenString);

        // Assert
        // Token expires at exactly now should be considered expired
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Token has expired');
        }, (_) => fail('Should return failure'));
      },
    );

    test('should accept token that expires in the future', () async {
      // Arrange
      const tokenString = 'future-token';
      final futureToken = MockDataFactory.createRevealToken(
        token: tokenString,
        expiresAt: DateTime.now().add(const Duration(seconds: 1)),
        isRevealed: false,
      );

      when(
        () => mockRepository.getTokenByTokenString(any()),
      ).thenAnswer((_) async => Right(futureToken));

      // Act
      final result = await validateRevealToken(tokenString);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (token) {
        expect(token.token, tokenString);
        expect(token.isValid, true);
      });
    });
  });
}
