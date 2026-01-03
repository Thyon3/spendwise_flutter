import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../application/reports_notifier.dart';
import '../../domain/entities/report.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _granularity = 'week';

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadReports);
  }

  void _loadReports() {
    ref.read(reportsSummaryProvider.notifier).loadSummary(
          from: _startDate,
          to: _endDate,
        );
    ref.read(reportsTrendsProvider.notifier).loadTrends(
          from: _startDate,
          to: _endDate,
          granularity: _granularity,
        );
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(reportsSummaryProvider);
    final trendsAsync = ref.watch(reportsTrendsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Analytics'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadReports(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryHeader(summaryAsync),
              const SizedBox(height: 24),
              _buildTrendsSection(trendsAsync),
              const SizedBox(height: 24),
              _buildCategoryBreakdownSection(summaryAsync),
              const SizedBox(height: 24),
              _buildTagBreakdownSection(summaryAsync),
              const SizedBox(height: 80), // Space for bottom
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (range != null) {
      setState(() {
        _startDate = range.start;
        _endDate = range.end;
      });
      _loadReports();
    }
  }

  Widget _buildSummaryHeader(AsyncValue<TimeRangeReport> summaryAsync) {
    return summaryAsync.when(
      data: (summary) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Total Expenses',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${summary.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${DateFormat.yMMMd().format(_startDate)} - ${DateFormat.yMMMd().format(_endDate)}',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
      loading: () => _buildShimmer(150),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildTrendsSection(AsyncValue<TrendReport> trendsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            const Text('Spending Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _granularity,
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _granularity = val);
                  _loadReports();
                }
              },
              items: const [
                DropdownMenuItem(value: 'day', child: Text('Daily')),
                DropdownMenuItem(value: 'week', child: Text('Weekly')),
                DropdownMenuItem(value: 'month', child: Text('Monthly')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: trendsAsync.when(
            data: (report) => report.trends.isEmpty
                ? const Center(child: Text('No trend data for this period.'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: report.trends.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value.totalAmount);
                          }).toList(),
                          isCurved: true,
                          color: Colors.deepPurple,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.deepPurple.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error loading trends: $e'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdownSection(AsyncValue<TimeRangeReport> summaryAsync) {
    return summaryAsync.when(
      data: (summary) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('By Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (summary.categoryBreakdown.isEmpty)
            const Text('No categories found.')
          else ...[
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: summary.categoryBreakdown.asMap().entries.map((e) {
                    final cat = e.value;
                    final colors = [
                      Colors.blue, Colors.red, Colors.green, Colors.orange, 
                      Colors.purple, Colors.teal, Colors.pink, Colors.amber
                    ];
                    return PieChartSectionData(
                      color: colors[e.key % colors.length],
                      value: cat.totalAmount,
                      title: '${cat.percentageOfTotal.toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...summary.categoryBreakdown.map((cat) => _buildBreakdownRow(
                  name: cat.categoryName,
                  amount: cat.totalAmount,
                  percentage: cat.percentageOfTotal,
                )),
          ],
        ],
      ),
      loading: () => _buildShimmer(200),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildTagBreakdownSection(AsyncValue<TimeRangeReport> summaryAsync) {
    return summaryAsync.when(
      data: (summary) => summary.tagBreakdown.isEmpty
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('By Tag', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...summary.tagBreakdown.map((tag) => _buildBreakdownRow(
                      name: tag.tagName,
                      amount: tag.totalAmount,
                      percentage: tag.percentageOfTotal,
                    )),
              ],
            ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildBreakdownRow({required String name, required double amount, required double percentage}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.withOpacity(0.7)),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${percentage.toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
