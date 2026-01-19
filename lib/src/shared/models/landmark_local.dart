import 'package:drift/drift.dart';

/// Database table schema for landmarks (used by Drift).
///
/// This is a **data layer model** - it defines the SQLite table structure.
/// Drift generates the actual data class (`LandmarkLocalData`) from this schema.
///
/// See [Landmark] for the domain model used by ViewModels and Views.
/// See [LandmarkDTO] for the network model with JSON serialization.
class LandmarkLocal extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  TextColumn get imageUrl => text().withDefault(const Constant(''))();
}
