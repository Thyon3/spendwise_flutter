import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final String? subtitle;
  final Color? primaryColor;
  final bool showGrid;
  final bool showLegend;
  final bool showAverage;
  final bool showPrediction;
  final int? predictionMonths;

  const SpendingTrendChart({
    Key? key,
    required this.data,
    required this.title,
    this.subtitle,
    this.primaryColor,
    this.showGrid = true,
    this.showLegend = true,
    this.showAverage = true,
    this.showPrediction = false,
    this.predictionMonths = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: _buildChart(),
          ),
          if (showLegend) ...[
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChart() {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['amount'].toDouble());
    }).toList();

    final average = data.isNotEmpty 
        ? data.reduce((sum, item) => sum + item['amount'], 0) / data.length 
        : 0.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: showGrid,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    data[value.toInt()]?['label'] ?? '',
                    style: style,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '\$${value.toInt()}',
                    style: style,
                  ),
                );
              },
              reservedSize: 60,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: _getMaxY(),
        lineBarsData: [
          // Main spending line
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: primaryColor ?? Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: primaryColor ?? Colors.blue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: (primaryColor ?? Colors.blue).withOpacity(0.2),
            ),
          ),
          // Average line
          if (showAverage)
            LineChartBarData(
              spots: [
                FlSpot(0, average),
                FlSpot((data.length - 1).toDouble(), average),
              ],
              isCurved: false,
              color: Colors.orange,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              dashArray: [5, 5],
            ),
          // Prediction line
          if (showPrediction)
            LineChartBarData(
              spots: _getPredictionSpots(),
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.green,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              dashArray: [3, 3],
            ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItem: (spot, barData, barIndex) {
              final item = data[spot.x.toInt()];
              return LineTooltipItem(
                '${item['label']}: \$${item['amount']}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem(
          context,
          'Spending',
          primaryColor ?? Colors.blue,
        ),
        if (showAverage)
          _buildLegendItem(
            context,
            'Average',
            Colors.orange,
          ),
        if (showPrediction)
          _buildLegendItem(
            context,
            'Prediction',
            Colors.green,
          ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  double _getMaxY() {
    if (data.isEmpty) return 100;
    
    final maxValue = data
        .map((item) => item['amount'] as double)
        .reduce((a, b) => a > b ? a : b);
    
    // Add 20% padding
    return maxValue * 1.2;
  }

  List<FlSpot> _getPredictionSpots() {
    if (data.isEmpty || predictionMonths == null) return [];
    
    final spots = <FlSpot>[];
    final lastX = (data.length - 1).toDouble();
    final lastAmount = data.last['amount'] as double;
    
    // Simple linear prediction (in real app, use ML model)
    for (int i = 1; i <= predictionMonths!; i++) {
      final predictedAmount = lastAmount * (1 + (0.05 * i)); // 5% growth per month
      spots.add(FlSpot(lastX + i, predictedAmount));
    }
    
    return spots;
  }
}

class CategorySpendingChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final String? subtitle;
  final Color? primaryColor;
  final bool showGrid;
  final bool showLegend;
  final bool showPercentages;

  const CategorySpendingChart({
    Key? key,
    required this.data,
    required this.title,
    this.subtitle,
    this.primaryColor,
    this.showGrid = true,
    this.showLegend = true,
    this.showPercentages = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: _buildChart(),
          ),
          if (showLegend) ...[
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchTooltipData: PieTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItem: (group) {
              final item = data[group.x.toInt()];
              final percentage = ((item['amount'] / _getTotalAmount()) * 100).toStringAsFixed(1);
              return PieTooltipItem(
                '${item['category']}: \$${item['amount']} ($percentage%)',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final percentage = (item['amount'] / _getTotalAmount()) * 100;
          
          return PieChartSectionData(
            color: _getSectionColor(index),
            value: item['amount'].toDouble(),
            title: showPercentages ? '${percentage.toStringAsFixed(0)}%' : '',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titlePositionPercentageOffset: 0.6,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildLegendItem(
          context,
          item['category'],
          _getSectionColor(index),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  double _getTotalAmount() {
    return data.fold(0.0, (sum, item) => sum + item['amount']);
  }

  Color _getSectionColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}

class MonthlyComparisonChart extends StatelessWidget {
  final List<Map<String, dynamic>> currentMonthData;
  final List<Map<String, dynamic>> previousMonthData;
  final String title;
  final String? subtitle;
  final Color? currentMonthColor;
  final Color? previousMonthColor;
  final bool showGrid;
  final bool showLegend;

  const MonthlyComparisonChart({
    Key? key,
    required this.currentMonthData,
    required this.previousMonthData,
    required this.title,
    this.subtitle,
    this.currentMonthColor,
    this.previousMonthColor,
    this.showGrid = true,
    this.showLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: _buildChart(),
          ),
          if (showLegend) ...[
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChart() {
    final maxY = _getMaxY();
    
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: showGrid,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    currentMonthData[value.toInt()]?['label'] ?? '',
                    style: style,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '\$${value.toInt()}',
                    style: style,
                  ),
                );
              },
              reservedSize: 60,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minY: 0,
        maxY: maxY,
        barGroups: currentMonthData.asMap().entries.map((entry) {
          final index = entry.key;
          final currentItem = entry.value;
          final previousItem = previousMonthData[index];
          
          return BarChartGroupData(
            x: index.toDouble(),
            barRods: [
              BarChartRodData(
                toY: currentItem['amount'].toDouble(),
                color: currentMonthColor ?? Colors.blue,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: previousItem['amount']?.toDouble() ?? 0,
                color: previousMonthColor ?? Colors.orange,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final isCurrentMonth = rodIndex == 0;
              final data = isCurrentMonth ? currentMonthData[group.x.toInt()] : previousMonthData[group.x.toInt()];
              return BarTooltipItem(
                '${data['label']}: \$${data['amount']}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem(
          context,
          'Current Month',
          currentMonthColor ?? Colors.blue,
        ),
        _buildLegendItem(
          context,
          'Previous Month',
          previousMonthColor ?? Colors.orange,
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  double _getMaxY() {
    final allAmounts = [
      ...currentMonthData.map((item) => item['amount'] as double),
      ...previousMonthData.map((item) => item['amount'] as double),
    ];
    
    if (allAmounts.isEmpty) return 100;
    
    final maxValue = allAmounts.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.2;
  }
}
