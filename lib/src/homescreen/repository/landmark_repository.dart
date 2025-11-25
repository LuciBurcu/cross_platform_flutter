import 'package:cross_platform_flutter/src/homescreen/models/landmark.dart';

class LandmarkRepository {
  final List<Landmark> _landmarks = [
    const Landmark(
      id: '1',
      name: 'Great Wall of China',
      description: 'This is in China',
    ),
    const Landmark(
      id: '2',
      name: 'Eiffel Tower',
      description: 'This is in France',
    ),
    const Landmark(id: '3', name: 'Colosseum', description: 'This is in Italy'),
  ];

  // R

  List<Landmark> getLandmarks() {
    return _landmarks;
  }

  Landmark getLandmarkById(String id) {
    return _landmarks.firstWhere((landmark) => landmark.id == id);
  }

  Landmark createLandmark(String name, String description) {
    final newLandmark = Landmark(
      id: (_landmarks.length + 1).toString(),
      name: name,
      description: description,
    );
    _landmarks.add(newLandmark);
    return newLandmark;
  }

  Landmark updateLandmark(String id, String name, String description) {
    final index = _landmarks.indexWhere((landmark) => landmark.id == id);
    if (index != -1) {
      final updatedLandmark = Landmark(
        id: id,
        name: name,
        description: description,
      );
      _landmarks[index] = updatedLandmark;
      return updatedLandmark;
    }
    throw Exception('Landmark not found');
  }

  void deleteLandmark(String id) {
    _landmarks.removeWhere((landmark) => landmark.id == id);
  }
}
