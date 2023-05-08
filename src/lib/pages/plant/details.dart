import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/plant/preferences_card.dart';
import 'package:plant_tracker/widgets/plant/card.dart';
import 'package:plant_tracker/widgets/plant/delete.dart';
import 'package:plant_tracker/widgets/plant/type_card.dart';

import 'package:plant_tracker/widgets/plant/tasks_list.dart';

class PlantDetailsPage extends ConsumerWidget {
  const PlantDetailsPage({Key? key, required this.plantId}) : super(key: key);

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantAsyncValue = ref.watch(firestoreGetPlantProvider(plantId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        plantAsyncValue.when(
          data: (data) {
            return Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                children: [
                  Text(
                    'General',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  PlantCard(
                    plant: data!,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 24),
                      const SizedBox(width: 8),
                      Text('Creation Date: ${data.created}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: PlantPreferencesCard(
                      humidity: describeEnum(data!.humidity),
                      lightLevels: describeEnum(data!.lightLevels),
                      temperature: describeEnum(data!.temperature),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PlantTypeCard(plantType: describeEnum(data!.type)),
                  SizedBox(height: 16),
                  Text(
                    'Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go("/plants/$plantId/edit");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => DeletePlantModal(
                                plantId: plantId,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go("/plants/$plantId/task/add");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent[700]!,
                          ),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Add task'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PlantTasksList(
                    plantId: plantId,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Text('Error: $error'),
        ),
      ],
    );
  }
}
