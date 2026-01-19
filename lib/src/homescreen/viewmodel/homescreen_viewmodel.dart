import 'package:cross_platform_flutter/src/homescreen/viewmodel/homescreen_state.dart';
import 'package:cross_platform_flutter/src/shared/repository/landmark_repository.dart';
import 'package:flutter/foundation.dart';

/// ViewModel for the Home Screen.
/// See README.md for documentation on ChangeNotifier and state management patterns.
class HomescreenViewModel extends ChangeNotifier {
  HomescreenViewModel({required this.landmarkRepository});

  final LandmarkRepository landmarkRepository;

  HomeScreenState state = const HomeScreenState();

  /// Loads the list of landmarks from the repository.
  Future<void> onLoadLandmarks() async {
    state = state.copyWith(isLoading: true, hasError: false);
    notifyListeners();

    try {
      final landmarks = await landmarkRepository.getLandmarks();
      state = state.copyWith(
        isLoading: false,
        hasError: false,
        landmarks: landmarks,
      );
      notifyListeners();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load landmarks: ${e.toString()}',
      );
      notifyListeners();
    }
  }
}
