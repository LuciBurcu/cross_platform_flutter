import 'package:cross_platform_flutter/src/homescreen/datasources/db/landmark_local_db.dart';
import 'package:cross_platform_flutter/src/homescreen/models/landmark.dart';

class LandmarkRepository {
  LandmarkRepository({required this.landmarkDatabase});

  final LandmarkDatabase landmarkDatabase;

  // Read
  Future<List<Landmark>> getLandmarks() async {
    final localLandmarks = await landmarkDatabase.managers.landmarkLocal.get();
    return localLandmarks
        .map(
          (localItem) => Landmark(
            id: localItem.id.toString(),
            name: localItem.name,
            description: localItem.description,
          ),
        )
        .toList();
  }

  /// Retrieves a landmark by its [id].
  /// Throws [UnimplementedError] if not implemented. You can implement based on your needs
  Landmark getLandmarkById(String id) {
    throw UnimplementedError();
  }

  // Create
  Future<Landmark> createLandmark(String name, String description) async {
    final newId = await landmarkDatabase.managers.landmarkLocal.create(
      (row) => row(name: name, description: description),
    );
    final landmarkLocal = await landmarkDatabase.managers.landmarkLocal
        .filter((f) => f.id(newId))
        .getSingle();
    return Landmark(
      id: landmarkLocal.id.toString(),
      name: landmarkLocal.name,
      description: landmarkLocal.description,
    );
  }

  // Update
  /// Updates a landmark by its [id] with the new [name] and [description].
  /// Returns the updated [Landmark].
  /// Throws [UnimplementedError] if not implemented. You can implement based on your needs.
  Landmark updateLandmark(String id, String name, String description) {
    throw UnimplementedError();
  }

  // Delete
  /// Deletes a landmark by its [id].
  /// Throws [UnimplementedError] if not implemented. You can implement based on your needs.
  void deleteLandmark(String id) {
    throw UnimplementedError();
  }
}
