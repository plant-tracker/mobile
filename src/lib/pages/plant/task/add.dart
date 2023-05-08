import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/widgets/task/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/models/plant.dart';
import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/plant/form.dart';

class TaskAddPage extends ConsumerWidget {
  const TaskAddPage({Key? key, required this.plantId}) : super(key: key);

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Plant?> plant =
        ref.watch(firestoreGetPlantProvider(plantId));
    return plant.when(
      data: (plantData) => Center(child: TaskForm(plantId: plantId)),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
