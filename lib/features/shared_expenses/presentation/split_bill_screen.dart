import 'package:flutter/material.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  String splitType = 'EQUAL';
  final List<Map<String, dynamic>> participants = [
    {'name': 'John Doe', 'email': 'john@example.com', 'amount': 0.0},
    {'name': 'Jane Smith', 'email': 'jane@example.com', 'amount': 0.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split Bill'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$120.00',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Split Method',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'EQUAL', label: Text('Equal')),
                ButtonSegment(value: 'PERCENTAGE', label: Text('Percentage')),
                ButtonSegment(value: 'EXACT_AMOUNT', label: Text('Exact')),
              ],
              selected: {splitType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  splitType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Participants',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...participants.map((p) => _buildParticipantCard(p)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add participant
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Add Participant'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Save split bill
                },
                child: const Text('Split Bill'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantCard(Map<String, dynamic> participant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(participant['name'][0]),
        ),
        title: Text(participant['name']),
        subtitle: Text(participant['email']),
        trailing: splitType == 'EQUAL'
            ? const Text('\$60.00')
            : SizedBox(
                width: 80,
                child: TextField(
                  decoration: InputDecoration(
                    suffix: Text(splitType == 'PERCENTAGE' ? '%' : '\$'),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
      ),
    );
  }
}
