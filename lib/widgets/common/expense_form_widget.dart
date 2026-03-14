import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum ExpenseFormType {
  create,
  edit,
  duplicate,
}

class ExpenseFormWidget extends StatefulWidget {
  final ExpenseFormType type;
  final String? expenseId;
  final Function(Map<String, dynamic>)? onSaved;
  final VoidCallback? onCancel;
  final bool showAdvancedOptions;
  final bool enableAttachments;
  final bool enableRecurring;
  final bool enableSplitPayment;
  final String? initialCategoryId;
  final String? initialDescription;
  final double? initialAmount;
  final DateTime? initialDate;
  final List<String>? initialTags;
  final String? initialPaymentMethod;
  final String? initialNote;
  final String? initialReceiptUrl;

  const ExpenseFormWidget({
    Key? key,
    required this.type,
    this.expenseId,
    this.onSaved,
    this.onCancel,
    this.showAdvancedOptions = false,
    this.enableAttachments = true,
    this.enableRecurring = true,
    this.enableSplitPayment = false,
    this.initialCategoryId,
    this.initialDescription,
    this.initialAmount,
    this.initialDate,
    this.initialTags,
    this.initialPaymentMethod,
    this.initialNote,
    this.initialReceiptUrl,
  }) : super(key: key);

  @override
  State<ExpenseFormWidget> createState() => _ExpenseFormWidgetState();
}

class _ExpenseFormWidgetState extends State<ExpenseFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _tagsController = TextEditingController();
  final _receiptUrlController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String? _selectedPaymentMethod;
  List<String> _selectedTags = [];
  bool _isRecurring = false;
  String _recurringType = 'monthly';
  int _recurringInterval = 1;
  DateTime? _recurringEndDate;
  bool _isSplitPayment = false;
  int _splitCount = 2;
  List<double> _splitAmounts = [];
  bool _isLoading = false;
  String? _receiptImage;
  List<String> _availableCategories = [];
  List<String> _availablePaymentMethods = [];
  List<String> _availableTags = [];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadDropdownData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _tagsController.dispose();
    _receiptUrlController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    if (widget.type == ExpenseFormType.edit && widget.expenseId != null) {
      // Load existing expense data
      _loadExpenseData();
    } else {
      // Initialize with provided values
      _descriptionController.text = widget.initialDescription ?? '';
      _amountController.text = widget.initialAmount?.toString() ?? '';
      _selectedDate = widget.initialDate ?? DateTime.now();
      _selectedCategory = widget.initialCategoryId;
      _selectedPaymentMethod = widget.initialPaymentMethod;
      _selectedTags = List.from(widget.initialTags ?? []);
      _noteController.text = widget.initialNote ?? '';
      _receiptUrlController.text = widget.initialReceiptUrl ?? '';
      _receiptImage = widget.initialReceiptUrl;
    }
  }

  Future<void> _loadExpenseData() async {
    // In a real implementation, fetch expense data from API
    setState(() {
      _isLoading = true;
    });

    try {
      // Mock data - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _descriptionController.text = 'Sample Expense';
        _amountController.text = '50.00';
        _selectedDate = DateTime.now();
        _selectedCategory = 'food';
        _selectedPaymentMethod = 'credit_card';
        _selectedTags = ['restaurant', 'lunch'];
        _noteController.text = 'Business lunch with client';
        _receiptImage = 'https://example.com/receipt.jpg';
        _isRecurring = false;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  Future<void> _loadDropdownData() async {
    // In a real implementation, fetch from API
    setState(() {
      _availableCategories = [
        'food',
        'transportation',
        'entertainment',
        'shopping',
        'bills',
        'healthcare',
        'education',
        'other',
      ];
      
      _availablePaymentMethods = [
        'cash',
        'credit_card',
        'debit_card',
        'bank_transfer',
        'digital_wallet',
        'other',
      ];
      
      _availableTags = [
        'restaurant',
        'groceries',
        'gas',
        'utilities',
        'entertainment',
        'shopping',
        'travel',
        'business',
        'personal',
        'health',
      ];
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _receiptImage = pickedFile!.path;
      });
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      setState(() {
        _receiptImage = pickedFile!.path;
      });
    }
  }

  void _addTag(String tag) {
    if (!_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  void _calculateSplitAmounts() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final splitAmount = amount / _splitCount;
    
    setState(() {
      _splitAmounts = List.generate(_splitCount, (index) => splitAmount);
    });
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final expenseData = {
        'description': _descriptionController.text,
        'amount': double.tryParse(_amountController.text) ?? 0,
        'date': _selectedDate.toIso8601String(),
        'category': _selectedCategory,
        'paymentMethod': _selectedPaymentMethod,
        'tags': _selectedTags,
        'note': _noteController.text,
        'receiptUrl': _receiptImage,
        'isRecurring': _isRecurring,
        'recurringType': _recurringType,
        'recurringInterval': _recurringInterval,
        'recurringEndDate': _recurringEndDate?.toIso8601String(),
        'isSplitPayment': _isSplitPayment,
        'splitCount': _splitCount,
        'splitAmounts': _splitAmounts,
      };

      // In a real implementation, save to API
      await Future.delayed(const Duration(seconds: 2));

      widget.onSaved?.call(expenseData);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: widget.onCancel,
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: _isLoading ? null : _saveExpense,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter expense description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Date
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date!;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _selectedDate.toString().split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _availableCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Payment Method
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: _availablePaymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a payment method';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Tags Section
              _buildSectionHeader('Tags'),
              const SizedBox(height: 16),
              
              // Tags Input
              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags',
                  hintText: 'Enter tags',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_tagsController.text.isNotEmpty) {
                        _addTag(_tagsController.text);
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _addTag(value);
                  }
                },
              ),
              
              const SizedBox(height: 8),
              
              // Selected Tags
              if (_selectedTags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _selectedTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _removeTag(tag),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      deleteIcon: const Icon(Icons.close, size: 16),
                    );
                  }).toList(),
                ),
              
              const SizedBox(height: 24),
              
              // Receipt Section
              if (widget.enableAttachments)
                _buildSectionHeader('Receipt'),
              const SizedBox(height: 16),
              
              if (widget.enableAttachments) ...[
                // Receipt Image
                if (_receiptImage != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _receiptImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: theme.colorScheme.surface,
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      ),
                    ),
                  ),
                
                const SizedBox(height: 8),
                
                // Receipt Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _takePicture,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Advanced Options
              if (widget.showAdvancedOptions) ...[
                _buildSectionHeader('Advanced Options'),
                const SizedBox(height: 16),
                
                // Recurring Expense
                SwitchListTile(
                  title: const Text('Recurring Expense'),
                  subtitle: const Text('Set up automatic recurring expenses'),
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                ),
                
                if (_isRecurring) ...[
                  const SizedBox(height: 16),
                  
                  // Recurring Type
                  DropdownButtonFormField<String>(
                    value: _recurringType,
                    decoration: const InputDecoration(
                      labelText: 'Recurring Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                      DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                      DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _recurringType = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Recurring Interval
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interval',
                      hintText: '1',
                      border: OutlineInputBorder(),
                      suffixText: 'period(s)',
                    ),
                    initialValue: _recurringInterval.toString(),
                    onChanged: (value) {
                      setState(() {
                        _recurringInterval = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ],
                
                // Split Payment
                if (widget.enableSplitPayment) ...[
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Split Payment'),
                    subtitle: const Text('Split expense across multiple payments'),
                    value: _isSplitPayment,
                    onChanged: (value) {
                      setState(() {
                        _isSplitPayment = value;
                        if (value) {
                          _calculateSplitAmounts();
                        }
                      });
                    },
                  ),
                  
                  if (_isSplitPayment) ...[
                    const SizedBox(height: 16),
                    
                    // Split Count
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Number of Payments',
                        hintText: '2',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _splitCount.toString(),
                      onChanged: (value) {
                        setState(() {
                          _splitCount = int.tryParse(value) ?? 2;
                          _calculateSplitAmounts();
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Split Amounts
                    ...List.generate(_splitCount, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Payment ${index + 1}',
                            hintText: '0.00',
                            border: OutlineInputBorder(),
                            prefixText: '\$ ',
                          ),
                          initialValue: _splitAmounts.length > index
                              ? _splitAmounts[index].toStringAsFixed(2)
                              : '',
                          onChanged: (value) {
                            setState(() {
                              if (_splitAmounts.length > index) {
                                _splitAmounts[index] = double.tryParse(value) ?? 0;
                              }
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ],
              ],
              
              const SizedBox(height: 24),
              
              // Note Section
              _buildSectionHeader('Note'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Add any additional notes...',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (widget.type) {
      case ExpenseFormType.create:
        return 'Add Expense';
      case ExpenseFormType.edit:
        return 'Edit Expense';
      case ExpenseFormType.duplicate:
        return 'Duplicate Expense';
    }
  }
}
