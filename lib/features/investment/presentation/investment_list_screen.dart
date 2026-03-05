import 'package:flutter/material.dart';

class InvestmentListScreen extends StatelessWidget {
  const InvestmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add investment screen
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPortfolioSummary(context),
          const SizedBox(height: 16),
          _buildInvestmentCard(
            context,
            name: 'Apple Inc.',
            symbol: 'AAPL',
            quantity: 10,
            purchasePrice: 150,
            currentPrice: 175,
          ),
          const SizedBox(height: 12),
          _buildInvestmentCard(
            context,
            name: 'Bitcoin',
            symbol: 'BTC',
            quantity: 0.5,
            purchasePrice: 40000,
            currentPrice: 45000,
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio Value',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$24,250',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.green, size: 20),
                const SizedBox(width: 4),
                Text(
                  '+\$2,750 (12.8%)',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentCard(
    BuildContext context, {
    required String name,
    required String symbol,
    required double quantity,
    required double purchasePrice,
    required double currentPrice,
  }) {
    final totalValue = quantity * currentPrice;
    final totalCost = quantity * purchasePrice;
    final profitLoss = totalValue - totalCost;
    final profitLossPercentage = (profitLoss / totalCost) * 100;
    final isProfit = profitLoss >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      symbol,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${totalValue.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${quantity.toStringAsFixed(2)} @ \$${currentPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isProfit ? Icons.trending_up : Icons.trending_down,
                  color: isProfit ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isProfit ? '+' : ''}\$${profitLoss.toStringAsFixed(2)} (${profitLossPercentage.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: isProfit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
