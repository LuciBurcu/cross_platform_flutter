import 'package:cross_platform_flutter/src/details/viewmodel/details_state.dart';
import 'package:cross_platform_flutter/src/shared/repository/landmark_repository.dart';
import 'package:flutter/foundation.dart';

/// ViewModel for the Details Screen.
/// See README.md for documentation on ChangeNotifier and state management patterns.
class DetailsViewModel extends ChangeNotifier {
  DetailsViewModel({
    required this.landmarkId,
    required this.landmarkRepository,
  });

  final String landmarkId;
  final LandmarkRepository landmarkRepository;

  DetailsScreenState state = const DetailsScreenState();

  /// Loads the landmark details from the repository.
  Future<void> onLoadLandmark() async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );
    notifyListeners();

    try {
      final landmark = await landmarkRepository.getLandmarkById(landmarkId);

      if (landmark != null) {
        state = state.copyWith(
          isLoading: false,
          hasError: false,
          landmarkId: landmark.id,
          title: landmark.name,
          description: landmark.description,
          imageUrl: landmark.imageUrl,
        );
        notifyListeners();
      } else {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Landmark not found',
        );
        notifyListeners();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load landmark: ${e.toString()}',
      );
      notifyListeners();
    }
  }

  /// Deletes the current landmark.
  Future<void> onDeleteLandmark() async {
    try {
      await landmarkRepository.deleteLandmark(landmarkId);
    } catch (e) {
      state = state.copyWith(
        hasError: true,
        errorMessage: 'Failed to delete landmark: ${e.toString()}',
      );
      notifyListeners();
    }
  }
}
