import 'package:cross_platform_flutter/src/shared/models/landmark_local.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'landmark_local_db.g.dart';

/// Local database for landmarks using Drift.
///
/// Drift is a reactive persistence library that generates type-safe code
/// for database operations. The `.g.dart` file is auto-generated.
///
/// ## Key concepts:
/// - **@DriftDatabase**: Annotation that registers tables for code generation
/// - **_$LandmarkDatabase**: Generated base class with database logic
/// - **LandmarkLocalCompanion**: Generated class for insert/update operations
/// - **LandmarkLocalData**: Generated class representing a table row
///
/// ## Code generation:
/// Run `dart run build_runner build` to generate the `.g.dart` file.
@DriftDatabase(tables: [LandmarkLocal])
class LandmarkDatabase extends _$LandmarkDatabase {
  LandmarkDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'landmark_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  // CREATE - Insert a new landmark
  Future<int> insertLandmark(LandmarkLocalCompanion landmark) async {
    return await managers.landmarkLocal.create(
      (row) => row(
        name: landmark.name.value,
        description: landmark.description.value,
        imageUrl: landmark.imageUrl,
      ),
    );
  }

  // READ - Get all landmarks
  Future<List<LandmarkLocalData>> getAllLandmarks() async {
    return await managers.landmarkLocal.get();
  }

  // READ - Get a landmark by id
  Future<LandmarkLocalData?> getLandmarkById(int id) async {
    return await managers.landmarkLocal
        .filter((f) => f.id(id))
        .getSingleOrNull();
  }

  // UPDATE - Update landmark by id with companion
  Future<int> updateLandmarkById(
    int id,
    LandmarkLocalCompanion landmark,
  ) async {
    return await managers.landmarkLocal
        .filter((f) => f.id(id))
        .update(
          (row) => row(
            name: landmark.name,
            description: landmark.description,
            imageUrl: landmark.imageUrl,
          ),
        );
  }

  // DELETE - Delete landmark by id
  Future<int> deleteLandmarkById(int id) async {
    return await managers.landmarkLocal.filter((f) => f.id(id)).delete();
  }
}
