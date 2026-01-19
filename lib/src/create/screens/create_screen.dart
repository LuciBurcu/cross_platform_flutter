import 'package:cross_platform_flutter/src/create/viewmodels/create_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  /// TextEditingController is used to read and control text input fields.
  ///
  /// Why StatefulWidget? Controllers must be:
  /// - Created once (not on every rebuild)
  /// - Disposed when the widget is removed to avoid memory leaks
  ///
  /// StatefulWidget provides [initState] and [dispose] lifecycle methods for this.
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    // Create controllers inside initState to ensure they are only created once
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // Always dispose controllers to free resources and prevent memory leaks
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the ViewModel from the Provider by using `context.watch` extension method
    final viewModel = context.watch<CreateViewModel>();

    // Use [ListenableBuilder] to rebuild the UI when the ViewModel notifies listeners
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final state = viewModel.state;

        return Scaffold(
          appBar: AppBar(title: const Text('Create Landmark')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Landmark Name',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !state.isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !state.isLoading,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image url (optional)',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !state.isLoading,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          viewModel.onCreateLandmark(
                            _nameController.text,
                            _descriptionController.text,
                            _imageUrlController.text.isNotEmpty
                                ? _imageUrlController.text
                                : null,
                          );
                        },
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Landmark'),
                ),
                const SizedBox(height: 16),
                if (state.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                if (state.isSuccess)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Landmark created successfully!',
                          style: TextStyle(color: Colors.green.shade900),
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
