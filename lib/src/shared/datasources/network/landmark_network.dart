import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/landmark_dto.dart';

/// Network data source for landmarks using the REST API.
///
/// This class handles all HTTP communication with the backend server.
/// It returns [LandmarkDTO] objects which are then converted to domain
/// models by the repository.
///
/// ## Why inject http.Client?
/// - **Testability**: Pass a mock client in tests to simulate API responses
/// - **Flexibility**: Easily swap HTTP implementations if needed
///
/// See [LandmarkDTO] for the network model with JSON serialization.
/// See [Landmark] for the domain model used by ViewModels.
class LandmarkNetwork {
  LandmarkNetwork({http.Client? client, this.baseUrl = 'http://localhost:3000'})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  /// GET all landmarks from the server.
  Future<List<LandmarkDTO>> getLandmarks() async {
    final response = await _client.get(Uri.parse('$baseUrl/landmarks'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load landmarks: ${response.statusCode}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((json) => LandmarkDTO.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET a single landmark by [id] from the server.
  Future<LandmarkDTO?> getLandmarkById(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/landmarks/$id'));

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load landmark: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return LandmarkDTO.fromJson(json);
  }

  /// POST a new landmark to the server.
  Future<LandmarkDTO> createLandmark({
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/landmarks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create landmark: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return LandmarkDTO.fromJson(json);
  }

  /// PUT update a landmark on the server.
  Future<LandmarkDTO?> updateLandmark({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/landmarks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to update landmark: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return LandmarkDTO.fromJson(json);
  }

  /// DELETE a landmark from the server.
  Future<bool> deleteLandmark(String id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/landmarks/$id'));

    if (response.statusCode == 404) {
      return false;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to delete landmark: ${response.statusCode}');
    }

    return true;
  }
}
