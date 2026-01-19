import 'package:cross_platform_flutter/src/create/viewmodels/create_state.dart';
import 'package:cross_platform_flutter/src/shared/repository/landmark_repository.dart';
import 'package:flutter/foundation.dart';

/// ViewModel for the Create Landmark Screen.
class CreateViewModel extends ChangeNotifier {
  CreateViewModel({required this.landmarkRepository});

  final LandmarkRepository landmarkRepository;

  CreateScreenState state = const CreateScreenState();

  /// Creates a new landmark with the provided data.
  Future<void> onCreateLandmark(
    String name,
    String description,
    String? imageUrl,
  ) async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );
    notifyListeners();

    try {
      // Validate input
      if (name.trim().isEmpty || description.trim().isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Name and description cannot be empty',
        );
        notifyListeners();
        return;
      }

      final newLandmark = await landmarkRepository.createLandmark(
        name.trim(),
        description.trim(),
        imageUrl: imageUrl ?? '',
      );

      state = state.copyWith(
        isLoading: false,
        hasError: false,
        isSuccess: true,
        createdLandmarkId: newLandmark.id,
      );
      notifyListeners();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to create landmark: ${e.toString()}',
      );
      notifyListeners();
    }
  }
}
