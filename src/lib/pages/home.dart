import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/plant/stats.dart';


class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DocumentSnapshot<Map<String, dynamic>>> userData = ref.watch(userDataProvider);

    return userData.when(
      data: (data) {
        final totalPlants = data.data()!.containsKey('total_plants') ? data!['total_plants'] as int : 0;
        final totalTasks = data.data()!.containsKey('total_tasks') ? data!['total_tasks'] as int : 0;

        return PlantStats(
            totalPlants: totalPlants,
            totalTasks: totalTasks,
          );

      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}