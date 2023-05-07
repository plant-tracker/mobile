import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

export './details.dart';
export './add.dart';
export './edit.dart';

import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/plant/card.dart';
import 'package:plant_tracker/widgets/total_progress.dart';

class PlantsPage extends ConsumerWidget {
  const PlantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsAsyncValue = ref.watch(firestoreGetPlantsProvider);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            plantsAsyncValue.when(
              data: (plants) {
                if (plants.isEmpty) {
                  return const Center(
                    child: Text('You have no plants.'),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: TotalProgressCard(
                        count: plants.length,
                        maxCount: 50,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: plants.length,
                        itemBuilder: (context, index) {
                          final plant = plants[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
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
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => const Center(
                child: Text('Error loading plants'),
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  context.go('/plants/add');
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}
