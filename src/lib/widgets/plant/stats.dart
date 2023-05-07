import 'package:flutter/material.dart';
import 'package:plant_tracker/widgets/stat_info.dart';

class PlantStatInfo extends StatelessWidget {
  final int totalPlants;
  final int totalTasks;

  const PlantStatInfo({
    required this.totalPlants,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatisticInfo(
                      label: 'Plants',
                      count: totalPlants,
                    ),
                    StatisticInfo(
                      label: 'Tasks',
                      count: totalTasks,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
