import 'package:cross_platform_flutter/src/details/screens/details_screen.dart';
import 'package:cross_platform_flutter/src/details/viewmodel/details_view_model.dart';
import 'package:cross_platform_flutter/src/homescreen/repository/landmark_repository.dart';
import 'package:cross_platform_flutter/src/homescreen/screens/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  final landmarkRepository = LandmarkRepository();
  final detailsViewModel = DetailsViewModel(
    landmarkRepository: landmarkRepository,
  );
  runApp(
    MyApp(
      landmarkRepository: landmarkRepository,
      detailsViewModel: detailsViewModel,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.landmarkRepository,
    required this.detailsViewModel,
  });

  final LandmarkRepository landmarkRepository;
  final DetailsViewModel detailsViewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) =>
            Homescreen(landmarkRepository: landmarkRepository),
        '/details': (context) =>
            DetailsScreen(detailsViewModel: detailsViewModel),
      },
    );
  }
}
