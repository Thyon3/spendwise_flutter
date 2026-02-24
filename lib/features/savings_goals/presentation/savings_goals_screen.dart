import 'package:flutter/material.dart';

class SavingsGoalsScreen extends StatelessWidget {
  const SavingsGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add goal screen
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 0,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: const Text('Goal Name'),
              subtitle: const Text('Progress: 0%'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to goal details
              },
            ),
          );
        },
      ),
    );
  }
}
