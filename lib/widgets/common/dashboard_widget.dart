import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardWidget extends StatefulWidget {
  final String userName;
  final Map<String, dynamic>? userProfile;
  final Map<String, dynamic>? dashboardData;
  final Function(String)? onNavigate;
  final Function(String)? onRefresh;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastSyncTime;
  final int? unreadNotifications;
  final bool isOnline;
  final String? currency;
  final Function()? onLogout;
  final Function()? onProfileTap;

  const DashboardWidget({
    Key? key,
    this.userName = 'User',
    this.userProfile,
    this.dashboardData,
    this.onNavigate,
    this.onRefresh,
    this.isLoading = false,
    this.errorMessage,
    this.lastSyncTime,
    this.unreadNotifications,
    this.isOnline = true,
    this.currency,
    this.onLogout,
    this.onProfileTap,
  }) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedTabIndex = 0;
  bool _isRefreshing = false;
  DateTime _selectedDateRange = DateTime.now();
  String _selectedPeriod = 'month';

  @override
  void initState() {
    super.initState();
    _selectedDateRange = DateTime.now();
    _selectedPeriod = 'month';
  }

  void _refreshData() {
    setState(() {
      _isRefreshing = true;
    });
    
    // Simulate refresh delay
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        _isRefreshing = false;
      });
    });
    
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: 'Dashboard',
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
              widget.onNavigate?.call('/notifications');
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
                onTap: () => widget.onProfileTap?.call(),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings),
                    const SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
                onTap: () {
                  widget.onNavigate?.call('/settings');
                },
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
                onTap: () => widget.onLogout?.call(),
              ),
            ],
          ),
        ],
      ),
      body: widget.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : widget.errorMessage != null
              ? _buildErrorState(context)
              : _buildDashboardContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: Icon(Icons.refresh),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            widget.errorMessage ?? 'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context),
            const SizedBox(height: 24),
            
            // Quick Stats
            _buildQuickStats(context),
            const SizedBox(height: 24),
            
            // Charts Section
            _buildChartsSection(context),
            const SizedBox(height: 24),
            
            // Recent Activity
            _buildRecentActivity(context),
            const SizedBox(height: 24),
            
            // Budget Overview
            _buildBudgetOverview(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    widget.userName[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${widget.userName}!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Here\'s your financial overview',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.isOnline ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Last sync: ${_formatDate(widget.lastSyncTime)}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (widget.unreadNotifications != null && widget.unreadNotifications! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.unreadNotifications} notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (widget.unreadNotifications != null && widget.unreadNotifications! > 0)
                  TextButton(
                    onPressed: () {
                      widget.onNavigate?.call('/notifications');
                    },
                    child: Text('View'),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final theme = Theme.of(context);
    final dashboardData = widget.dashboardData ?? {};
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Expenses',
                    '${dashboardData['totalExpenses'] ?? 0}',
                    Icons.trending_down,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Income',
                    '${dashboardData['totalIncome'] ?? 0}',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Net Savings',
                    '${dashboardData['netSavings'] ?? 0}',
                    Icons.savings,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'This Month',
                    '${dashboardData['thisMonthExpenses'] ?? 0}',
                    Icons.calendar_month,
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Budget Used',
                    '${dashboardData['budgetUsedPercentage'] ?? 0}%',
                    Icons.pie_chart,
                    _getBudgetUsedColor(dashboardData['budgetUsedPercentage']),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context) {
    final theme = Theme.of(context);
    final dashboardData = widget.dashboardData ?? {};
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spending Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  items: ['week', 'month', 'quarter', 'year'].map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: _buildSpendingTrendData(dashboardData),
                  titlesData: FlTitlesData(
                    leftTitles: [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ],
                    bottomTitles: [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ],
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildSpendingTrendSpots(dashboardData),
                      isCurved: true,
                      barWidth: 3,
                      color: theme.colorScheme.primary,
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCategoryChart(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBudgetProgressChart(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context) {
    final theme = Theme.of(context);
    final dashboardData = widget.dashboardData ?? {};
    final categoryData = dashboardData['categoryBreakdown'] ?? {};
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: PieChart(
        PieChartData(
          sections: categoryData.entries.map((entry) {
            final value = entry.value as double;
            final color = _getCategoryColor(entry.key);
            return PieChartSectionData(
              color: color,
              value: value,
              title: entry.key,
              radius: 40,
              titleStyle: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface,
              ),
              valueStyle: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
        ),
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        centerSpaceColor: theme.colorScheme.surface,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildBudgetProgressChart(BuildContext context) {
    final theme = Theme.of(context);
    final dashboardData = widget.dashboardData ?? {};
    final budgetData = dashboardData['budgetProgress'] ?? [];
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: BarChart(
        BarChartData(
          groups: budgetData.map((budget) {
            return BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: budget['spent'],
                  color: _getBudgetUsedColor(budget['percentage']),
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                BarChartRodData(
                  toY: budget['total'],
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
              ),
            );
          }).toList(),
          ),
          titlesData: FlTitlesData(
            show: true,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                child: Text(
                  budget['name'],
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: false,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final theme = Theme.of(context);
    final dashboardData = widget.dashboardData ?? {};
    final recentExpenses = dashboardData['recentExpenses'] ?? [];
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: recentExpenses.take(5).map((expense) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: _getCategoryColor(expense['category']),
                    child: Text(
                      expense['description'][0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(expense['description']),
                  subtitle: Text(
                    '${expense['amount']} • ${expense['date']}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  trailing: Text(
                    expense['category'],
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    // Navigate to expense details
                    widget.onNavigate?.call('/expense/${expense['id']}');
                  },
                );
              );
            }).toList(),
          ),
            if (recentExpenses.length > 5)
                TextButton(
                  onPressed: () {
                    widget.onNavigate?.call('/expenses');
                  child: Text('View All'),
                ),
                ),
          ],
        ),
      ),
    );
  }

  Color _getBudgetUsedColor(double percentage) {
    if (percentage >= 90) {
      return Colors.red;
    } else if (percentage >= 75) {
      return Colors.orange;
    } else if (percentage >= 50) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'food': Colors.red,
      'transportation': Colors.blue,
      'entertainment': Colors.purple,
      'shopping': Colors.pink,
      'bills': Colors.orange,
      'healthcare': Colors.green,
      'education': Colors.indigo,
      'other': Colors.grey,
    };
    
    return colors[category] ?? Colors.grey;
  }

  List<FlSpot> _buildSpendingTrendSpots(Map<String, dynamic> dashboardData) {
    final spendingData = dashboardData['spendingTrend'] ?? [];
    
    return spendingData.asMap().entries.map((entry) {
      final index = entry.key;
      return FlSpot(index.toDouble(), entry.value as double);
    }).toList();
  }

  List<FlSpot> _buildSpendingTrendData(Map<String, dynamic> dashboardData) {
    final spendingData = dashboardData['spendingTrend'] ?? [];
    
    return spendingData.asMap().entries.map((entry) {
      final index = entry.key;
      return FlSpot(index.toDouble(), entry.value as double);
    }).toList();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays ~/ 7)} weeks ago';
    } else {
      return '${(difference.inDays ~/ 30)} months ago';
    }
  }
}
