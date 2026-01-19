import 'package:cross_platform_flutter/src/details/viewmodel/details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Details screen')),
      body: ListenableBuilder(
        listenable: viewModel,
        // We use _, __ for unused parameters
        builder: (_, __) {
          final state = viewModel.state;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.imageUrl != null)
                  Image.network(
                    state.imageUrl!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 16),
                Text(
                  state.title ?? 'No title',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  state.description ?? 'No description',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                if (state.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                FilledButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text(
                          'Are you sure you want to delete this item?',
                        ),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () async {
                              await viewModel.onDeleteLandmark();
                              if (context.mounted) {
                                Navigator.of(dialogContext).pop();
                                Navigator.of(context).pop();
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Yes, Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
