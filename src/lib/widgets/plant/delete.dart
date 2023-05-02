import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:plant_tracker/providers/firestore.dart';

class DeletePlantModal extends ConsumerWidget {
  const DeletePlantModal({
    Key? key,
    required this.plantId,
  }) : super(key: key);

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete Plant?'),
      content: const Text('Are you sure you want to delete your plant permanently?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              ref.read(firestoreDeletePlantProvider(plantId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Plant deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go("/plants");
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error deleting plant: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
