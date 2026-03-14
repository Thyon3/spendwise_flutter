import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum ExpenseListType {
  list,
  grid,
  timeline,
}

enum SortOption {
  dateAsc,
  dateDesc,
  amountAsc,
  amountDesc,
  category,
  description,
}

enum FilterOption {
  all,
  today,
  thisWeek,
  thisMonth,
  thisYear,
  custom,
}

class ExpenseItem {
  final String id;
  final String description;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String categoryColor;
  final DateTime date;
  final List<String> tags;
  final String? receiptUrl;
  final String? note;
  final bool isRecurring;
  final String? paymentMethod;
  final bool isPending;
  final String? currency;

  const ExpenseItem({
    required this.id,
    required this.description,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.date,
    this.tags = const [],
    this.receiptUrl,
    this.note,
    this.isRecurring = false,
    this.paymentMethod,
    this.isPending = false,
    this.currency,
  });
}

class ExpenseListWidget extends StatefulWidget {
  final List<ExpenseItem> expenses;
  final ExpenseListType type;
  final Function(String)? onExpenseTap;
  final Function(String)? onExpenseLongPress;
  final Function(String)? onExpenseDelete;
  final Function(String)? onExpenseEdit;
  final Function(String)? onExpenseDuplicate;
  final Function(ExpenseItem)? onExpenseTogglePending;
  final Function(String)? onReceiptView;
  final Function(String)? onNoteView;
  final Function(String)? onEditTags;
  final Function(String)? onAddAttachment;
  final SortOption? sortBy;
  final FilterOption? filterBy;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final List<String>? selectedCategories;
  final List<String>? selectedTags;
  final double? minAmount;
  final double? maxAmount;
  final String? searchQuery;
  final bool showPendingOnly;
  final bool showRecurringOnly;
  final bool enableSelection;
  final bool enableSwipeActions;
  final bool showAmounts;
  final String currency;
  final bool isLoading;
  final String? emptyMessage;
  final Widget? header;
  final Widget? footer;
  final EdgeInsets? padding;
  final double? itemHeight;

  const ExpenseListWidget({
    Key? key,
    required this.expenses,
    this.type = ExpenseListType.list,
    this.onExpenseTap,
    this.onExpenseLongPress,
    this.onExpenseDelete,
    this.onExpenseEdit,
    this.onExpenseDuplicate,
    this.onExpenseTogglePending,
    this.onReceiptView,
    this.onNoteView,
    this.onEditTags,
    this.onAddAttachment,
    this.sortBy,
    this.filterBy,
    this.customStartDate,
    this.customEndDate,
    this.selectedCategories,
    this.selectedTags,
    this.minAmount,
    this.maxAmount,
    this.searchQuery,
    this.showPendingOnly = false,
    this.showRecurringOnly = false,
    this.enableSelection = false,
    this.enableSwipeActions = true,
    this.showAmounts = true,
    this.currency,
    this.isLoading = false,
    this.emptyMessage,
    this.header,
    this.footer,
    this.padding,
    this.itemHeight,
  }) : super(key: key);

  @override
  State<ExpenseListWidget> createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
  List<ExpenseItem> filteredExpenses = [];
  List<ExpenseItem> selectedExpenses = [];
  SortOption currentSort = SortOption.dateDesc;
  FilterOption currentFilter = FilterOption.all;
  String searchQuery = '';
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _filterExpenses();
  }

  @override
  void didUpdateWidget(ExpenseListWidget oldWidget, ExpenseListWidget newWidget) {
    super.didUpdateWidget(oldWidget, newWidget);
    
    if (oldWidget.expenses != newWidget.expenses ||
        oldWidget.sortBy != newWidget.sortBy ||
        oldWidget.filterBy != newWidget.filterBy ||
        oldWidget.selectedCategories != newWidget.selectedCategories ||
        oldWidget.selectedTags != newWidget.selectedTags ||
        oldWidget.minAmount != newWidget.minAmount ||
        oldWidget.maxAmount != newWidget.maxAmount ||
        oldWidget.searchQuery != newWidget.searchQuery ||
        oldWidget.showPendingOnly != newWidget.showPendingOnly ||
        oldWidget.showRecurringOnly != newWidget.showRecurringOnly) {
      _filterExpenses();
    }
  }

  void _filterExpenses() {
    setState(() {
      filteredExpenses = widget.expenses.where((expense) {
        // Filter by search query
        if (widget.searchQuery.isNotEmpty) {
          final query = widget.searchQuery.toLowerCase();
          if (!expense.description.toLowerCase().contains(query) &&
              !expense.categoryName.toLowerCase().contains(query) &&
              !expense.tags.any((tag) => tag.toLowerCase().contains(query))) {
            return false;
          }
        }

        // Filter by date range
        if (widget.customStartDate != null && widget.customEndDate != null) {
          if (expense.date.isBefore(widget.customStartDate!) ||
              expense.date.isAfter(widget.customEndDate!)) {
            return false;
          }
        }

        // Filter by amount range
        if (widget.minAmount != null && expense.amount < widget.minAmount) {
          return false;
        }
        if (widget.maxAmount != null && expense.amount > widget.maxAmount) {
          return false;
        }

        // Filter by categories
        if (widget.selectedCategories != null &&
            widget.selectedCategories!.isNotEmpty &&
            !widget.selectedCategories!.contains(expense.categoryId)) {
          return false;
        }

        // Filter by tags
        if (widget.selectedTags != null &&
            widget.selectedTags!.isNotEmpty &&
            !expense.tags.any((tag) => widget.selectedTags!.contains(tag))) {
          return false;
        }

        // Filter by status
        if (widget.showPendingOnly && !expense.isPending) {
          return false;
        }
        if (widget.showRecurringOnly && !expense.isRecurring) {
          return false;
        }

        return true;
      });
    });

    // Sort the filtered expenses
    _sortExpenses();
  }

  void _sortExpenses() {
    setState(() {
      switch (widget.sortBy!) {
        case SortOption.dateAsc:
          filteredExpenses.sort((a, b) => a.date.compareTo(b.date));
          break;
        case SortOption.dateDesc:
          filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
          break;
        case SortOption.amountAsc:
          filteredExpenses.sort((a, b) => a.amount.compareTo(b.amount));
          break;
        case SortOption.amountDesc:
          filteredExpenses.sort((a, b) => b.amount.compareTo(a.amount));
          break;
        case SortOption.category:
          filteredExpenses.sort((a, b) => a.categoryName.compareTo(b.categoryName));
          break;
        case SortOption.description:
          filteredExpenses.sort((a, b) => a.description.compareTo(b.description));
          break;
      }
    });
  }

  void _toggleSelection(String expenseId) {
    setState(() {
      if (selectedExpenses.contains(expenseId)) {
        selectedExpenses.remove(expenseId);
      } else {
        selectedExpenses.add(expenseId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      selectedExpenses = filteredExpenses.map((e) => e.id).toList();
    });
  }

  void _clearSelection() {
    setState(() {
      selectedExpenses.clear();
      isSelectionMode = false;
    });
  }

  Widget _buildList() {
    if (filteredExpenses.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = filteredExpenses[index];
        return _buildExpenseItem(expense);
      },
    );
  }

  Widget _buildGrid() {
    if (filteredExpenses.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
      ),
      itemCount: filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = filteredExpenses[index];
        return _buildExpenseCard(expense);
      },
    );
  }

  Widget _buildTimeline() {
    if (filteredExpenses.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = filteredExpenses[index];
        return _buildTimelineItem(expense);
      },
    );
  }

  Widget _buildExpenseItem(ExpenseItem expense) {
    final theme = Theme.of(context);
    final isSelected = selectedExpenses.contains(expense.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 4 : 1,
        child: InkWell(
          onTap: () => widget.onExpenseTap?.call(expense.id),
          onLongPress: () => widget.onExpenseLongPress?.call(expense.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Category indicator
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(int.parse(expense.categoryColor)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Expense details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              expense.description,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.showAmounts)
                            Text(
                              widget.currency != null
                                  ? '${widget.currency} ${expense.amount.toStringAsFixed(2)}'
                                  : expense.amount.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ],
                      
                      // Tags
                      if (expense.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: expense.tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )).toList(),
                        ),
                      
                      // Status indicators
                      Row(
                        children: [
                          if (expense.isPending)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (expense.isRecurring)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Recurring',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (expense.receiptUrl != null)
                            IconButton(
                              icon: const Icon(Icons.receipt),
                              onPressed: () => widget.onReceiptView?.call(expense.id),
                            ),
                          if (expense.note != null)
                            IconButton(
                              icon: const Icon(Icons.note),
                              onPressed: () => widget.onNoteView?.call(expense.id),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Amount and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.showAmounts)
                      Text(
                        widget.currency != null
                            ? '${widget.currency} ${expense.amount.toStringAsFixed(2)}'
                            : expense.amount.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    Text(
                      _formatDate(expense.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseItem expense) {
    final theme = Theme.of(context);
    final isSelected = selectedExpenses.contains(expense.id);

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => widget.onExpenseTap?.call(expense.id),
        onLongPress: () => widget.onExpenseLongPress?.call(expense.id),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Category indicator
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(int.parse(expense.categoryColor)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Amount
                  if (widget.showAmounts)
                    Text(
                      widget.currency != null
                          ? '${widget.currency} ${expense.amount.toStringAsFixed(0)}'
                          : expense.amount.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                expense.description,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Tags
              if (expense.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: expense.tags.map((tag) => Chip(
                    label: tag,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )).toList(),
                ),
              
              // Date
              Text(
                _formatDate(expense.date),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(ExpenseItem expense) {
    final theme = Theme.of(context);
    final isSelected = selectedExpenses.contains(expense.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Color(int.parse(expense.categoryColor)),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.white, size: 12)
                  : null,
            ),
          ),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      expense.description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    if (widget.showAmounts)
                      Text(
                        widget.currency != null
                            ? '${widget.currency} ${expense.amount.toStringAsFixed(2)}'
                            : expense.amount.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                
                Text(
                  _formatDate(expense.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyMessage ?? 'No expenses found',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Start adding expenses to track your spending',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          
          // Search bar
          if (widget.searchQuery != null || widget.filterBy != FilterOption.all || widget.selectedCategories != null || widget.selectedTags != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search expenses...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: widget.searchQuery != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            // Clear search
                          setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          
          // Filters
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Filter by date
                  DropdownButton<String>(
                    value: _getFilterLabel(widget.filterBy),
                    items: FilterOption.values.map((option) => DropdownMenuItem(
                      value: option.toString(),
                      child: Text(_getFilterLabel(option)),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentFilter = FilterOption.values.firstWhere((opt) => opt.toString() == value);
                      });
                    },
                  ),
                  
                  // Sort by
                  DropdownButton<String>(
                    value: _getSortLabel(widget.sortBy),
                    items: SortOption.values.map((option) => DropdownMenuItem(
                      value: option.toString(),
                      child: Text(_getSortLabel(option)),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentSort = SortOption.values.firstWhere((opt) => opt.toString() == value);
                      });
                    },
                  ),
                  
                  // Selection mode toggle
                  if (widget.enableSelection)
                    IconButton(
                      icon: Icon(isSelectionMode ? Icons.check_circle : Icons.radio_button_unchecked),
                      onPressed: _toggleSelection,
                      color: isSelectionMode ? theme.colorScheme.primary : null,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    if (widget.footer != null) {
      return widget.footer!;
    }

    final theme = Theme.of(context);
    final total = filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${filteredExpenses.length} expenses',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            widget.currency != null
                ? 'Total: ${widget.currency} ${total.toStringAsFixed(2)}'
                : 'Total: ${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getFilterLabel(FilterOption? filter) {
    switch (filter) {
      case FilterOption.all:
        return 'All';
      case FilterOption.today:
        return 'Today';
      case FilterOption.thisWeek:
        return 'This Week';
      case FilterOption.thisMonth:
        return 'This Month';
      case FilterOption.thisYear:
        return 'This Year';
      case FilterOption.custom:
        return 'Custom';
    }
  }

  String _getSortLabel(SortOption? sort) {
    switch (sort) {
      case SortOption.dateAsc:
        return 'Date (Oldest)';
      case SortOption.dateDesc:
        return 'Date (Newest)';
      case SortOption.amountAsc:
        return 'Amount (Low to High)';
      case SortOption.amountDesc:
        return 'Amount (High to Low)';
      case SortOption.category:
        return 'Category';
      case SortOption.description:
        return 'Description';
    }
  }

  String _formatDate(DateTime date) {
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
      return '${difference.inDays ~/ 30} months ago';
    }
  }

  void _toggleSelection() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedExpenses.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: widget.header != null ? AppBar(
        title: widget.header,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          if (widget.enableSelection)
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'select_all',
                  child: const Text('Select All'),
                  onTap: () => _selectAll(),
                ),
                PopupMenuItem(
                  value: 'clear_selection',
                  child: const Text('Clear Selection'),
                  onTap: () => _clearSelection(),
                ),
              ],
            ),
        ],
      ) : null,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildContent(),
          ),
          if (widget.footer != null) _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.type) {
      case ExpenseListType.list:
        return _buildList();
      case ExpenseListType.grid:
        return _buildGrid();
      case ExpenseListType.timeline:
        return _buildTimeline();
    }
  }
}
