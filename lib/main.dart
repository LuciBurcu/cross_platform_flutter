import 'package:cross_platform_flutter/src/homescreen/repository/landmark_repository.dart';
import 'package:cross_platform_flutter/src/homescreen/screens/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: Homescreen(landmarkRepository: LandmarkRepository()),
    );
  }
}
