import 'package:cross_platform_flutter/src/shared/models/landmark.dart';
import 'package:equatable/equatable.dart';

/// UI state for the Home Screen.
/// See README.md for documentation on Equatable and copyWith patterns.
class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.isLoading = true,
    this.hasError = false,
    this.errorMessage,
    this.landmarks = const [],
  });

  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<Landmark> landmarks;

  HomeScreenState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    List<Landmark>? landmarks,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      landmarks: landmarks ?? this.landmarks,
    );
  }

  @override
  List<Object?> get props => [isLoading, hasError, errorMessage, landmarks];
}
