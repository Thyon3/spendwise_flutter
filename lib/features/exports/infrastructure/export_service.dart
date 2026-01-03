import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/network/network_providers.dart';
import 'data_sources/exports_remote_data_source.dart';

class ExportService {
  final ExportsRemoteDataSource _remoteDataSource;

  ExportService(this._remoteDataSource);

  Future<void> exportAndShareExpenses({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    String? tagId,
    String? search,
  }) async {
    final file = await _remoteDataSource.exportExpensesToCsv(
      from: from,
      to: to,
      categoryId: categoryId,
      tagId: tagId,
      search: search,
    );

    await Share.shareXFiles([XFile(file.path)], text: 'My Expenses Export');
  }
}

final exportsRemoteDataSourceProvider = Provider<ExportsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ExportsRemoteDataSource(apiClient);
});

final exportServiceProvider = Provider<ExportService>((ref) {
  final remoteDataSource = ref.watch(exportsRemoteDataSourceProvider);
  return ExportService(remoteDataSource);
});
