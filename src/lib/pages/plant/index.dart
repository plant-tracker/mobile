import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

export './details.dart';
export './add.dart';
export './edit.dart';

import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/plant/card.dart';
import 'package:plant_tracker/widgets/stat_count.dart';

class PlantsPage extends ConsumerWidget {
  const PlantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsAsyncValue = ref.watch(firestoreGetPlantsProvider);

    return Scaffold(
      body: plantsAsyncValue.when(
        data: (plants) {
          if (plants.isEmpty) {
            return const Center(
              child: Text('You have no plants.'),
            );
          }

          final plantCount = plants.length;
          final maxPlantCount = 50;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CountWidget(
                  count: plantCount,
                  maxCount: maxPlantCount,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PlantCard(
                          plant: plant,
                          onTap: () {
                            context.go('/plants/${plant.id}');
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const Center(
          child: Text('Error loading plants'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/plants/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
