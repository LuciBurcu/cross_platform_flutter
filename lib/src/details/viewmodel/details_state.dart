import 'package:equatable/equatable.dart';

/// UI state for the Details Screen.
/// See README.md for documentation on Equatable and copyWith patterns.
class DetailsScreenState extends Equatable {
  const DetailsScreenState({
    this.isLoading = true,
    this.hasError = false,
    this.errorMessage,
    this.landmarkId,
    this.title,
    this.description,
    this.imageUrl,
  });

  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? landmarkId;
  final String? title;
  final String? description;
  final String? imageUrl;

  DetailsScreenState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? landmarkId,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return DetailsScreenState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      landmarkId: landmarkId ?? this.landmarkId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    hasError,
    errorMessage,
    landmarkId,
    title,
    description,
    imageUrl,
  ];
}
