import 'package:cross_platform_flutter/src/homescreen/models/landmark.dart';
import 'package:cross_platform_flutter/src/homescreen/repository/landmark_repository.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key, required this.landmarkRepository});

  final LandmarkRepository landmarkRepository;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late List<Landmark> _landmarks;

  @override
  void initState() {
    super.initState();
    _landmarks = widget.landmarkRepository.getLandmarks();
  }

  void _onCreateLandmark() {
    final newLandmark = widget.landmarkRepository.createLandmark(
      'Nume hardcodat',
      'Descriere hardcodată',
    );
    _landmarks.add(newLandmark);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Home Screen', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: _landmarks.length,
        itemBuilder: (context, index) {
          final landmark = _landmarks[index];

          return ListTile(
            title: Text(landmark.name),
            subtitle: Text(landmark.description),
            leading: CircleAvatar(child: Text(landmark.id)),
            trailing: Icon(Icons.chevron_right),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateLandmark,
        child: Icon(Icons.add),
      ),
    );
  }
}
