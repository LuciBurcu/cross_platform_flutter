import 'package:cross_platform_flutter/src/details/screens/details_screen.dart';
import 'package:cross_platform_flutter/src/details/viewmodel/details_view_model.dart';
import 'package:cross_platform_flutter/src/homescreen/datasources/db/landmark_local_db.dart';
import 'package:cross_platform_flutter/src/homescreen/repository/landmark_repository.dart';
import 'package:cross_platform_flutter/src/homescreen/screens/homescreen.dart';
import 'package:cross_platform_flutter/src/homescreen/viewmodel/homescreen_viewmodel.dart';
import 'package:flutter/material.dart';

/// Main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final landmarkDatabase = LandmarkDatabase();
  // Initiate dependencies in the main app.
  // NOTE: In a real app, you might want to use a Dependency Injection framework
  // or at least a more complex setup for managing dependencies.
  final landmarkRepository = LandmarkRepository(
    landmarkDatabase: landmarkDatabase,
  );

  await landmarkRepository.createLandmark('Great wall of China', 'Description');
  await landmarkRepository.createLandmark(
    'Great wall of China 1',
    'Description 1',
  );
  await landmarkRepository.createLandmark(
    'Great wall of China 2',
    'Description 2',
  );

  // ViewModels ideally should be created per screen lifecycle rather than standalone
  // instances, but for simplicity, we create it here.
  final detailsViewModel = DetailsViewModel(
    landmarkRepository: landmarkRepository,
  );
  final homescreenViewModel = HomescreenViewModel(
    landmarkRepository: landmarkRepository,
  );
  runApp(
    MyApp(
      landmarkRepository: landmarkRepository,
      detailsViewModel: detailsViewModel,
      homescreenViewModel: homescreenViewModel,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.landmarkRepository,
    required this.detailsViewModel,
    required this.homescreenViewModel,
  });

  final LandmarkRepository landmarkRepository;
  final DetailsViewModel detailsViewModel;
  final HomescreenViewModel homescreenViewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      // Required to set the initial screen when using `routes` approach
      initialRoute: '/home',
      // By using named `routes`, we map a screen to an identifier
      routes: {
        '/home': (context) =>
            Homescreen(homescreenViewModel: homescreenViewModel),
        '/details': (context) =>
            DetailsScreen(detailsViewModel: detailsViewModel),
      },
    );
  }
}
