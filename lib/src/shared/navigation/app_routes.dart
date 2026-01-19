/// Centralized route definitions for the app.
///
/// Why use a dedicated routes class?
/// - **Avoids typos**: Using constants prevents spelling mistakes in route names
/// - **Single source of truth**: All routes defined in one place
/// - **Easy refactoring**: Change a route path once, updates everywhere
/// - **IDE support**: Autocomplete and find usages work with constants
abstract final class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String create = '/create';
}
