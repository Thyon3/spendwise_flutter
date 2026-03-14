import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class StorageUtil {
  static const String _prefix = 'expense_tracker_';

  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_prefix}$key', value);
  }

  static Future<String?> getString(String key, {String? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_prefix}$key') ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_prefix}$key', value);
  }

  static Future<int?> getInt(String key, {int? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_prefix}$key') ?? defaultValue;
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_prefix}$key', value);
  }

  static Future<double?> getDouble(String key, {double? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${_prefix}$key') ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_prefix}$key', value);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${_prefix}$key') ?? defaultValue;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${_prefix}$key', value);
  }

  static Future<List<String>> getStringList(String key, {List<String>? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('${_prefix}$key') ?? defaultValue;
  }

  static Future<void> setIntList(String key, List<int> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${_prefix}$key', value.map((i) => i.toString()));
  }

  static Future<List<int>> getIntList(String key, {List<int>? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = await prefs.getStringList('${_prefix}$key') ?? defaultValue;
    return stringList.map((i) => int.tryParse(i) ?? 0);
  }

  static Future<void> setDoubleList(String key, List<double> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${_prefix}$key', value.map((i) => i.toString()));
  }

  static Future<List<double>> getDoubleList(String key, {List<double>? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = await prefs.getStringList('${_prefix}$key') ?? defaultValue;
    return stringList.map((i) => double.tryParse(i) ?? 0.0);
  }

  static Future<void> setBoolList(String key, List<bool> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${_prefix}$key', value.map((i) => i.toString()));
  }

  static Future<List<bool>> getBoolList(String key, {List<bool>? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = await prefs.getStringList('${_prefix}$key') ?? defaultValue;
    return stringList.map((i) => i == 'true');
  }

  static Future<void> setMap(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_prefix}$key', jsonEncode(value));
  }

  static Future<Map<String, dynamic>> getMap(String key, {Map<String, dynamic>? defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${_prefix}$key');
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return defaultValue ?? {};
      }
    }
    return defaultValue ?? {};
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_prefix}$key');
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('${_prefix}$key');
  }

  static Future<Set<String>> getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    return keys
        .where((key) => key.startsWith(_prefix))
        .map((key) => key.substring(_prefix.length))
        .toSet();
  }

  static Future<void> exportToFile(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final exportData = <String, String>{};
    
    for (final key in allKeys) {
      if (key.startsWith(_prefix)) {
        final value = prefs.getString(key);
        if (value != null) {
          exportData[key] = value;
        }
      }
    }

    final file = File(filePath);
    final sink = file.openWrite();
    sink.write(jsonEncode(exportData));
    await sink.close();
  }

  static Future<void> importFromFile(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }
    
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, String>;
    final prefs = await SharedPreferences.getInstance();
    
    for (final entry in data.entries) {
      await prefs.setString('${_prefix}${entry.key}', entry.value);
    }
  }

  static Future<void> exportToJSON(String filePath) async {
    await exportToFile(filePath);
  }

  static Future<void> importFromJSON(String filePath) async {
    await importFromFile(filePath);
  }

  static Future<void> backupToCloud(String cloudPath, {String? apiKey}) async {
    // In a real implementation, this would integrate with cloud storage
    // For now, just export to local file
    await exportToJSON('${cloudPath}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
  }

  static Future<void> restoreFromCloud(String cloudPath, {String? apiKey}) async {
    // In a real implementation, this would integrate with cloud storage
    // For now, just import from local file
    await importFromJSON('${cloudPath}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
  }

  static Future<Map<String, dynamic>> getStorageStats() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    
    int totalSize = 0;
    final typeStats = <String, int>{};
    
    for (final key in allKeys) {
      final value = prefs.getString(key);
      if (value != null) {
        totalSize += value.length;
        typeStats[key.split('_')[0]] = (typeStats[key.split('_')[0] ?? ''] ?? 0) + 1;
      }
    }

    return {
      'totalKeys': allKeys.length,
      'totalSize': totalSize,
      'typeStats': typeStats,
    };
  }

  static Future<void> cleanupExpiredData({int maxAgeDays = 30}) async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final expiredTime = DateTime.now().subtract(Duration(days: maxAgeDays)).millisecondsSinceEpoch;
    
    for (final key in allKeys) {
      final lastModified = await prefs.get(key);
      if (lastModified != null) {
        final lastModifiedTime = int.tryParse(lastModified) ?? 0;
        if (lastModifiedTime < expiredTime) {
          await prefs.remove(key);
        }
      }
    }
  }

  static Future<void> migrateData({
    Map<String, String>? migrations,
    String? fromVersion,
    String? toVersion,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = await getString('app_version', fromVersion ?? '1.0.0');
    
    if (currentVersion != toVersion && migrations != null) {
      for (final migration in migrations.entries) {
        final version = migration.key;
        final migrationFunction = migration.value;
        
        if (version.compareTo(currentVersion) > 0) {
          try {
            await migrationFunction();
            await setString('app_version', version);
            currentVersion = version;
          } catch (e) {
            print('Migration failed for version $version: $e');
          }
        }
      }
    }
  }

  static Future<void> resetToDefaults() async {
    await clear();
    // Set default values
    await setString('theme_mode', 'light');
    await setString('language', 'en');
    await setString('currency', 'USD');
    await setBool('notifications_enabled', true);
    await setBool('biometric_enabled', false);
    await setInt('items_per_page', 20);
    await setBool('auto_backup', false);
    await setBool('dark_mode', false);
    await setString('date_format', 'MM/dd/yyyy');
    await setString('time_format', '12h');
    await setBool('show_charts', true);
    await setBool('compact_mode', false);
    await setBool('animations_enabled', true);
  }

  static Future<void> exportUserData(String userId, String filePath) async {
    final userData = {
      'preferences': {},
      'settings': {},
      'cache': {},
      'logs': [],
    };

    // In a real implementation, gather all user-specific data
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final userPrefix = '${_prefix}user_${userId}_';
    
    for (final key in allKeys) {
      if (key.startsWith(userPrefix)) {
        final value = prefs.getString(key);
        if (value != null) {
          final keyWithoutPrefix = key.substring(userPrefix.length);
          userData['preferences'][keyWithoutPrefix] = value;
        }
      }
    }

    final file = File(filePath);
    final sink = file.openWrite();
    sink.write(jsonEncode(userData));
    await sink.close();
  }

  static Future<Map<String, dynamic>> importUserData(String userId, String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('User data file not found: $filePath');
    }
    
    final content = await file.readAsString();
    final userData = jsonDecode(content) as Map<String, dynamic>;
    
    final prefs = await SharedPreferences.getInstance();
    
    // Import user preferences back to SharedPreferences
    final userPrefix = '${_prefix}user_${userId}_';
    final preferences = userData['preferences'] as Map<String, String> ?? {};
    
    for (final entry in preferences.entries) {
      await setString('${userPrefix}${entry.key}', entry.value);
    }

    return userData;
  }

  static Future<void> syncToCloud(String userId, {String? cloudProvider}) async {
    // In a real implementation, sync data to cloud storage
    final userData = await exportUserData(userId, 'temp_user_data.json');
    await backupToCloud('cloud_backup_${userId}');
    await File('temp_user_data.json').delete();
  }

  static Future<void> syncFromCloud(String userId, {String? cloudProvider}) async {
    // In a real implementation, sync data from cloud storage
    await restoreFromCloud('cloud_backup_${userId}');
    final userData = await importUserData(userId, 'temp_user_data.json');
    await File('temp_user_data.json').delete();
  }

  static Future<void> clearUserData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userPrefix = '${_prefix}user_${userId}_';
    final allKeys = prefs.getKeys();
    
    for (final key in allKeys) {
      if (key.startsWith(userPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  static Future<bool> hasUserData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userPrefix = '${_prefix}user_${userId}_';
    return prefs.getKeys().any((key) => key.startsWith(userPrefix));
  }
}
