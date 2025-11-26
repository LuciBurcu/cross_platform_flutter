import 'package:cross_platform_flutter/src/details/viewmodel/details_view_model.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.detailsViewModel});

  final DetailsViewModel detailsViewModel;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final landmarkId = ModalRoute.of(context)!.settings.arguments as String;
    widget.detailsViewModel.loadLandmark(landmarkId);
  }

  @override
  void dispose() {
    super.dispose();
    widget.detailsViewModel.onDisposed();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.detailsViewModel,
      builder: (innerContext, child) {
        final state = widget.detailsViewModel.detailsScreenState;

        if (state == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Loading..."),
              backgroundColor: Colors.green,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Details screen for ${state.title}"),
            backgroundColor: Colors.green,
          ),
          body: Column(
            children: [
              Text('Description about ${state.description}'),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Go back'),
              ),
              FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Are you sure you want to delete this item?'),
                      actions: [
                        FilledButton(onPressed: () {}, child: Text('Cancel')),
                        FilledButton(onPressed: () {}, child: Text('Yes')),
                      ],
                    ),
                  );
                },
                child: Text('Show dialog'),
              ),
            ],
          ),
        );
      },
    );
  }
}
