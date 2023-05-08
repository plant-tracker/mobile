import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/models/task.dart';
import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/task/card.dart';

class PlantTasksList extends ConsumerWidget {
  const PlantTasksList({Key? key, required this.plantId}) : super(key: key);

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantTasksAsyncValue = ref.watch(firestoreGetTasksProvider(plantId));

    return plantTasksAsyncValue.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks found.'),
          );
        }
        return SizedBox(
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskCard(
                task: task,
                onDelete: () async {
                  ref.read(firestoreDeleteTaskProvider({'plantId': plantId, 'taskId': task.id}));
                },
              );
            },
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text('Error loading tasks.'),
        );
      },
    );
  }
}
