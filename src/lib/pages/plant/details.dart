import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/plant/preferences_card.dart';
import 'package:plant_tracker/widgets/plant/card.dart';
import 'package:plant_tracker/widgets/plant/delete.dart';

class PlantDetailsPage extends ConsumerWidget {
  const PlantDetailsPage({super.key, required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsyncValue = ref.watch(firestoreGetPlantProvider(plantId));
    return plantAsyncValue.when(
      data: (plant) => plant != null
          ? Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PlantCard(
                                plant: plant,
                                onTap: () {},
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 24),
                                  const SizedBox(width: 8),
                                  Text('Creation Date: ${plant.created}'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              PlantPreferencesCard(
                                humidity: describeEnum(plant.humidity),
                                lightLevels: describeEnum(plant.lightLevels),
                                temperature: describeEnum(plant.temperature),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Actions',
                                      style:
                                          Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (_) => DeletePlantModal(
                                                  plantId: plantId),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          icon: const Icon(Icons.delete),
                                          label: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
