import 'package:cross_platform_flutter/src/create/screens/create_screen.dart';
import 'package:cross_platform_flutter/src/create/viewmodels/create_view_model.dart';
import 'package:cross_platform_flutter/src/details/screens/details_screen.dart';
import 'package:cross_platform_flutter/src/details/viewmodel/details_view_model.dart';
import 'package:cross_platform_flutter/src/homescreen/screens/homescreen.dart';
import 'package:cross_platform_flutter/src/homescreen/viewmodel/homescreen_viewmodel.dart';
import 'package:cross_platform_flutter/src/shared/datasources/db/landmark_local_db.dart';
import 'package:cross_platform_flutter/src/shared/datasources/network/landmark_network.dart';
import 'package:cross_platform_flutter/src/shared/navigation/app_routes.dart';
import 'package:cross_platform_flutter/src/shared/repository/landmark_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final landmarkDatabase = LandmarkDatabase();
  final landmarkNetwork = LandmarkNetwork();

  final landmarkRepository = LandmarkRepository(
    landmarkDatabase: landmarkDatabase,
    landmarkNetwork: landmarkNetwork,
  );

  runApp(MyApp(landmarkRepository: landmarkRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.landmarkRepository});

  final LandmarkRepository landmarkRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cross-Platform Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Required to set the initial screen when using `routes` approach
      initialRoute: AppRoutes.home,
      // By using named `routes`, we map a screen to an identifier
      routes: {
        AppRoutes.home: (context) => ListenableProvider(
          create: (_) =>
              HomescreenViewModel(landmarkRepository: landmarkRepository)
                ..onLoadLandmarks(),
          child: Homescreen(),
        ),
        AppRoutes.details: (context) {
          final landmarkId =
              ModalRoute.of(context)!.settings.arguments as String;

          return ListenableProvider(
            create: (_) => DetailsViewModel(
              landmarkId: landmarkId,
              landmarkRepository: landmarkRepository,
            )..onLoadLandmark(),
            child: DetailsScreen(),
          );
        },
        AppRoutes.create: (context) => ListenableProvider(
          create: (_) =>
              CreateViewModel(landmarkRepository: landmarkRepository),
          child: CreateScreen(),
        ),
      },
    );
  }
}
