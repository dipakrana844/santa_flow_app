// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for matches Hive box

@ProviderFor(matchesBox)
const matchesBoxProvider = MatchesBoxProvider._();

/// Provider for matches Hive box

final class MatchesBoxProvider
    extends $FunctionalProvider<Box<dynamic>, Box<dynamic>, Box<dynamic>>
    with $Provider<Box<dynamic>> {
  /// Provider for matches Hive box
  const MatchesBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchesBoxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchesBoxHash();

  @$internal
  @override
  $ProviderElement<Box<dynamic>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<dynamic> create(Ref ref) {
    return matchesBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<dynamic>>(value),
    );
  }
}

String _$matchesBoxHash() => r'52365ccccdf802849ff79c59caf77af816be3b73';

/// Provider for match local data source

@ProviderFor(matchLocalDataSource)
const matchLocalDataSourceProvider = MatchLocalDataSourceProvider._();

/// Provider for match local data source

final class MatchLocalDataSourceProvider
    extends
        $FunctionalProvider<
          MatchLocalDataSource,
          MatchLocalDataSource,
          MatchLocalDataSource
        >
    with $Provider<MatchLocalDataSource> {
  /// Provider for match local data source
  const MatchLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<MatchLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MatchLocalDataSource create(Ref ref) {
    return matchLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchLocalDataSource>(value),
    );
  }
}

String _$matchLocalDataSourceHash() =>
    r'63ab0845688ef32b412c298baee1e5eaf66d0c9a';

/// Provider for match repository

@ProviderFor(matchRepository)
const matchRepositoryProvider = MatchRepositoryProvider._();

/// Provider for match repository

final class MatchRepositoryProvider
    extends
        $FunctionalProvider<MatchRepository, MatchRepository, MatchRepository>
    with $Provider<MatchRepository> {
  /// Provider for match repository
  const MatchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchRepositoryHash();

  @$internal
  @override
  $ProviderElement<MatchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MatchRepository create(Ref ref) {
    return matchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchRepository>(value),
    );
  }
}

String _$matchRepositoryHash() => r'cc20932b873c41cafa5406e0fad111a083bb40de';

/// Provider for GenerateMatches use case

@ProviderFor(generateMatches)
const generateMatchesProvider = GenerateMatchesProvider._();

/// Provider for GenerateMatches use case

final class GenerateMatchesProvider
    extends
        $FunctionalProvider<GenerateMatches, GenerateMatches, GenerateMatches>
    with $Provider<GenerateMatches> {
  /// Provider for GenerateMatches use case
  const GenerateMatchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generateMatchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generateMatchesHash();

  @$internal
  @override
  $ProviderElement<GenerateMatches> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GenerateMatches create(Ref ref) {
    return generateMatches(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerateMatches value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerateMatches>(value),
    );
  }
}

String _$generateMatchesHash() => r'156bc15d4c108a626edbeac2d20b607a2d3e64b4';

/// Provider for matches list by event

@ProviderFor(matchesByEvent)
const matchesByEventProvider = MatchesByEventFamily._();

/// Provider for matches list by event

final class MatchesByEventProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SecretSantaMatch>>,
          List<SecretSantaMatch>,
          FutureOr<List<SecretSantaMatch>>
        >
    with
        $FutureModifier<List<SecretSantaMatch>>,
        $FutureProvider<List<SecretSantaMatch>> {
  /// Provider for matches list by event
  const MatchesByEventProvider._({
    required MatchesByEventFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'matchesByEventProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$matchesByEventHash();

  @override
  String toString() {
    return r'matchesByEventProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SecretSantaMatch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SecretSantaMatch>> create(Ref ref) {
    final argument = this.argument as String;
    return matchesByEvent(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchesByEventProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$matchesByEventHash() => r'663f974d8946bca66de95914d63cb3b290e80c76';

/// Provider for matches list by event

final class MatchesByEventFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SecretSantaMatch>>, String> {
  const MatchesByEventFamily._()
    : super(
        retry: null,
        name: r'matchesByEventProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for matches list by event

  MatchesByEventProvider call(String eventId) =>
      MatchesByEventProvider._(argument: eventId, from: this);

  @override
  String toString() => r'matchesByEventProvider';
}
