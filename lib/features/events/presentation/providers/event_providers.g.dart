// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for events Hive box

@ProviderFor(eventsBox)
const eventsBoxProvider = EventsBoxProvider._();

/// Provider for events Hive box

final class EventsBoxProvider
    extends $FunctionalProvider<Box<dynamic>, Box<dynamic>, Box<dynamic>>
    with $Provider<Box<dynamic>> {
  /// Provider for events Hive box
  const EventsBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsBoxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsBoxHash();

  @$internal
  @override
  $ProviderElement<Box<dynamic>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<dynamic> create(Ref ref) {
    return eventsBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<dynamic>>(value),
    );
  }
}

String _$eventsBoxHash() => r'cd60969c31dfe04df5863f72ec6e17550630f16a';

/// Provider for event local data source

@ProviderFor(eventLocalDataSource)
const eventLocalDataSourceProvider = EventLocalDataSourceProvider._();

/// Provider for event local data source

final class EventLocalDataSourceProvider
    extends
        $FunctionalProvider<
          EventLocalDataSource,
          EventLocalDataSource,
          EventLocalDataSource
        >
    with $Provider<EventLocalDataSource> {
  /// Provider for event local data source
  const EventLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<EventLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EventLocalDataSource create(Ref ref) {
    return eventLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventLocalDataSource>(value),
    );
  }
}

String _$eventLocalDataSourceHash() =>
    r'772d8753b7c8385237026054a4fcc615a83a1a99';

/// Provider for event repository

@ProviderFor(eventRepository)
const eventRepositoryProvider = EventRepositoryProvider._();

/// Provider for event repository

final class EventRepositoryProvider
    extends
        $FunctionalProvider<EventRepository, EventRepository, EventRepository>
    with $Provider<EventRepository> {
  /// Provider for event repository
  const EventRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventRepositoryHash();

  @$internal
  @override
  $ProviderElement<EventRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventRepository create(Ref ref) {
    return eventRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventRepository>(value),
    );
  }
}

String _$eventRepositoryHash() => r'cd2b42bdac0d9489978015227a8a91d6d37c9a00';

/// Provider for events list

@ProviderFor(events)
const eventsProvider = EventsProvider._();

/// Provider for events list

final class EventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Event>>,
          List<Event>,
          FutureOr<List<Event>>
        >
    with $FutureModifier<List<Event>>, $FutureProvider<List<Event>> {
  /// Provider for events list
  const EventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsHash();

  @$internal
  @override
  $FutureProviderElement<List<Event>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Event>> create(Ref ref) {
    return events(ref);
  }
}

String _$eventsHash() => r'1c7c6e78b5491e3f9f36962f13b6e2176b25945a';

/// Provider for current selected event ID

@ProviderFor(CurrentEventId)
const currentEventIdProvider = CurrentEventIdProvider._();

/// Provider for current selected event ID
final class CurrentEventIdProvider
    extends $AsyncNotifierProvider<CurrentEventId, String?> {
  /// Provider for current selected event ID
  const CurrentEventIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEventIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEventIdHash();

  @$internal
  @override
  CurrentEventId create() => CurrentEventId();
}

String _$currentEventIdHash() => r'3d20a3cc64ae50bb926ab7b883b3b41dec788dd1';

/// Provider for current selected event ID

abstract class _$CurrentEventId extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for current event entity

@ProviderFor(currentEvent)
const currentEventProvider = CurrentEventProvider._();

/// Provider for current event entity

final class CurrentEventProvider
    extends $FunctionalProvider<AsyncValue<Event?>, Event?, FutureOr<Event?>>
    with $FutureModifier<Event?>, $FutureProvider<Event?> {
  /// Provider for current event entity
  const CurrentEventProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEventHash();

  @$internal
  @override
  $FutureProviderElement<Event?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Event?> create(Ref ref) {
    return currentEvent(ref);
  }
}

String _$currentEventHash() => r'caa335618b36faed82075e9a2623022739f103ed';

/// Provider for event by ID (family provider)

@ProviderFor(eventById)
const eventByIdProvider = EventByIdFamily._();

/// Provider for event by ID (family provider)

final class EventByIdProvider
    extends $FunctionalProvider<AsyncValue<Event?>, Event?, FutureOr<Event?>>
    with $FutureModifier<Event?>, $FutureProvider<Event?> {
  /// Provider for event by ID (family provider)
  const EventByIdProvider._({
    required EventByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventByIdHash();

  @override
  String toString() {
    return r'eventByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Event?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Event?> create(Ref ref) {
    final argument = this.argument as String;
    return eventById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventByIdHash() => r'0970e999e8e5039e884743b17c230530c49127cf';

/// Provider for event by ID (family provider)

final class EventByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Event?>, String> {
  const EventByIdFamily._()
    : super(
        retry: null,
        name: r'eventByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for event by ID (family provider)

  EventByIdProvider call(String eventId) =>
      EventByIdProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventByIdProvider';
}
