import 'landmark.dart';

/// Data Transfer Object for landmarks from the network API.
/// This is the data layer model - separate from the domain [Landmark] model.
class LandmarkDTO {
  const LandmarkDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;

  /// Creates a [LandmarkDTO] from a JSON map.
  static LandmarkDTO fromJson(Map<String, dynamic> json) {
    return LandmarkDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  /// Converts this [LandmarkDTO] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// Converts this [LandmarkDTO] to a domain [Landmark] model.
  Landmark toDomain() {
    return Landmark(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
  }

  /// Creates a [LandmarkDTO] from a domain [Landmark] model.
  static LandmarkDTO fromDomain(Landmark landmark) {
    return LandmarkDTO(
      id: landmark.id,
      name: landmark.name,
      description: landmark.description,
      imageUrl: landmark.imageUrl,
    );
  }
}
