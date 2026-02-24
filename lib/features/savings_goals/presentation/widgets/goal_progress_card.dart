import 'package:flutter/material.dart';

class GoalProgressCard extends StatelessWidget {
  final String goalName;
  final double currentAmount;
  final double targetAmount;
  final String currency;
  final double progress;

  const GoalProgressCard({
    super.key,
    required this.goalName,
    required this.currentAmount,
    required this.targetAmount,
    required this.currency,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goalName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$currency ${currentAmount.toStringAsFixed(2)}'),
                Text('${progress.toStringAsFixed(1)}%'),
                Text('$currency ${targetAmount.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
