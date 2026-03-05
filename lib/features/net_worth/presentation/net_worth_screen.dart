import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NetWorthScreen extends StatelessWidget {
  const NetWorthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Net Worth'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNetWorthCard(context),
          const SizedBox(height: 16),
          _buildTrendChart(context),
          const SizedBox(height: 24),
          Text(
            'Assets',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildAssetCard(context, 'Cash & Savings', 15000, Colors.green),
          _buildAssetCard(context, 'Investments', 24250, Colors.blue),
          _buildAssetCard(context, 'Property', 250000, Colors.purple),
          const SizedBox(height: 24),
          Text(
            'Liabilities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildLiabilityCard(context, 'Credit Cards', 2500, Colors.red),
          _buildLiabilityCard(context, 'Loans', 15000, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildNetWorthCard(BuildContext context) {
    const totalAssets = 289250.0;
    const totalLiabilities = 17500.0;
    const netWorth = totalAssets - totalLiabilities;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Net Worth',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${netWorth.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assets',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '\$${totalAssets.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Liabilities',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '\$${totalLiabilities.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Worth Trend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 250),
                        FlSpot(1, 255),
                        FlSpot(2, 260),
                        FlSpot(3, 265),
                        FlSpot(4, 268),
                        FlSpot(5, 271),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, String name, double amount, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.account_balance_wallet, color: color),
        ),
        title: Text(name),
        trailing: Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildLiabilityCard(BuildContext context, String name, double amount, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.credit_card, color: color),
        ),
        title: Text(name),
        trailing: Text(
          '-\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
