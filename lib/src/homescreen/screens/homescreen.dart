import 'package:cross_platform_flutter/src/homescreen/viewmodel/homescreen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/navigation/app_routes.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomescreenViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home screen')),
      floatingActionButton: IconButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(AppRoutes.create);
          viewModel.onLoadLandmarks();
        },
        icon: Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          final state = viewModel.state;
          final landmarks = state.landmarks;
          if (state.isLoading) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: landmarks.length,
            itemBuilder: (context, index) {
              final landmark = landmarks[index];

              return ListTile(
                title: Text(landmark.name),
                subtitle: Text(landmark.description),
                leading: CircleAvatar(
                  backgroundImage: Image.network(
                    landmark.imageUrl,
                    fit: BoxFit.fill,
                  ).image,
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.details, arguments: landmark.id);
                  viewModel.onLoadLandmarks();
                },
              );
            },
          );
        },
      ),
    );
  }
}
