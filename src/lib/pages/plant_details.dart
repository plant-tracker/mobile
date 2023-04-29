import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:plant_tracker/models/plant.dart';
import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/preferences_card.dart';
import 'package:plant_tracker/widgets/plant_card.dart';

class PlantDetailsPage extends ConsumerWidget {
  const PlantDetailsPage({required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsyncValue = ref.watch(firestorePlantProvider(plantId));
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
                                  Icon(Icons.calendar_today, size: 24),
                                  const SizedBox(width: 8),
                                  Text('Creation Date: ${plant.created}'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              PreferencesCard(
                                humidity: describeEnum(plant.humidity),
                                lightLevels: describeEnum(plant.lightLevels),
                                temperature: describeEnum(plant.temperature),
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
