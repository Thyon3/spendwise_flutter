import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/reports_notifier.dart';

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
    _loadReports();
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
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _granularity,
            onSelected: (val) {
              setState(() => _granularity = val);
              _loadReports();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'day', child: Text('Daily')),
              const PopupMenuItem(value: 'week', child: Text('Weekly')),
              const PopupMenuItem(value: 'month', child: Text('Monthly')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadReports(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date Range Selector
            Card(
              child: ListTile(
                title: const Text('Date Range'),
                subtitle: Text(
                  '${DateFormat.yMMMd().format(_startDate)} - ${DateFormat.yMMMd().format(_endDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (range != null) {
                    setState(() {
                      _startDate = range.start;
                      _endDate = range.end;
                    });
                    _loadReports();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Summary Card
            summaryAsync.when(
              data: (summary) => Card(
                elevation: 4,
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Total Spending',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${summary.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (e, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $e', style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Breakdown
            summaryAsync.when(
              data: (summary) => summary.categoryBreakdown.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spending by Category',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...summary.categoryBreakdown.map(
                          (cat) => Card(
                            child: ListTile(
                              title: Text(cat.categoryName),
                              subtitle: LinearProgressIndicator(
                                value: cat.percentageOfTotal / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                              ),
                              trailing: Text(
                                '\$${cat.totalAmount.toStringAsFixed(2)}\n${cat.percentageOfTotal.toStringAsFixed(1)}%',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Trends
            trendsAsync.when(
              data: (trends) => trends.trends.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spending Trends ($_granularity)',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...trends.trends.map(
                          (point) => Card(
                            child: ListTile(
                              title: Text(DateFormat.yMMMd().format(point.periodStart)),
                              trailing: Text(
                                '\$${point.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error loading trends: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
