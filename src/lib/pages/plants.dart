import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:plant_tracker/models/plant.dart';
import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/plant_card.dart';

class PlantsPage extends ConsumerWidget {
  const PlantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsAsyncValue = ref.watch(firestorePlantsProvider);

    return Scaffold(
      body: plantsAsyncValue.when(
        data: (plants) {
          if (plants.isEmpty) {
            return const Center(
              child: Text('You have no plants.'),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
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
