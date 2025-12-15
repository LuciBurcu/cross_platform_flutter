import 'package:cross_platform_flutter/src/homescreen/models/landmark.dart';
import 'package:cross_platform_flutter/src/homescreen/repository/landmark_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HomescreenViewModel extends ChangeNotifier {
  HomescreenViewModel({required this.landmarkRepository});

  final LandmarkRepository landmarkRepository;

  HomeScreenState? homeScreenState;

  void onLoadLandmarks() async {
    final landmarks = await landmarkRepository.getLandmarks();
    homeScreenState = HomeScreenState(landmarks: landmarks);
    notifyListeners();
  }
}

class HomeScreenState extends Equatable {
  const HomeScreenState({required this.landmarks});

  final List<Landmark> landmarks;

  @override
  List<Object?> get props => [landmarks];
}
