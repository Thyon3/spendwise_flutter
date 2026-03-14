import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final ChartType chartType;
  final Color? primaryColor;
  final bool showGrid;
  final bool showLegend;

  const ExpenseChart({
    Key? key,
    required this.data,
    required this.title,
    this.chartType = ChartType.bar,
    this.primaryColor,
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (chartType) {
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.line:
        return _buildLineChart();
      case ChartType.pie:
        return _buildPieChart();
      case ChartType.doughnut:
        return _buildDoughnutChart();
    }
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
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
                    data[value.toInt()]['label'] ?? '',
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
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: data.map((item) {
          return BarChartGroupData(
            x: data.indexOf(item).toDouble(),
            barRods: [
              BarChartRodData(
                toY: item['value'].toDouble(),
                color: primaryColor ?? Colors.blue,
                width: 16,
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
              final item = data[group.x.toInt()];
              return BarTooltipItem(
                '${item['label']}: \$${item['value']}',
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

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: showGrid,
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
                    data[value.toInt()]['label'] ?? '',
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
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value['value'].toDouble());
            }).toList(),
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
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItem: (spot, barData, barIndex) {
              final item = data[spot.x.toInt()];
              return LineTooltipItem(
                '${item['label']}: \$${item['value']}',
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

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchTooltipData: PieTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItem: (group) {
              final item = data[group.x.toInt()];
              return PieTooltipItem(
                '${item['label']}: \$${item['value']}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
        sections: data.map((item) {
          return PieChartSectionData(
            color: _getSectionColor(data.indexOf(item)),
            value: item['value'].toDouble(),
            title: '${item['label']}\n\$${item['value']}',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDoughnutChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchTooltipData: PieTouchTooltipData(
            getTooltipColor: (_) => Colors.black87,
            getTooltipItem: (group) {
              final item = data[group.x.toInt()];
              return PieTooltipItem(
                '${item['label']}: \$${item['value']}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: data.map((item) {
          return PieChartSectionData(
            color: _getSectionColor(data.indexOf(item)),
            value: item['value'].toDouble(),
            title: '${item['label']}',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
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
    ];
    return colors[index % colors.length];
  }
}

enum ChartType {
  bar,
  line,
  pie,
  doughnut,
}
