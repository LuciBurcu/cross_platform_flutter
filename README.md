# Cross Platform Flutter - Landmarks App

A Flutter app demonstrating the **MVVM (Model-View-ViewModel)** architecture pattern with a simple landmarks management feature.

## Getting Started

### Prerequisites
- Flutter SDK ^3.9.2
- Node.js (for the backend server)

### Running the App

1. **Start the backend server:**
   ```bash
   cd server
   npm install
   npm start
   ```
   Server runs on `http://localhost:3000`

2. **Run the Flutter app:**
   ```bash
   flutter pub get
   flutter run
   ```

---

## MVVM Architecture

This project follows the **MVVM (Model-View-ViewModel)** pattern to separate concerns and make the code testable and maintainable.

```
┌─────────────────────────────────────────────────────────────┐
│                           VIEW                              │
│                  (Screens / Widgets)                        │
│         Displays UI based on state, triggers events         │
└─────────────────────┬───────────────────────────────────────┘
                      │ watches state / calls methods
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                       VIEWMODEL                             │
│              (ChangeNotifier + State)                       │
│      Holds state, handles business logic, notifies UI       │
└─────────────────────┬───────────────────────────────────────┘
                      │ calls repository methods
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                       REPOSITORY                            │
│           Single source of truth for data                   │
│      Coordinates between network and local database         │
└─────────────────────┬───────────────────────────────────────┘
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│     NETWORK     │     │   LOCAL DB      │
│  (LandmarkDTO)  │     │ (Drift/SQLite)  │
└─────────────────┘     └─────────────────┘
```

---

## Domain Models vs Data Layer Models

This project separates models into three layers:

| Model | Location | Purpose |
|-------|----------|---------|
| `Landmark` | `shared/models/` | Domain model - clean, used by ViewModels and Views |
| `LandmarkDTO` | `datasources/network/` | Network model - has `fromJson`/`toJson` for API |
| `LandmarkLocal` | `shared/models/` | Database model - defines SQLite table schema |

**Why separate?**
- **Decoupling**: UI doesn't depend on API/database structure
- **Flexibility**: API or database schema can change without affecting UI
- **Clean code**: No serialization logic in business models

**Data flow:**
```
Network (JSON) → LandmarkDTO → Repository → Landmark → ViewModel → View
Database (SQL) → LandmarkLocal → Repository → Landmark → ViewModel → View
```

---

## State Management

### Why Equatable?

State classes extend `Equatable` to enable **value-based equality comparison**.

By default, Dart compares objects by reference (identity). With Equatable, two state instances with the same property values are considered equal.

```dart
// Without Equatable - compares by reference
final state1 = HomeScreenState(isLoading: true);
final state2 = HomeScreenState(isLoading: true);
print(state1 == state2); // false 

// With Equatable - compares by value
print(state1 == state2); // true 
```

**Benefits:**
- **Testing**: Easy to compare expected vs actual states
- **Performance**: Flutter can skip unnecessary rebuilds when state hasn't changed
- **Debugging**: Easier to track state changes

### Why copyWith?

The `copyWith` method creates a **new instance** with some properties changed.

Since state classes are **immutable** (all fields are `final`), we can't modify existing instances. Instead, we create new ones with updated values.

```dart
// Wrong - can't mutate immutable state
state.isLoading = true;

// Correct - create new state with copyWith
state = state.copyWith(isLoading: true);
```

**Benefits:**
- **Immutability**: Prevents accidental state mutations
- **Simplifies updates**: Only specify what changed
- **Predictable**: Each state change creates a new object

### State Structure

All state classes follow a consistent structure:

| Field | Type | Purpose |
|-------|------|---------|
| `isLoading` | `bool` | Show loading indicator |
| `hasError` | `bool` | Show error state |
| `errorMessage` | `String?` | Error description |
| *data fields* | varies | Screen-specific data |

---

## ViewModels

### Why ChangeNotifier?

ViewModels extend `ChangeNotifier` to enable **reactive UI updates**.

```dart
class MyViewModel extends ChangeNotifier {
  MyState state = MyState();
  
  void doSomething() {
    state = state.copyWith(isLoading: true);
    notifyListeners(); // Triggers UI rebuild
  }
}
```

**How it works:**
1. ViewModel updates `state` and calls `notifyListeners()`
2. Flutter's `Provider` / `Consumer` widgets listen for notifications
3. UI automatically rebuilds with the new state

### Why notifyListeners()?

`notifyListeners()` is the mechanism that **triggers UI rebuilds**.

```dart
// State change WITHOUT notifyListeners - UI won't update
state = state.copyWith(isLoading: false);

// State change WITH notifyListeners - UI updates
state = state.copyWith(isLoading: false);
notifyListeners();
```

**Rule**: Always call `notifyListeners()` after changing state.

### Naming Convention

Methods prefixed with `on` indicate they are triggered by UI events:
- `onLoadLandmarks()` - Screen needs to load data
- `onCreateLandmark()` - User submits a form
- `onDeleteLandmark()` - User confirms deletion

### State Transitions

ViewModels follow a consistent pattern for async operations:

```dart
Future<void> onLoadData() async {
  // 1. Set loading state
  state = state.copyWith(isLoading: true, hasError: false);
  notifyListeners();

  try {
    // 2. Fetch data
    final data = await repository.getData();
    
    // 3. Set success state
    state = state.copyWith(isLoading: false, data: data);
    notifyListeners();
  } catch (e) {
    // 4. Set error state
    state = state.copyWith(
      isLoading: false,
      hasError: true,
      errorMessage: e.toString(),
    );
    notifyListeners();
  }
}
```

---

## Repository Pattern

The repository is the **single source of truth** for data operations.

### Strategy: Network First with Local Fallback

```dart
Future<List<Landmark>> getLandmarks() async {
  try {
    // 1. Try network first
    final data = await network.getLandmarks();
    
    // 2. Sync to local database
    await localDb.saveAll(data);
    
    return data;
  } catch (networkError) {
    // 3. Fallback to local database
    try {
      return await localDb.getAll();
    } catch (localError) {
      // 4. Both failed - throw error
      throw Exception('Failed to load data');
    }
  }
}
```

**Benefits:**
- **Offline support**: App works without internet
- **Fresh data**: Always tries network first
- **Graceful degradation**: Falls back to cached data

---

## Dependency Injection

Dependencies are injected via constructor for:
- **Testability**: Mock repositories in tests
- **Separation of Concerns**: ViewModel doesn't know how data is fetched

```dart
// In main.dart
final repository = LandmarkRepository(...);
final viewModel = HomescreenViewModel(landmarkRepository: repository);

// In tests
final mockRepository = MockLandmarkRepository();
final viewModel = HomescreenViewModel(landmarkRepository: mockRepository);
```

---

## Navigation

Routes are defined as constants in `AppRoutes` to:
- **Avoid typos**: Constants prevent spelling mistakes
- **Single source of truth**: All routes in one place
- **Easy refactoring**: Change once, updates everywhere

```dart
// Definition
abstract final class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String create = '/create';
}

// Usage
Navigator.pushNamed(context, AppRoutes.details, arguments: landmarkId);
```

---

## StatefulWidget & Controllers

`TextEditingController` requires a `StatefulWidget` because:
- Controllers must be **created once** (not on every rebuild)
- Controllers must be **disposed** to avoid memory leaks

```dart
class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Prevent memory leaks
    super.dispose();
  }
}
```

---

## Local Database (Drift)

Drift is a reactive persistence library for SQLite:
- **Type-safe**: Generated code prevents SQL errors
- **Reactive**: Stream-based queries for real-time updates
- **Code generation**: Run `dart run build_runner build`

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, dependency setup
└── src/
    ├── homescreen/
    │   ├── screens/             # UI widgets
    │   └── viewmodel/           # ViewModel + State
    ├── details/
    │   ├── screens/
    │   └── viewmodel/
    ├── create/
    │   ├── screens/
    │   └── viewmodels/
    └── shared/
        ├── models/              # Domain models (Landmark)
        ├── repository/          # Data coordination
        ├── datasources/
        │   ├── db/              # Local database (Drift)
        │   └── network/         # API client + DTOs
        └── navigation/          # Route definitions

server/                          # Node.js Express backend
├── index.js                     # API endpoints
├── package.json
└── README.md
```

---

## API Endpoints

The backend server provides these endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/landmarks` | Get all landmarks |
| GET | `/landmarks/:id` | Get a single landmark |
| POST | `/landmarks` | Create a new landmark |
| PUT | `/landmarks/:id` | Update a landmark |
| DELETE | `/landmarks/:id` | Delete a landmark |

See `server/README.md` for more details.

---

## Key Takeaways

1. **Separation of Concerns**: Each layer has one responsibility
2. **Immutable State**: Use `copyWith` to update state safely
3. **Reactive Updates**: Call `notifyListeners()` after state changes
4. **Network First**: Always try fresh data, fallback to cache
5. **Dependency Injection**: Pass dependencies via constructor for testability
6. **Domain Models**: Keep business models separate from data layer models
