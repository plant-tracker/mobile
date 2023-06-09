import 'package:flutter/material.dart';

class PlantPreferencesCard extends StatelessWidget {
  const PlantPreferencesCard({
    Key? key,
    required this.humidity,
    required this.lightLevels,
    required this.temperature,
  }) : super(key: key);

  final String humidity;
  final String lightLevels;
  final String temperature;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPreferenceChip(
                  context,
                  icon: Icons.opacity,
                  value: humidity,
                  color: Colors.blue,
                ),
                _buildPreferenceChip(
                  context,
                  icon: Icons.lightbulb_outline,
                  value: lightLevels,
                  color: Colors.yellow[700]!,
                ),
                _buildPreferenceChip(
                  context,
                  icon: Icons.thermostat,
                  value: temperature,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceChip(
    BuildContext context, {
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Chip(
      backgroundColor: color,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
