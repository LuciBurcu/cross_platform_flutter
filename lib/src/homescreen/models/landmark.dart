import 'package:equatable/equatable.dart';

/// Domain model representing a landmark.
class Landmark extends Equatable {
  const Landmark({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;

  @override
  List<Object?> get props => [id, name, description];
}
