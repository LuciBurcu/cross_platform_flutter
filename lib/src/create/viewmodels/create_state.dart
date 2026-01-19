import 'package:equatable/equatable.dart';

/// UI state for the Create Landmark Screen.
class CreateScreenState extends Equatable {
  const CreateScreenState({
    this.isLoading = false,
    this.hasError = false,
    this.isSuccess = false,
    this.errorMessage,
    this.createdLandmarkId,
  });

  final bool isLoading;
  final bool hasError;
  final bool isSuccess;
  final String? errorMessage;
  final String? createdLandmarkId;

  CreateScreenState copyWith({
    bool? isLoading,
    bool? hasError,
    bool? isSuccess,
    String? errorMessage,
    String? createdLandmarkId,
  }) {
    return CreateScreenState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      createdLandmarkId: createdLandmarkId ?? this.createdLandmarkId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    hasError,
    isSuccess,
    errorMessage,
    createdLandmarkId,
  ];
}
