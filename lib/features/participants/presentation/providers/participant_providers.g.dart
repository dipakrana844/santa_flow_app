// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for participants Hive box

@ProviderFor(participantsBox)
const participantsBoxProvider = ParticipantsBoxProvider._();

/// Provider for participants Hive box

final class ParticipantsBoxProvider
    extends $FunctionalProvider<Box<dynamic>, Box<dynamic>, Box<dynamic>>
    with $Provider<Box<dynamic>> {
  /// Provider for participants Hive box
  const ParticipantsBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'participantsBoxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$participantsBoxHash();

  @$internal
  @override
  $ProviderElement<Box<dynamic>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<dynamic> create(Ref ref) {
    return participantsBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<dynamic>>(value),
    );
  }
}

String _$participantsBoxHash() => r'451f32b1f33c1e4b763c9d501ff862500ac30f28';

/// Provider for participant local data source

@ProviderFor(participantLocalDataSource)
const participantLocalDataSourceProvider =
    ParticipantLocalDataSourceProvider._();

/// Provider for participant local data source

final class ParticipantLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ParticipantLocalDataSource,
          ParticipantLocalDataSource,
          ParticipantLocalDataSource
        >
    with $Provider<ParticipantLocalDataSource> {
  /// Provider for participant local data source
  const ParticipantLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'participantLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$participantLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ParticipantLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ParticipantLocalDataSource create(Ref ref) {
    return participantLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParticipantLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParticipantLocalDataSource>(value),
    );
  }
}

String _$participantLocalDataSourceHash() =>
    r'29084a317ba6d2a02f7393df2efc396e9f25f69e';

/// Provider for participant repository

@ProviderFor(participantRepository)
const participantRepositoryProvider = ParticipantRepositoryProvider._();

/// Provider for participant repository

final class ParticipantRepositoryProvider
    extends
        $FunctionalProvider<
          ParticipantRepository,
          ParticipantRepository,
          ParticipantRepository
        >
    with $Provider<ParticipantRepository> {
  /// Provider for participant repository
  const ParticipantRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'participantRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$participantRepositoryHash();

  @$internal
  @override
  $ProviderElement<ParticipantRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ParticipantRepository create(Ref ref) {
    return participantRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParticipantRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParticipantRepository>(value),
    );
  }
}

String _$participantRepositoryHash() =>
    r'2e5d0ae66b3422a2cd63c213bf447b2ff9c31e26';

/// Provider for GetParticipants use case

@ProviderFor(getParticipants)
const getParticipantsProvider = GetParticipantsProvider._();

/// Provider for GetParticipants use case

final class GetParticipantsProvider
    extends
        $FunctionalProvider<GetParticipants, GetParticipants, GetParticipants>
    with $Provider<GetParticipants> {
  /// Provider for GetParticipants use case
  const GetParticipantsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getParticipantsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getParticipantsHash();

  @$internal
  @override
  $ProviderElement<GetParticipants> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetParticipants create(Ref ref) {
    return getParticipants(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetParticipants value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetParticipants>(value),
    );
  }
}

String _$getParticipantsHash() => r'bf2259eb0be7aa608173190e78180645f4645195';

/// Provider for AddParticipant use case

@ProviderFor(addParticipant)
const addParticipantProvider = AddParticipantProvider._();

/// Provider for AddParticipant use case

final class AddParticipantProvider
    extends $FunctionalProvider<AddParticipant, AddParticipant, AddParticipant>
    with $Provider<AddParticipant> {
  /// Provider for AddParticipant use case
  const AddParticipantProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addParticipantProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addParticipantHash();

  @$internal
  @override
  $ProviderElement<AddParticipant> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddParticipant create(Ref ref) {
    return addParticipant(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddParticipant value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddParticipant>(value),
    );
  }
}

String _$addParticipantHash() => r'c72c44bf29482c77da5c685c3a8994843dfffcfb';

/// Provider for RemoveParticipant use case

@ProviderFor(removeParticipant)
const removeParticipantProvider = RemoveParticipantProvider._();

/// Provider for RemoveParticipant use case

final class RemoveParticipantProvider
    extends
        $FunctionalProvider<
          RemoveParticipant,
          RemoveParticipant,
          RemoveParticipant
        >
    with $Provider<RemoveParticipant> {
  /// Provider for RemoveParticipant use case
  const RemoveParticipantProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeParticipantProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeParticipantHash();

  @$internal
  @override
  $ProviderElement<RemoveParticipant> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoveParticipant create(Ref ref) {
    return removeParticipant(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoveParticipant value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoveParticipant>(value),
    );
  }
}

String _$removeParticipantHash() => r'84ed7166104796f1f8aed9d025043ffcfef5c3be';

/// Provider for ValidateParticipant use case

@ProviderFor(validateParticipant)
const validateParticipantProvider = ValidateParticipantProvider._();

/// Provider for ValidateParticipant use case

final class ValidateParticipantProvider
    extends
        $FunctionalProvider<
          ValidateParticipant,
          ValidateParticipant,
          ValidateParticipant
        >
    with $Provider<ValidateParticipant> {
  /// Provider for ValidateParticipant use case
  const ValidateParticipantProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'validateParticipantProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$validateParticipantHash();

  @$internal
  @override
  $ProviderElement<ValidateParticipant> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ValidateParticipant create(Ref ref) {
    return validateParticipant(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ValidateParticipant value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ValidateParticipant>(value),
    );
  }
}

String _$validateParticipantHash() =>
    r'aa388fd2d689a7231c60d3c20d6e53e957637cff';

/// Provider for participants list

@ProviderFor(participants)
const participantsProvider = ParticipantsProvider._();

/// Provider for participants list

final class ParticipantsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Participant>>,
          List<Participant>,
          FutureOr<List<Participant>>
        >
    with
        $FutureModifier<List<Participant>>,
        $FutureProvider<List<Participant>> {
  /// Provider for participants list
  const ParticipantsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'participantsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$participantsHash();

  @$internal
  @override
  $FutureProviderElement<List<Participant>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Participant>> create(Ref ref) {
    return participants(ref);
  }
}

String _$participantsHash() => r'584d9a4f70b85490102ee425bba1626a254519b4';

/// Provider for participants filtered by event ID

@ProviderFor(participantsByEvent)
const participantsByEventProvider = ParticipantsByEventFamily._();

/// Provider for participants filtered by event ID

final class ParticipantsByEventProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Participant>>,
          List<Participant>,
          FutureOr<List<Participant>>
        >
    with
        $FutureModifier<List<Participant>>,
        $FutureProvider<List<Participant>> {
  /// Provider for participants filtered by event ID
  const ParticipantsByEventProvider._({
    required ParticipantsByEventFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'participantsByEventProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$participantsByEventHash();

  @override
  String toString() {
    return r'participantsByEventProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Participant>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Participant>> create(Ref ref) {
    final argument = this.argument as String;
    return participantsByEvent(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ParticipantsByEventProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$participantsByEventHash() =>
    r'207f6b20285574e5bf92892af04359764d4f965a';

/// Provider for participants filtered by event ID

final class ParticipantsByEventFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Participant>>, String> {
  const ParticipantsByEventFamily._()
    : super(
        retry: null,
        name: r'participantsByEventProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for participants filtered by event ID

  ParticipantsByEventProvider call(String eventId) =>
      ParticipantsByEventProvider._(argument: eventId, from: this);

  @override
  String toString() => r'participantsByEventProvider';
}
