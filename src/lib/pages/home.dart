import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/providers/auth.dart';
import 'package:plant_tracker/widgets/plant/stats.dart';
import 'package:plant_tracker/widgets/notification_list.dart';

import 'package:plant_tracker/models/user_data.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserData> userData = ref.watch(userDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userData.when(
          data: (data) {
            final totalPlants = data.plantTotals;
            final totalTasks = data.taskTotals;

            return Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  PlantStatInfo(
                    totalPlants: totalPlants,
                    totalTasks: totalTasks,
                  ),
                  const SizedBox(height: 16),
                  NotificationList(),
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
