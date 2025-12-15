import 'package:cross_platform_flutter/src/homescreen/viewmodel/homescreen_viewmodel.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key, required this.homescreenViewModel});

  final HomescreenViewModel homescreenViewModel;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    widget.homescreenViewModel.onLoadLandmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Home Screen', style: TextStyle(color: Colors.white)),
      ),
      body: ListenableBuilder(
        listenable: widget.homescreenViewModel,
        builder: (context, child) {
          final state = widget.homescreenViewModel.homeScreenState;
          if (state == null) {
            return Center(child: CircularProgressIndicator());
          }
          final landmarks = state.landmarks;

          return ListView.builder(
            itemCount: landmarks.length,
            itemBuilder: (context, index) {
              final landmark = landmarks[index];

              return ListTile(
                title: Text(landmark.name),
                subtitle: Text(landmark.description),
                leading: CircleAvatar(child: Text(landmark.id)),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed('/details', arguments: landmark.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
