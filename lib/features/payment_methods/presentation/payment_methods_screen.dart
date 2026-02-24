import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add payment method
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaymentMethodCard(
            context,
            'Credit Card',
            '**** 1234',
            Icons.credit_card,
            true,
          ),
          _buildPaymentMethodCard(
            context,
            'Cash',
            '',
            Icons.money,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    String name,
    String lastDigits,
    IconData icon,
    bool isDefault,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(name),
        subtitle: lastDigits.isNotEmpty ? Text(lastDigits) : null,
        trailing: isDefault
            ? const Chip(
                label: Text('Default'),
                backgroundColor: Colors.green,
              )
            : null,
        onTap: () {
          // Navigate to edit
        },
      ),
    );
  }
}
