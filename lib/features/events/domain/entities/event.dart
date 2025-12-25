import 'package:equatable/equatable.dart';

/// Domain entity representing a Secret Santa event
class Event extends Equatable {
  final String id;
  final String name;
  final DateTime date;
  final double? budget;
  final DateTime createdAt;

  const Event({
    required this.id,
    required this.name,
    required this.date,
    this.budget,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, date, budget, createdAt];

  /// Creates a copy of this event with updated fields
  Event copyWith({
    String? id,
    String? name,
    DateTime? date,
    double? budget,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      budget: budget ?? this.budget,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
