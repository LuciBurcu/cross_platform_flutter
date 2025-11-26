import 'package:cross_platform_flutter/src/homescreen/repository/landmark_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Viewmodel for the Details Screen
///
/// It holds the state of the screen and exposes methods (events)
class DetailsViewModel extends ChangeNotifier {
  DetailsViewModel({required this.landmarkRepository});

  final LandmarkRepository landmarkRepository;

  /// State of the Details Screen
  /// It will be null when the screen is first created and
  /// until the landmark data is loaded.
  DetailsScreenState? detailsScreenState;

  // It is a good practice to prefix with "on" the methods that are
  // triggered by UI events (e.g., user interactions, lifecycle events).
  void onLoadLandmark(String id) async {
    // Simulate a network delay typically seen in real-world applications with
    // interactions in a backend or database.
    await Future.delayed(Duration(seconds: 2));
    final landmark = landmarkRepository.getLandmarkById(id);
    detailsScreenState = DetailsScreenState(
      title: landmark.name,
      description: landmark.description,
    );
    notifyListeners();
  }

  void onDisposed() {
    detailsScreenState = null;
    notifyListeners();
  }
}

/// State class representing the data needed for the Details Screen
///
/// It extends [Equatable] to facilitate easy comparison and testing.
class DetailsScreenState extends Equatable {
  const DetailsScreenState({required this.title, required this.description});

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
