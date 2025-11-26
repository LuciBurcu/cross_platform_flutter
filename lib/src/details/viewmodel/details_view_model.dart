import 'package:cross_platform_flutter/src/homescreen/repository/landmark_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DetailsViewModel extends ChangeNotifier {
  DetailsViewModel({required this.landmarkRepository});

  final LandmarkRepository landmarkRepository;

  DetailsScreenState? detailsScreenState;

  void loadLandmark(String id) async {
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

class DetailsScreenState extends Equatable {
  const DetailsScreenState({required this.title, required this.description});

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
