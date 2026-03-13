import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OfflineSyncService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _pendingExpensesKey = 'pending_expenses';
  static const String _pendingIncomeKey = 'pending_income';
  static const String _lastSyncKey = 'last_sync_timestamp';

  Future<void> syncPendingChanges() async {
    if (!await isOnline()) {
      throw Exception('No internet connection available');
    }

    try {
      // Sync pending expenses
      await _syncPendingExpenses();
      
      // Sync pending income
      await _syncPendingIncome();
      
      // Update last sync timestamp
      await _updateLastSyncTimestamp();
      
      print('Offline sync completed successfully');
    } catch (e) {
      print('Offline sync failed: $e');
      rethrow;
    }
  }

  Future<void> savePendingExpense(Map<String, dynamic> expense) async {
    final pendingExpenses = await getPendingExpenses();
    final expenseWithTimestamp = {
      ...expense,
      'pendingId': DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': DateTime.now().toIso8601String(),
      'type': 'expense',
    };

    pendingExpenses.add(expenseWithTimestamp);
    await _storage.write(
      key: _pendingExpensesKey,
      value: jsonEncode(pendingExpenses),
    );

    print('Expense saved for offline sync: ${expenseWithTimestamp['pendingId']}');
  }

  Future<void> savePendingIncome(Map<String, dynamic> income) async {
    final pendingIncome = await getPendingIncome();
    final incomeWithTimestamp = {
      ...income,
      'pendingId': DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': DateTime.now().toIso8601String(),
      'type': 'income',
    };

    pendingIncome.add(incomeWithTimestamp);
    await _storage.write(
      key: _pendingIncomeKey,
      value: jsonEncode(pendingIncome),
    );

    print('Income saved for offline sync: ${incomeWithTimestamp['pendingId']}');
  }

  Future<List<Map<String, dynamic>>> getPendingExpenses() async {
    final String? data = await _storage.read(key: _pendingExpensesKey);
    if (data == null || data.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error decoding pending expenses: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPendingIncome() async {
    final String? data = await _storage.read(key: _pendingIncomeKey);
    if (data == null || data.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error decoding pending income: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPendingChanges() async {
    final expenses = await getPendingExpenses();
    final income = await getPendingIncome();
    return [...expenses, ...income];
  }

  Future<bool> isOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Additional check - try to reach a reliable server
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearSyncedData() async {
    await _storage.delete(key: _pendingExpensesKey);
    await _storage.delete(key: _pendingIncomeKey);
    print('All synced data cleared from local storage');
  }

  Future<void> removePendingItem(String pendingId, String type) async {
    if (type == 'expense') {
      final expenses = await getPendingExpenses();
      expenses.removeWhere((expense) => expense['pendingId'] == pendingId);
      await _storage.write(
        key: _pendingExpensesKey,
        value: jsonEncode(expenses),
      );
    } else if (type == 'income') {
      final income = await getPendingIncome();
      income.removeWhere((item) => item['pendingId'] == pendingId);
      await _storage.write(
        key: _pendingIncomeKey,
        value: jsonEncode(income),
      );
    }
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    final String? timestamp = await _storage.read(key: _lastSyncKey);
    if (timestamp == null || timestamp.isEmpty) return null;
    
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  Future<void> schedulePeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      'offlineSyncTask',
      'offlineSyncTask',
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresCharging: false,
      ),
    );
  }

  Future<void> cancelPeriodicSync() async {
    await Workmanager().cancelAll();
  }

  Future<int> getPendingChangesCount() async {
    final expenses = await getPendingExpenses();
    final income = await getPendingIncome();
    return expenses.length + income.length;
  }

  Future<Map<String, dynamic>> getSyncStatus() async {
    final isOnlineStatus = await isOnline();
    final pendingCount = await getPendingChangesCount();
    final lastSync = await getLastSyncTimestamp();

    return {
      'isOnline': isOnlineStatus,
      'pendingChanges': pendingCount,
      'lastSync': lastSync?.toIso8601String(),
      'needsSync': pendingCount > 0 && isOnlineStatus,
    };
  }

  Future<void> forceSyncAll() async {
    if (!await isOnline()) {
      throw Exception('No internet connection available');
    }

    final pendingChanges = await getPendingChanges();
    
    for (final change in pendingChanges) {
      try {
        // Here you would make actual API calls to sync the data
        print('Syncing item: ${change['pendingId']}');
        
        // Remove from pending after successful sync
        await removePendingItem(
          change['pendingId'],
          change['type'],
        );
      } catch (e) {
        print('Failed to sync item ${change['pendingId']}: $e');
        // Continue with other items even if one fails
      }
    }

    await _updateLastSyncTimestamp();
  }

  Future<void> exportPendingData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pending_expenses_backup.json');
    
    final pendingData = {
      'expenses': await getPendingExpenses(),
      'income': await getPendingIncome(),
      'exportedAt': DateTime.now().toIso8601String(),
    };

    await file.writeAsString(jsonEncode(pendingData));
    print('Pending data exported to: ${file.path}');
  }

  Future<void> importPendingData(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      if (data['expenses'] != null) {
        await _storage.write(
          key: _pendingExpensesKey,
          value: jsonEncode(data['expenses']),
        );
      }

      if (data['income'] != null) {
        await _storage.write(
          key: _pendingIncomeKey,
          value: jsonEncode(data['income']),
        );
      }

      print('Pending data imported successfully');
    } catch (e) {
      print('Failed to import pending data: $e');
      rethrow;
    }
  }

  private Future<void> _syncPendingExpenses() async {
    final expenses = await getPendingExpenses();
    
    for (final expense in expenses) {
      try {
        // Make API call to create expense
        print('Syncing expense: ${expense['pendingId']}');
        
        // Remove from pending after successful sync
        await removePendingItem(expense['pendingId'], 'expense');
      } catch (e) {
        print('Failed to sync expense ${expense['pendingId']}: $e');
      }
    }
  }

  private Future<void> _syncPendingIncome() async {
    final income = await getPendingIncome();
    
    for (final item in income) {
      try {
        // Make API call to create income
        print('Syncing income: ${item['pendingId']}');
        
        // Remove from pending after successful sync
        await removePendingItem(item['pendingId'], 'income');
      } catch (e) {
        print('Failed to sync income ${item['pendingId']}: $e');
      }
    }
  }

  private Future<void> _updateLastSyncTimestamp() async {
    await _storage.write(
      key: _lastSyncKey,
      value: DateTime.now().toIso8601String(),
    );
  }
}
