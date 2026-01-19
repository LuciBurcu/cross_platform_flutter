import 'package:cross_platform_flutter/src/shared/models/landmark.dart';
import 'package:drift/drift.dart';

import '../datasources/db/landmark_local_db.dart';
import '../datasources/network/landmark_network.dart';

/// Repository for landmark data - the single source of truth for ViewModels.
///
/// The repository coordinates between network and local database:
/// - **Network first**: Always tries the server first for fresh data
/// - **Local fallback**: Falls back to local database if network fails
/// - **Sync strategy**: Syncs network data to local db for offline access
///
/// ## Why use a Repository?
/// - **Abstraction**: ViewModels don't know about network/database details
/// - **Single source of truth**: One place to manage data logic
/// - **Offline support**: Seamlessly falls back to cached data
/// - **Testability**: Easy to mock for unit tests
class LandmarkRepository {
  LandmarkRepository({
    required this.landmarkDatabase,
    required this.landmarkNetwork,
  });

  final LandmarkDatabase landmarkDatabase;
  final LandmarkNetwork landmarkNetwork;

  /// Fetches all landmarks.
  Future<List<Landmark>> getLandmarks() async {
    try {
      // Try to fetch from network first
      final networkLandmarks = await landmarkNetwork.getLandmarks();

      // Sync network data to local database for offline access
      for (final landmarkDto in networkLandmarks) {
        final existingLocal = await landmarkDatabase.getLandmarkById(
          int.tryParse(landmarkDto.id) ?? 0,
        );

        if (existingLocal == null) {
          await landmarkDatabase.insertLandmark(
            LandmarkLocalCompanion.insert(
              name: landmarkDto.name,
              description: landmarkDto.description,
              imageUrl: Value(landmarkDto.imageUrl),
            ),
          );
        } else {
          await landmarkDatabase.updateLandmarkById(
            int.parse(landmarkDto.id),
            LandmarkLocalCompanion(
              name: Value(landmarkDto.name),
              description: Value(landmarkDto.description),
              imageUrl: Value(landmarkDto.imageUrl),
            ),
          );
        }
      }

      return networkLandmarks.map((dto) => dto.toDomain()).toList();
    } catch (networkError) {
      try {
        final localLandmarks = await landmarkDatabase.getAllLandmarks();
        return localLandmarks
            .map(
              (localItem) => Landmark(
                id: localItem.id.toString(),
                name: localItem.name,
                description: localItem.description,
                imageUrl: localItem.imageUrl,
              ),
            )
            .toList();
      } catch (localError) {
        // Both network and local failed
        throw Exception(
          'Failed to load landmarks. Network: $networkError, Local: $localError',
        );
      }
    }
  }

  /// Retrieves a landmark by its [id].
  Future<Landmark?> getLandmarkById(String id) async {
    try {
      // Try network first
      final networkLandmark = await landmarkNetwork.getLandmarkById(id);
      if (networkLandmark != null) {
        return networkLandmark.toDomain();
      }
    } catch (networkError) {
      // Network failed - try local database
      try {
        final landmarkLocal = await landmarkDatabase.getLandmarkById(
          int.parse(id),
        );
        if (landmarkLocal != null) {
          return Landmark(
            id: landmarkLocal.id.toString(),
            name: landmarkLocal.name,
            description: landmarkLocal.description,
            imageUrl: landmarkLocal.imageUrl,
          );
        }
      } catch (localError) {
        // Both network and local failed
        throw Exception(
          'Failed to load landmark. Network: $networkError, Local: $localError',
        );
      }
    }

    // Try local as final fallback (network returned null)
    final landmarkLocal = await landmarkDatabase.getLandmarkById(int.parse(id));
    if (landmarkLocal == null) return null;

    return Landmark(
      id: landmarkLocal.id.toString(),
      name: landmarkLocal.name,
      description: landmarkLocal.description,
      imageUrl: landmarkLocal.imageUrl,
    );
  }

  /// Creates a new landmark.
  Future<Landmark> createLandmark(
    String name,
    String description, {
    String imageUrl = '',
  }) async {
    try {
      // Try network first
      final networkLandmark = await landmarkNetwork.createLandmark(
        name: name,
        description: description,
        imageUrl: imageUrl,
      );

      // Sync to local database
      await landmarkDatabase.insertLandmark(
        LandmarkLocalCompanion.insert(
          name: name,
          description: description,
          imageUrl: Value(imageUrl),
        ),
      );

      return networkLandmark.toDomain();
    } catch (networkError) {
      // Network failed - try local database only
      try {
        final newId = await landmarkDatabase.insertLandmark(
          LandmarkLocalCompanion.insert(
            name: name,
            description: description,
            imageUrl: Value(imageUrl),
          ),
        );

        final landmarkLocal = await landmarkDatabase.getLandmarkById(newId);
        return Landmark(
          id: landmarkLocal!.id.toString(),
          name: landmarkLocal.name,
          description: landmarkLocal.description,
          imageUrl: landmarkLocal.imageUrl,
        );
      } catch (localError) {
        // Both network and local failed
        throw Exception(
          'Failed to create landmark. Network: $networkError, Local: $localError',
        );
      }
    }
  }

  /// Updates a landmark by its [id].
  Future<Landmark?> updateLandmark(
    String id,
    String name,
    String description, {
    String imageUrl = '',
  }) async {
    try {
      // Try network first
      final networkLandmark = await landmarkNetwork.updateLandmark(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );

      if (networkLandmark != null) {
        // Sync to local database
        await landmarkDatabase.updateLandmarkById(
          int.parse(id),
          LandmarkLocalCompanion(
            name: Value(name),
            description: Value(description),
            imageUrl: Value(imageUrl),
          ),
        );
        return networkLandmark.toDomain();
      }
      return null;
    } catch (networkError) {
      // Network failed - try local database only
      try {
        final updatedCount = await landmarkDatabase.updateLandmarkById(
          int.parse(id),
          LandmarkLocalCompanion(
            name: Value(name),
            description: Value(description),
            imageUrl: Value(imageUrl),
          ),
        );

        if (updatedCount == 0) return null;

        final landmarkLocal = await landmarkDatabase.getLandmarkById(
          int.parse(id),
        );
        if (landmarkLocal == null) return null;

        return Landmark(
          id: landmarkLocal.id.toString(),
          name: landmarkLocal.name,
          description: landmarkLocal.description,
          imageUrl: landmarkLocal.imageUrl,
        );
      } catch (localError) {
        // Both network and local failed
        throw Exception(
          'Failed to update landmark. Network: $networkError, Local: $localError',
        );
      }
    }
  }

  /// Deletes a landmark by its [id].
  Future<int> deleteLandmark(String id) async {
    try {
      // Try network first
      await landmarkNetwork.deleteLandmark(id);

      // Sync to local database
      return await landmarkDatabase.deleteLandmarkById(int.parse(id));
    } catch (networkError) {
      // Network failed - try local database only
      try {
        return await landmarkDatabase.deleteLandmarkById(int.parse(id));
      } catch (localError) {
        // Both network and local failed
        throw Exception(
          'Failed to delete landmark. Network: $networkError, Local: $localError',
        );
      }
    }
  }
}
