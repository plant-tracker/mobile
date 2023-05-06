import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  final int count;
  final int maxCount;

  const CountWidget({
    required this.count,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final countText = '$count/$maxCount';
    final percentage = count / maxCount;

    Color barColor = Colors.green;
    if (percentage >= 0.8) {
      barColor = Colors.red;
    } else if (percentage >= 0.5) {
      barColor = Colors.yellow;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total: $countText'),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(barColor),
        ),
      ],
    );
  }
}
